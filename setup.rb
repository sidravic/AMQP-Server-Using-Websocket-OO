class Setup < EM::Connection
  def initialize(args)
    @socket_manager = args.first
    @channel = args.last
  end

  def post_init
    puts "[STATUS] : Queue initialization done."
  end

  # receives data in the form of => {roomname:"harry_potter", status:'status', op:'create_room'}
  # other values for status include
  # status: add_member
  # status: remove_member

  def receive_data(data)
    puts " >> Data #{data}"
    @data = MessageParser.parse(data)
    puts "JSON data #{@data}"
    @worker = Worker.new(@channel, @data[:roomname], @socket_manager)
    exchange = @channel.direct(@data[:roomname])
    @worker.start(exchange)
    send_data('200')
  end

  def unbind
    puts "connection lost "
  end
end