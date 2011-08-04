require 'rubygems'
require 'amqp'
require 'mongo'
require 'em-websocket'
require 'json'
require 'evma_httpserver'
require File.expand_path('../message_parser.rb', __FILE__)
require File.expand_path('../producer.rb', __FILE__)
require File.expand_path('../worker.rb', __FILE__)
require File.expand_path('../consumer.rb', __FILE__)
require File.expand_path('../http_server.rb', __FILE__)
require File.expand_path('../setup.rb', __FILE__)
require File.expand_path('../socket_manager', __FILE__)


# start the run loop
EventMachine.run do
  connection = AMQP.connect(:host => '127.0.0.1', :port => 5672)
  channel = AMQP::Channel.new(connection)

  socket_manager = SocketManager.new
  EventMachine.start_server('127.0.0.1', 8082, Setup, [socket_manager, channel])
# EventMachine.start_server('127.0.0.1', 8081, HttpServer, channel)

  puts "---- Server started on 8081 -----"


   EventMachine::WebSocket.start(:host => '127.0.0.1', :port => 9000) do |ws|

    ws.onopen do
      puts "EStaiblished......"
      ws.send('Connection open')

     puts ">>>>>>>>#{ws.request["query"]} <<<<<<<<<<"
     roomname = ws.request["query"]["roomname"]
     username = ws.request["query"]["username"]


     SocketManager.new().add_socket(roomname, ws)
    end

    ws.onmessage do |message|
      puts "message .... #{message}"
      message = MessageParser.parse(message)
      producer = Producer.new(channel, channel.direct(message[:roomname]))
      producer.publish(message[:message], :routing_key => message[:roomname])
    end

    ws.onclose do
      puts " socket connection closed."
      roomname = ws.request["query"]["roomname"]
      username = ws.request["query"]["username"]
      SocketManager.new().remove_socket(roomname, ws)
    end
  end
end
