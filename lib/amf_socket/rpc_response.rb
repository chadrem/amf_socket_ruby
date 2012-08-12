class AmfSocket::RpcResponse
  attr_reader :connection
  attr_reader :message_id
  attr_reader :command
  attr_reader :params
  attr_reader :result

  def initialize(request_object, response_object, connection)
    raise RpcSocket::InvalidObject unless validate_object(response_object)

    req = request_object[:request]
    res = response_object[:response]

    @connection = connection
    @message_id = req[:messageId]
    @command = req[:command]
    @params = req[:params]
    @result = res[:result]
  end

  private

  def validate_object(object)
    return false unless object.is_a?(Hash)
    return false unless object[:type] == 'rpcResponse'
    return false unless object[:response].is_a?(Hash)
    return false unless object[:response][:messageId].is_a?(String)
    return false unless object[:response][:result].is_a?(String)

    return true
  end
end
