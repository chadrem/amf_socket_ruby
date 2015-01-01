class AmfSocket::RpcMessage
  attr_reader :message_id
  attr_reader :command
  attr_reader :params
  attr_reader :sent_at

  def initialize(command, params = {})
    raise AmfSocket::InvalidArg.new('Command must be a String.') unless command.is_a?(String)
    raise AmfSocket::InvalidArg.new('Params must be a Hash.') unless params.is_a?(Hash)

    @command = command
    @params = params
    @message_id = SecureRandom.hex
  end

  def to_hash
    object = {}

    object['type'] = 'rpcMessage'
    object['message'] = {}
    object['message']['messageId'] = message_id
    object['message']['command'] = command
    object['message']['params'] = params

    return object
  end

  private

  def sent
    @sent_at = Time.now.utc
  end
end
