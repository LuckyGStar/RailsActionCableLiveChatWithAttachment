class User < ApplicationRecord
  include Clearance::User
  
  has_and_belongs_to_many :friends,
    class_name: "User",
    join_table: :friendships,
    foreign_key: :friend_user_id,
    association_foregin_key: :user_id
  
  def is_friend? user
    self.friends.include? user
  end
end
