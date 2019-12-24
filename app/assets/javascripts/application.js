// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require rails_emoji_picker
//= require turbolinks
//= require_tree .

$(window).on('load', () => {
  const $messages = $('#messages')
  const $contactElement = $('.chat__contact--element')
  const $inputActiveUser = $('.input__active--user')
  
  $contactElement.on('click', (e) => {
    $contactElement.removeClass('is-active')
    $contactElement.removeClass('is-new-message')
    const $selectedContactElement = $(e.currentTarget)
    const selectedUserId = $selectedContactElement.data('id')
    
    $.ajax({
      type: "GET", 
      url: "/chats/list_messages/" + selectedUserId,
      data: {},
      success: function(data, textStatus, jqXHR){
        $messages.html(data)
      },
      error: function(jqXHR, textStatus, errorThrown){}
    })

    $selectedContactElement.addClass('is-active')
    $inputActiveUser.val(selectedUserId)
  })
})