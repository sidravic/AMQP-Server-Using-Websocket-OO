class Producer
  def initialize(channel, exchange)
    @channel =  channel
    @exchange = exchange
  end

  def publish(message, options = {})
    puts "[STATUS] : Message Published #{message}"
    @exchange.publish(message, options)
  end
end