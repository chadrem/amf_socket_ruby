class AmfSocket::RpcMessage
  attr_reader :connection

  def initialize(object, connection)
    raise RpcSocket::InvalidObject unless validate_object(object)

    @message_obj = object[:message]
    @connection = connection
  end

  def message_id
    return @message_obj[:messageId]
  end

  def command
    return @message_obj[:command]
  end

  def params
    return @message_obj[:params]
  end

  private

  def validate_object(object)
    return false unless object.is_a?(Hash)
    return false unless object[:type] == 'rpcMessage'
    return false unless object[:message].is_a?(Hash)
    return false unless object[:message][:command].is_a?(String)
    return false unless object[:message][:params].is_a?(Hash)
    return false unless object[:message][:messageId].is_a?(String)

    return true
  end
end
