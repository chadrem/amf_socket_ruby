class AmfSocket::AmfRpcConnection < AmfSocket::AmfConnection
  def send_request(command, params = {}, &block)
    request = AmfSocket::RpcRequest.new(command, params)
    block.call(request)
    @sent_requests[request.message_id] = request
    send_object(request.to_hash)
  end

  def send_message(command, params = {})
    message = AmfSocket::RpcMessage.new(command, params)
    send_object(message.to_hash)
  end

  #
  # EM Callbacks.
  #

  def post_init
    super
    @sent_requests = {}
  end

  def receive_object(object)
    begin
      raise AmfSocket::InvalidObject unless object.is_a?(Hash) && object[:type]

      case object[:type]
      when 'rpcRequest'
        request = AmfSocket::RpcReceivedRequest.new(object, self)
        receive_request(request)
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

  # Override this method in your subclass.
  def receive_message(message)
  end

  def receive_response(response_object)
    raise AmfSocket::InvalidObject unless (message_id = response_object[:response][:messageId])
    raise AmfSocket::InvalidObject unless (request = @sent_requests[message_id])

    response = AmfSocket::RpcResponse.new(request, response_object)
    @sent_requests.delete(message_id)

    if request.succeeded_callback.is_a?(Proc)
      request.succeeded_callback.call(response)
    end
  end
end
