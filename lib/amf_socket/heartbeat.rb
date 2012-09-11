class AmfSocket::Heartbeat
  INTERVAL = 1 # Seconds.

  def initialize
    @objects = Set.new
    start unless AmfSocket.test_mode?
  end

  def start
    return false unless @timer.nil?

    @timer = EM::PeriodicTimer.new(INTERVAL, method(:timer_handler))

    return true
  end

  def stop
    return false unless @timer

    @timer.cancel
    @timer = nil

    return true
  end

  def add(object)
    return false if @objects.include?(object)

    @objects.add(object)

    return true
  end

  def remove(object)
    return false unless @objects.include?(object)

    @objects.delete(object)

    return true
  end

  private

  def timer_handler
    @objects.each do |object|
      AmfSocket.try do
        object.send(:heartbeat) if object.respond_to?(:heartbeat, true)
      end
    end
  end
end
