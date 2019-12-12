class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform message
    ActionCable.server.broadcast 'chat_channel', message: render_message(message), user: message.user.id
  end

  private

  def render_message message
    MessagesController.render partial: 'messages/ajax_message', locals: { message: message }
  end
end