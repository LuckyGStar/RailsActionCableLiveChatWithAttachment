class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_channel'
  end
  
  def unsubscribed
  end
  
  def send_message(data)
    # message = current_user.messages.build(body: data['message'])
    message_body = data['message']
    message = Message.new(body: message_body['content'], sender_id: current_user.id, receiver_id: message_body['receiver_id'])
    
    if data['file_uri']
      message.attachment_name = data['original_name']
      message.attachment_data_uri = data['file_uri']
    end
    
    message.save
  end
end