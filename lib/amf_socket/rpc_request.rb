class AmfSocket::RpcRequest
  attr_reader :state # Valid states: :initialized, :sent, :responded, :failed.
  attr_reader :message_id
  attr_reader :command
  attr_reader :params
  attr_reader :sent_at
  attr_reader :timeout_at

  attr_accessor :succeeded_callback
  attr_accessor :failed_callback

  TIMEOUT = 30 # Seconds.

  def initialize(command, params = {})
    raise AmfSocket::InvalidArg.new('Command must be a String.') unless command.is_a?(String)
    raise AmfSocket::InvalidArg.new('Params must be a Hash.') unless params.is_a?(Hash)

    @command = command
    @params = params
    @state = :initialized
    @message_id = SecureRandom.hex
    @timeout = TIMEOUT
  end

  def succeeded(&block)
    require_state(:initialized)

    @succeeded_callback = block
  end

  def failed(&block)
    require_state(:initialized)

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

  def timeout=(seconds)
    require_state(:initialized)

    @timeout = seconds
  end

  def timeout
    return @timeout
  end

  def timed_out?
    return Time.now.utc >= @timeout_at
  end

  private

  def sent
    require_state(:initialized)

    @state = :sent
    @sent_at = Time.now.utc
    @timeout_at = @sent_at + timeout
  end

  def require_state(s)
    raise 'Invalid state' unless @state == s
  end
end
