class AmfSocket::AmfRpcConnection < AmfSocket::AmfConnection
  def receive_object(object)
    begin
      raise AmfSocket::InvalidObject unless object.is_a?(Hash) && object[:type]

      case object[:type]
      when 'rpcRequest'
        request = AmfSocket::RpcRequest.new(object, self)
        receive_request(request)
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

  # Override this method in your subclass.
  def receive_request(request)
    request.reply("You should override #{self.class.to_s}#receive_request.")
  end

  # Override this method in your subclass.
  def receive_message(message)
  end
end
