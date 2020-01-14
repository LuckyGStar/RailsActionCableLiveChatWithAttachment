class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_channel'
  end
  
  def unsubscribed
  end
  
  def send_message(data)
    message_body = data['message']
    message = Message.new(
      body: message_body['content'],
      sender_id: current_user.id,
      receiver_id: message_body['receiver_id'],
      is_friend_request: message_body['is_friend_request']
    )
    
    if data['file_uri']
      message.attachment_name = data['original_name']
      message.attachment_data_uri = data['file_uri']
    end
    
    message.save
  end
  
  def accept_friend_request(data)
    byebug
    ActionCable.server.broadcast 'chat_channel', type: 'accept_friend_request', data: data
  end
end