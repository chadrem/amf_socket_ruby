class AmfSocket::RpcRequest
  attr_reader :message_id
  attr_reader :command
  attr_reader :params
  attr_reader :amf_connection
  attr_reader :state # Valid states: :received, replied.

  def initialize(message_id, command, params, amf_connection)
    @message_id = message_id
    @command = command
    @params = params
    @amf_connection = amf_connection
    @state = :received
  end

  def reply(result)
    return false if @state == :replied

    object = {}
    object[:type] = 'rpcResponse'
    object[:response] = {}
    object[:response][:command] = @command
    object[:response][:params] = @params
    object[:response][:messageId] = @message_id
    object[:response][:result] = result

    @amf_connection.send_object(object)

    return true
  end
end
