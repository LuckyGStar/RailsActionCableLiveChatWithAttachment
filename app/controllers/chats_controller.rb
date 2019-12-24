# controllers/chats_controller.rb

class ChatsController < ApplicationController
  before_action :require_login
  
  def index
    @messages = Message.order(created_at: :asc)
    @users = User.all
  end
  
  def list_messages
    active_user_id = params[:id]
    
    @messages = Message.where(sender_id: current_user.id, receiver_id: active_user_id).or(Message.where(sender_id: active_user_id, receiver_id: current_user.id))
    # @messages = Message.where(sender_id: active_user_id, receiver_id: current_user.id)
    
    render partial: 'list_messages', locals: { messages: @messages }
  end
end