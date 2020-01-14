class AddIsFriendRequestToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :is_friend_request, :integer
  end
end
