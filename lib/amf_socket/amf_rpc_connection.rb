class AmfSocket::AmfRpcConnection < AmfSocket::AmfConnection
  PING_INTERVAL = 5 # Seconds.

  attr_reader :latency

  def send_request(command, params = {}, &block)
    request = AmfSocket::RpcRequest.new(command, params)
    block.call(request)
    @sent_requests[request.message_id] = request
    send_object(request.to_hash)
    request.send(:sent)
  end

  def send_message(command, params = {})
    message = AmfSocket::RpcMessage.new(command, params)
    send_object(message.to_hash)
    message.send(:sent)
  end

  #
  # EM Callbacks.
  #

  def post_init
    super

    @sent_requests = {}
    @next_ping = Time.now.utc

    AmfSocket.heartbeat.add(self)
  end

  def receive_object(object)
    begin
      raise AmfSocket::InvalidObject unless object.is_a?(Hash) && object['type']

      case object['type']
      when 'rpcRequest'
        request = AmfSocket::RpcReceivedRequest.new(object, self)
        case request.command
        when 'amf_socket_ping'
          receive_ping_request(request)
        else
          receive_request(request)
        end
      when 'rpcResponse'
        receive_response(object)
      when 'rpcMessage'
        message = AmfSocket::RpcReceivedMessage.new(object, self)
        receive_message(message)
      else
        raise AmfSocket::InvalidObject
      end
    rescue AmfSocket::InvalidObject
      close_connection
    end
  end

  def unbind
    AmfSocket.heartbeat.remove(self)

    @sent_requests.each do |message_id, request|
      if request.failed_callback.is_a?(Proc)
        request.failed_callback.call('disconnected')
      end
    end

    @sent_requests.clear
  end

  #
  # AMF RPC Connection Callbacks.
  #

  # Override this method in your subclass.
  def receive_request(request)
    request.reply("You should override #{self.class.to_s}#receive_request.")
  end

  # Respond to server ping requests (when used with EM.connect for client side sockets).
  def receive_ping_request(request)
    request.reply(nil)
  end

  # Override this method in your subclass.
  def receive_message(message)
  end

  def receive_response(response_object)
    raise AmfSocket::InvalidObject unless (message_id = response_object['response']['messageId'])

    return unless (request = @sent_requests[message_id]) # Ignore timed out requests.

    response = AmfSocket::RpcResponse.new(request, response_object)
    @sent_requests.delete(message_id)

    AmfSocket.try do
      if request.succeeded_callback.is_a?(Proc)
        request.succeeded_callback.call(response)
      end
    end
  end

  def heartbeat
    timeout_requests
    ping
  end

  #
  # Private Methods.
  #

  private

  def timeout_requests
    @sent_requests.each do |message_id, request|
      if request.timed_out?
        AmfSocket.try do
          if request.failed_callback.is_a?(Proc)
            request.failed_callback.call('timed_out')
          end
        end

        @sent_requests.delete(message_id)
      end
    end
  end

  def ping
    return if @next_ping > Time.now.utc

    send_request('amf_socket_ping', :time => Time.now.utc.to_i, :latency => @latency.to_f) do |request|
      @next_ping = Time.now.utc + PING_INTERVAL

      request.timeout = 10

      request.succeeded do |response|
        @latency = Time.now.utc - request.sent_at
      end

      request.failed do |reason|
        close_connection if reason == 'timed_out'
      end
    end
  end
end
