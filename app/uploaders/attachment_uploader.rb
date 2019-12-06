# app/uploaders/attachment_uploader.rb

class AttachmentUploader < Shrine
  plugin :data_uri
  plugin :add_metadata
  
  add_metadata do |io, context|
    { 'filename' => context[:record].attachment_name }
  end
end