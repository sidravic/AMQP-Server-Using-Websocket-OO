require 'evma_httpserver'

class HttpServer < EM::Connection
  include EM::HttpServer

  def initialize(channel)
    @channel = channel
    puts "[STATUS] : HttpServer Initialized."
  end

  def post_init
    super
    no_environment_strings
    puts "initied...................."
  end


  def process_http_request
    p    @http_protocol
    p    @http_request_method
    p    @http_cookie
    p    @http_if_none_match
    p    @http_content_type
    p    @http_path_info
    p    @http_request_uri
    p    @http_query_string
    p    @http_post_content
    p    @http_headers

    response = EM::DelegatedHttpResponse.new(self)
    response.status = 200
    response.content_type "application/json"
    response.content = {:message => "Welcome to the winter of my discontent"}.to_json
    response.send_response
  end
  # receives data in the form of => {roomname:"harry_potter", status:'status', op:'create_room'}
  # other values for status include
  # status: add_member
  # status: remove_member
#  def receive_data(data)
#    puts " >> Data "
#     #@data = MessageParser.parse(data)
#     #@worker = Worker.new(@channel, @data[:roomname], @socket_manager)
#     #@worker.start
#
#  end

  def unbind
    puts "connection lost "
  end
end