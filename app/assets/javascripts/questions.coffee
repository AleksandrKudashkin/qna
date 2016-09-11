# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('form#edit-question').hide();

  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('form#edit-question').show()
    
  $('a#q-vote-up').bind 'ajax:success', (e, data, status, xhr) ->
    $('.vote-buttons').hide()
    $('.cancel-vote').show()
    rating = $.parseJSON(xhr.responseText)
    $('.q-rating').html(rating)

  $('a#q-vote-down').bind 'ajax:success', (e, data, status, xhr) ->
    $('.vote-buttons').hide()
    $('.cancel-vote').show()
    rating = $.parseJSON(xhr.responseText)
    $('.q-rating').html(rating)

  $('a#q-cancel-vote').bind 'ajax:success', (e, data, status, xhr) ->
    $('.cancel-vote').hide()
    $('.vote-buttons').show()
    rating = $.parseJSON(xhr.responseText)
    $('.q-rating').html(rating)

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update
