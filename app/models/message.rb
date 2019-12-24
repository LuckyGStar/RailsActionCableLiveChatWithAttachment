class Message < ApplicationRecord
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :reeiver, class_name: "User", foreign_key: "receiver_id"
  
  validates :body, presence: true, unless: :attachment_data

  after_create_commit :broadcast_message
  
  include AttachmentUploader[:attachment]

  def attachment_name=(name)
    @attachment_name = name
  end

  def attachment_name
    @attachment_name
  end
  
  private

  def broadcast_message
    MessageBroadcastJob.perform_later(self)
  end
end
