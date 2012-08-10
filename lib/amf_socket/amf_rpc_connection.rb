class AmfSocket::AmfRpcConnection < AmfSocket::AmfConnection
  def receive_object(object)
    request = nil

    begin
      request = AmfSocket::RpcRequest.new(object, self)
    rescue AmfSocket::InvalidRequest => e
      close_connection
      return
    end

    receive_request(request)
  end

  # Override this method in your subclass.
  def receive_request(request)
    request.reply('You should override AmfSocket::AmfRpcConenction in a subclass.')
  end
end
