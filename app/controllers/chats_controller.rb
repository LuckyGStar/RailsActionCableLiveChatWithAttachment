# controllers/chats_controller.rb

class ChatsController < ApplicationController
  before_action :require_login
  
  def index
    if query_params[:active_user].present?
      @active_user = User.find(query_params[:active_user])
    end
    
    if query_params[:friend_request].present?
      @is_friend_request = query_params[:friend_request]
    end
    
    @messages = Message.order(created_at: :asc)
    @users = User.all
  end
  
  def list_messages
    active_user_id = params[:id]
    
    @messages = Message.where(sender_id: current_user.id, receiver_id: active_user_id).or(Message.where(sender_id: active_user_id, receiver_id: current_user.id))
    # @messages = Message.where(sender_id: active_user_id, receiver_id: current_user.id)
    
    render partial: 'list_messages', locals: { messages: @messages }
  end
  
  def accept_friend_request
    requested_user_id = params[:id]
    requested_user = User.find(params[:id])
    
    # render plain: 'success'
    friendship = Friendship.where(
      user_id: current_user.id,
      friend_user_id: requested_user.id
    ).first_or_create
    
    friendship = Friendship.where(
      user_id: requested_user.id,
      friend_user_id: current_user.id
    ).first_or_create
  end
  
  private
  def query_params
    request.query_parameters
  end
end