class AmfSocket::RpcRequest
  attr_reader :state # Valid states: :initialized, :sent, :responded.
  attr_reader :message_id
  attr_reader :command
  attr_reader :params

  attr_accessor :succeeded_callback
  attr_accessor :failed_callback
  attr_accessor :timeout

  def initialize(command, params = {})
    raise AmfSocket::InvalidArg.new('Command must be a String.') unless command.is_a?(String)
    raise AmfSocket::InvalidArg.new('Params must be a Hash.') unless params.is_a?(Hash)

    @command = command
    @params = params
    @state = :initialized
    @message_id = SecureRandom.hex
  end

  def succeeded(&block)
    @succeeded_callback = block
  end

  def failed(&block)
    @failed_callback = block
  end

  def to_hash
    object = {}

    object[:type] = 'rpcRequest'
    object[:request] = {}
    object[:request][:messageId] = message_id
    object[:request][:command] = command
    object[:request][:params] = params

    return object
  end
end
