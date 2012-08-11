class AmfSocket::RpcRequest
  attr_reader :amf_connection
  attr_reader :state # Valid states: :initialized, replied.

  def initialize(object, amf_connection)
    raise RpcSocket::InvalidObject unless validate_object(object)

    @request_obj = object[:request]
    @amf_connection = amf_connection
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

    @amf_connection.send_object(object)

    return true
  end

  private

  def validate_object(object)
    return false unless object.is_a?(Hash)
    return false unless %(rpcRequest rpcResponse).include?(object[:type])
    return false unless object[:request].is_a?(Hash)
    return false unless object[:request][:command].is_a?(String)
    return false unless object[:request][:params].is_a?(Hash)
    return false unless object[:request][:messageId].is_a?(String)

    return true
  end
end
