jQuery(document).on 'turbolinks:load', ->
  $messages = $('#messages')
  $inputCurrentUser = $('.input__current--user')
  $inputActiveUser = $('.input__active--user')
  $newMessageForm = $('.form__message-new')
  $newMessageBody = $newMessageForm.find('.form__input-body')
  $newMessageVideoAttachment = $newMessageForm.find('.form__input-attachment-video')
  $newMessageImageAttachment = $newMessageForm.find('.form__input-attachment-image')
  $newMessageDocumentAttachment = $newMessageForm.find('.form__input-attachment-doc')
  
  currentUser = $inputCurrentUser.val()
    
  if $messages.length
    App.chat = App.cable.subscriptions.create {
      channel: 'ChatChannel'
    },
    connected: ->
      
    disconnected: ->
      
    received: (data) ->
      currentUser = parseInt($inputCurrentUser.val())
      activeUser = parseInt($inputActiveUser.val())
      
      debugger
      if activeUser != -1
        if data['receiver_id'] == currentUser
          if data['sender_id'] == activeUser
            if data['message']
              messageTemplate = ''
            
              if (data['sender_id'] == parseInt(currentUser))
                messageTemplate = "<div class='message align-left'>#{data['message']}</div>"
              else
                messageTemplate = "<div class='message align-right'>#{data['message']}</div>"
              $messages.append messageTemplate
          else
            selector = ".chat__contact--element[data-id='#{data['sender_id']}']"
            $(selector).addClass('is-new-message')
        
        if data['message']
          if data['sender_id'] == currentUser
            $newMessageVideoAttachment.val('')
            $newMessageImageAttachment.val('')
            $newMessageDocumentAttachment.val('')
            $newMessageBody.val('')
            $newMessageBody.text('')
          
            messageTemplate = ''
          
            if (data['sender_id'] == parseInt(currentUser))
              messageTemplate = "<div class='message align-left'>#{data['message']}</div>"
            else
              messageTemplate = "<div class='message align-right'>#{data['message']}</div>"
            $messages.append messageTemplate
      
      # if data['message']
      #   $newMessageVideoAttachment.val('')
      #   $newMessageImageAttachment.val('')
      #   $newMessageDocumentAttachment.val('')
      #   $newMessageBody.val('')
      #   $newMessageBody.text('')
      # 
      #   messageTemplate = ''
      # 
      #   if (data['user'] == parseInt(currentUser))
      #     messageTemplate = "<div class='message align-left'>#{data['message']}</div>"
      #   else
      #     messageTemplate = "<div class='message align-right'>#{data['message']}</div>"
      #   $messages.append messageTemplate
        
    send_message: (message, file_uri, original_name) ->
      @perform 'send_message', message: message, file_uri: file_uri, original_name: original_name

    $newMessageForm.submit (e) ->
      if !!!$inputActiveUser.val()
        alert('Please select a user to send message first!')
        return
      
      $this = $(this)
      # messageBody = $newMessageBody.val()
      messageBody = {
        content: $newMessageBody.val(),
        sender_id: $inputCurrentUser.val(),
        receiver_id: $inputActiveUser.val()
      }
      
      if $.trim(messageBody).length > 0 or $newMessageVideoAttachment.get(0).files.length > 0 or $newMessageImageAttachment.get(0).files.length > 0 or $newMessageDocumentAttachment.get(0).files.length > 0
        if $newMessageVideoAttachment.get(0).files.length > 0 # if file is chosen
          reader = new FileReader()  # use FileReader API
          fileName = $newMessageVideoAttachment.get(0).files[0].name # get the name of the first chosen file
          reader.addEventListener "loadend", -> # perform the following action after the file is loaded
            App.chat.send_message messageBody, reader.result, fileName  # send message with file
            # at this point reader.result is a BASE64-encoded file
            
          reader.readAsDataURL $newMessageVideoAttachment.get(0).files[0] # read file in base 64 format
        else if $newMessageImageAttachment.get(0).files.length > 0 # if file is chosen
          reader = new FileReader()  # use FileReader API
          fileName = $newMessageImageAttachment.get(0).files[0].name # get the name of the first chosen file
          reader.addEventListener "loadend", -> # perform the following action after the file is loaded
            App.chat.send_message messageBody, reader.result, fileName  # send message with file
            # at this point reader.result is a BASE64-encoded file
            
          reader.readAsDataURL $newMessageImageAttachment.get(0).files[0] # read file in base 64 format
        else if $newMessageDocumentAttachment.get(0).files.length > 0 # if file is chosen
          reader = new FileReader()  # use FileReader API
          fileName = $newMessageDocumentAttachment.get(0).files[0].name # get the name of the first chosen file
          reader.addEventListener "loadend", -> # perform the following action after the file is loaded
            App.chat.send_message messageBody, reader.result, fileName  # send message with file
            # at this point reader.result is a BASE64-encoded file
            
          reader.readAsDataURL $newMessageDocumentAttachment.get(0).files[0] # read file in base 64 format
        else
          App.chat.send_message messageBody
      
      e.preventDefault()
      
      return false