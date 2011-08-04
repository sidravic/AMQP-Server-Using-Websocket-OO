class MessageParser
  def self.parse(message)
    parsed_message = JSON.parse(message)

    response = {}
    if parsed_message['status'] == 'status'
      response[:status] = 'STATUS'
      response[:roomname] = parsed_message['roomname']
    else
      response[:status] = 'MESSAGE'
      response[:message] = parsed_message['message']
      response[:username]= parsed_message['username']
      response[:roomname] = parsed_message['roomname']
    end

    response
  end
end