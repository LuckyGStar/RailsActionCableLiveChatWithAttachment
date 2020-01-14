Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    
  # root 'chats#index'
  root 'home#index'
  mount ActionCable.server => '/cable'
  
  get 'chats', :to => 'chats#index'
  get 'members', :to => 'home#list_users'
  get 'chats/list_messages/:id', :to => 'chats#list_messages'
  
  post 'chats/accept_friend_request/:id', :to => 'chats#accept_friend_request'
end
