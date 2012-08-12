class AmfSocket::AmfRpcConnection < AmfSocket::AmfConnection
  def send_request(command, params = {}, &block)
    message_id = SecureRandom.hex

    object = {}
    object[:type] = 'rpcRequest'
    object[:request] = {}
    object[:request][:messageId] = message_id
    object[:request][:command] = command
    object[:request][:params] = params

    @sent_requests[message_id] = [object, block]

    send_object(object)
  end

  def send_message(command, params = {})
    object = {}
    object[:type] = 'rpcMessage'
    object[:message] = {}
    object[:message][:messageId] = SecureRandom.hex
    object[:message][:command] = command
    object[:message][:params] = params

    send_object(object)
  end

  private

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
        request = AmfSocket::RpcRequest.new(object, self)
        receive_request(request)
      when 'rpcResponse'
        receive_response(object)
      when 'rpcMessage'
        message = AmfSocket::RpcMessage.new(object, self)
        receive_message(message)
      else
        raise AmfSocket::InvalidObject
      end
    rescue AmfSocket::InvalidObject => e
      close_connection
    end
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
    raise AmfSocket::InvalidObject unless (sent_request = @sent_requests[message_id])

    request_object = sent_request[0]
    block = sent_request[1]
    response = AmfSocket::RpcResponse.new(request_object, response_object, self)

    @sent_requests.delete(message_id)

    block.call(response)
  end
end
