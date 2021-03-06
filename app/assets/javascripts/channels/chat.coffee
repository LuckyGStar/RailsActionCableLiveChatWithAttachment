jQuery(document).on 'turbolinks:load', ->
  $messages = $('#messages')
  $inputCurrentUser = $('.input__current--user')
  $inputActiveUser = $('.input__active--user')
  $inputFriendRequest = $('.input__friend--request')
  $newMessageForm = $('.form__message-new')
  $newMessageBody = $newMessageForm.find('.form__input-body')
  $newMessageVideoAttachment = $newMessageForm.find('.form__input-attachment-video')
  $newMessageImageAttachment = $newMessageForm.find('.form__input-attachment-image')
  $newMessageDocumentAttachment = $newMessageForm.find('.form__input-attachment-doc')
  
  $newFriendRequestManage = $('.form__friend--request-manage')
  $btnFriendRequestAccept = $('.btn__friend--request-accept')
  $btnFriendRequestDeny = $('.btn__friend--request-deny')
  
  currentUser = $inputCurrentUser.val()
    
  if $messages.length
    App.chat = App.cable.subscriptions.create {
      channel: 'ChatChannel'
    },
    connected: ->
      
    disconnected: ->
      
    received: (data) ->
      if data.type == 'new_message'
        currentUser = parseInt($inputCurrentUser.val())
        activeUser = parseInt($inputActiveUser.val())
        
        if data['is_friend_request'] == 1
          if data['receiver_id'] == currentUser
            selector = ".chat__contact--element[data-id='#{data['sender_id']}']"
            $(selector).addClass('is-new-message')
            $(selector).addClass('is-friend-request')
            $(selector).data('is-friend-request', 1)
        else
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
                  $messages.animate { scrollTop: $(document).height() }, "slow"
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
        if data.type == 'accept_friend_request'
          console.log(data)
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
  
    send_friend_request_response: (payload) ->
      @perform 'send_friend_request_response', payload: payload
    send_message: (message, file_uri, original_name) ->
      @perform 'send_message', message: message, file_uri: file_uri, original_name: original_name
    $btnFriendRequestAccept.on 'click', ->
      $newFriendRequestManage.addClass('hidden')
      selectedUserId = $inputActiveUser.val()
      currentUserId = $inputCurrentUser.val()
      
      $.ajax
        type: "POST", 
        url: "/chats/accept_friend_request/" + selectedUserId,
        data: {},
        success: (data, textStatus, jqXHR) ->
          acceptFriendRequestBody = {
            requester_id: selectedUserId, 
            receiver_id: currentUserId
          }
          $selectedContactElement = $('.is-active')
          $selectedContactElement.removeClass('unknown')
        error: (jqXHR, textStatus, errorThrown) ->
    $btnFriendRequestDeny.on 'click', ->
      $selectedContactElement = $('.is-active')
      $messages.html('')
      $inputActiveUser.val(-1)
      $newFriendRequestManage.addClass('hidden')
      $selectedContactElement.removeClass('is-active')
      $selectedContactElement.removeClass('is-friend-request')
    $newMessageForm.submit (e) ->
      if !!!$inputActiveUser.val()
        alert('Please select a user to send message first!')
        return false
      
      $this = $(this)
      
      newMessageBody = $newMessageBody.val()
      senderId = parseInt($inputCurrentUser.val())
      receiverId = parseInt($inputActiveUser.val())
      isFriendRequest = parseInt($inputFriendRequest.val())
      friendRequestUser = parseInt($inputFriendRequest.data('user-id'))
      friendRequestCnt = parseInt($inputFriendRequest.data('sent-cnt'))
      isFriendRequestPossible = false
      
      if isFriendRequest == 1
        if friendRequestUser == receiverId
          if friendRequestCnt != 0
            alert('In friend request only 1 message is allowed')
            return
          else
            isFriendRequestPossible = true
            $inputFriendRequest.data('sent-cnt', 1)
      
      messageBody = {
        content: newMessageBody,
        sender_id: senderId,
        receiver_id: receiverId,
        is_friend_request: isFriendRequestPossible
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
        
        $messages.animate { scrollTop: $(document).height() }, "slow"
      
      e.preventDefault()
      
      return false