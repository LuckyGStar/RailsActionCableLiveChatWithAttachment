class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'chat_channel'
  end
  
  def unsubscribed
  end
  
  def send_message(data)
    current_user.messages.create(body: data['message'])
  end
end