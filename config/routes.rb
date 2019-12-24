Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    
  root 'chats#index'
  
  mount ActionCable.server => '/cable'
  
  get 'chats/list_messages/:id', :to => 'chats#list_messages'
end
