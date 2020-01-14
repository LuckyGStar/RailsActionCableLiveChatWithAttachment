class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform message
    ActionCable.server.broadcast 'chat_channel', type: 'new_message', message: render_message(message), sender_id: message.sender_id, receiver_id: message.receiver_id, is_friend_request: message.is_friend_request
  end

  private

  def render_message message
    MessagesController.render partial: 'messages/ajax_message', locals: { message: message }
  end
end