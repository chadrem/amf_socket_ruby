class AmfSocket::AmfRpcConnection < AmfSocket::AmfConnection
  def receive_object(object)
    close_connection unless validate_object(object)

    request = AmfSocket::RpcRequest.new(object['messageId'], object['command'], object['params'], self)
    receive_request(request)
  end

  def receive_request(request)
    # Override this method in your subclass.
    debugger
    puts '5'
  end

  private

  def validate_object(object)
    return false unless object.is_a?(Hash)
    return false unless %(rpcRequest rpcResponse).include?(object['type'])
    return false unless object.request.is_a?(Hash)
    return false unless object.request['command'].is_a?(String)
    return false unless object.request['params'].is_a?(Hash)
    return false unless object.request['messageId'].is_a?(String)

    return true
  end
end
