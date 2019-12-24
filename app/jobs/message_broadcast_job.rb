class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform message
    ActionCable.server.broadcast 'chat_channel', message: render_message(message), sender_id: message.sender_id, receiver_id: message.receiver_id
  end

  private

  def render_message message
    MessagesController.render partial: 'messages/ajax_message', locals: { message: message }
  end
end