# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).show()

  $('a#a-vote-up').bind 'ajax:success', (e, data, status, xhr) ->
    answerId = $(this).data('answerId')
    $('.a-vote-buttons-' + answerId).hide()
    $('.a-cancel-vote-' + answerId).show()
    rating = $.parseJSON(xhr.responseText)
    $('.a-rating-' + answerId).html('<b>рейтинг:</b> '+rating)

  $('a#a-vote-down').bind 'ajax:success', (e, data, status, xhr) ->
    answerId = $(this).data('answerId')
    $('.a-vote-buttons-' + answerId).hide()
    $('.a-cancel-vote-' + answerId).show()
    rating = $.parseJSON(xhr.responseText)
    $('.a-rating-' + answerId).html('<b>рейтинг:</b> '+rating)

  $('a#a-cancel-vote').bind 'ajax:success', (e, data, status, xhr) ->
    answerId = $(this).data('answerId')
    $('.a-cancel-vote-' + answerId).hide()
    $('.a-vote-buttons-' + answerId).show()
    rating = $.parseJSON(xhr.responseText)
    $('.a-rating-' + answerId).html('<b>рейтинг:</b> '+rating)

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update
