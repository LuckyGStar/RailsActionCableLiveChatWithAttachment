jQuery(document).on 'turbolinks:load', ->
  $messages = $('#messages')
  $newMessageForm = $('.form__message-new')
  $newMessageBody = $newMessageForm.find('.input--message_body')
  $newMessageAttachment = $newMessageForm.find('.input--message_attachment')
  
  if $messages.length
    App.chat = App.cable.subscriptions.create {
      channel: 'ChatChannel'
    },
    connected: ->
      
    disconnected: ->
      
    received: (data) ->
      if data['message']
        $newMessageBody.val('')
        $messages.append data['message']
    send_message: (message, file_uri, original_name) ->
      @perform 'send_message', message: message, file_uri: file_uri, original_name: original_name

    $newMessageForm.submit (e) ->
      $this = $(this)
      messageBody = $newMessageBody.val()
      
      if $.trim(messageBody).length > 0 or $newMessageAttachment.get(0).files.length > 0
        if $newMessageAttachment.get(0).files.length > 0 # if file is chosen
          reader = new FileReader()  # use FileReader API
          fileName = $newMessageAttachment.get(0).files[0].name # get the name of the first chosen file
          reader.addEventListener "loadend", -> # perform the following action after the file is loaded
            App.chat.send_message messageBody, reader.result, fileName  # send message with file
            # at this point reader.result is a BASE64-encoded file
            
          reader.readAsDataURL $newMessageAttachment.get(0).files[0] # read file in base 64 format
        else
          App.chat.send_message messageBody
      
      e.preventDefault()
      
      return false