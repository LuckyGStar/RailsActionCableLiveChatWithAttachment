# controllers/home_controller.rb

class HomeController < ApplicationController
  before_action :require_login
  
  def index
  end
  
  def list_users
    @users = User.all
  end
end