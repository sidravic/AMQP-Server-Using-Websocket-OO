class SocketAPI
  def self.api
    @sockets ||= {}
  end
end

class SocketManager
  attr_accessor :sockets

  def initialize
    @sockets = SocketAPI.api
  end

  def add_socket(roomname, sock)
    puts "=#{roomname}" * 50
    puts  "IN ADD SOCKET"
    puts "=" * 50
    puts "SOCKETS #{SocketAPI.api.inspect}"
    @sockets = SocketAPI.api
    if @sockets["#{roomname}"]
      puts "=" * 50
      puts "SOCKET HASH Exists"
      puts "=" * 50
      socket_array = @sockets["#{roomname}"]
      socket_array.push(sock)
    else
      #puts "=#{roomname.blank?}" * 50
      puts "SOCKET HASH DOES NOT Exists"
      puts "=" * 50
      @sockets[roomname.to_s] = []
      socket_array = @sockets["#{roomname}"]
      socket_array.push(sock)
    end
  end

  def remove_socket(roomname, sock)
    sockets = SocketAPI.api
    sockets["#{roomname}"].delete sock
  end
end