class AmfSocket::RpcReceivedRequest
  attr_reader :connection
  attr_reader :state # Valid states: :initialized, replied.

  def initialize(object, connection)
    raise AmfSocket::InvalidObject unless validate_object(object)

    @request_obj = object[:request]
    @connection = connection
    @state = :initialized
  end

  def message_id
    return @request_obj[:messageId]
  end

  def command
    return @request_obj[:command]
  end

  def params
    return @request_obj[:params]
  end

  def reply(result)
    return false if @state == :replied

    object = {}
    object[:type] = 'rpcResponse'
    object[:response] = {}
    object[:response][:messageId] = message_id
    object[:response][:result] = result

    @connection.send_object(object)

    return true
  end

  private

  def validate_object(object)
    return false unless object.is_a?(Hash)
    return false unless object[:type] == 'rpcRequest'
    return false unless object[:request].is_a?(Hash)
    return false unless object[:request][:command].is_a?(String)
    return false unless object[:request][:params].is_a?(Hash)
    return false unless object[:request][:messageId].is_a?(String)

    return true
  end
end
