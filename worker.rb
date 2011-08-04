class Worker
  def initialize(channel, queue_name, socket_manager) #consumer = Consumer.new)
    puts "[STATUS] : WORKER Initialized."
    @queue_name = queue_name

    puts "QUEUE NAME #{queue_name}"
    @channel = channel
    @channel.on_error(&:handle_channel_exception) # same as  :& i.2 {|x| handle_channel_exception(x) }
    @consumer = Consumer.new(queue_name, socket_manager)
  end

  def start(s)
    @queue = @channel.queue(@queue_name, :durable => true).bind(s, :routing_key => s.name).subscribe do |h, p|
      @consumer.handle_message(h, p)
    end
  end

  def handle_channel_exception(channel, channel_close)
    puts "Oops... a channel-level exception: code = #{channel_close.reply_code}, message = #{channel_close.reply_text}"
  end
end