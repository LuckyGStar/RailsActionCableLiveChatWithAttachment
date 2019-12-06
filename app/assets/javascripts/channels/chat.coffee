jQuery(document).on 'turbolinks:load', ->
  $messages = $('#messages')
  $newMessageForm = $('.form__message-new')
  $newMessageBody = $newMessageForm.find('.input--message_body')
  
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
    send_message: (message) ->
      @perform 'send_message', message: message

    $newMessageForm.submit (e) ->
      $this = $(this)
      messageBody = $newMessageBody.val()
      if $.trim(messageBody).length
        App.chat.send_message messageBody
      
      e.preventDefault()
      return false