# config/initializers/shrine.rb

require "shrine" # core
require "shrine/storage/file_system" # plugin to save files using file system

Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), 
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"),
}

Shrine.plugin :activerecord # enable ActiveRecord support
Shrine.plugin :determine_mime_type # check MIME TYPE

# Shrine.plugin :validation_helpers, default_messages: {
#     mime_type_inclusion: ->(whitelist) { # you may use whitelist variable to display allowed types
#       "isn't of allowed type. It must be an image."
#     }
# }
# 
# Shrine::Attacher.validate do
#   validate_mime_type_inclusion [ # whitelist only these MIME types
#                                    'image/jpeg',
#                                    'image/png',
#                                    'image/gif'
#                                ]
#   validate_max_size 1.megabyte # limit file size to 1MB
# end