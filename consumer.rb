

class Consumer
  def initialize(roomname, socket_manager)
    puts "[STATUS] : CONSUMER Initialized."
    @socket_manager = socket_manager
    @roomname = roomname
  end

  def handle_message(metadata, payload)
    @socket_manager.sockets["#{@roomname}"].each do |ws|
      ws.send(payload)
    end
  end
end
