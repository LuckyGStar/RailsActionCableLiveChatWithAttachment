class AddAttachmentDataToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :attachment_data, :text
  end
end
