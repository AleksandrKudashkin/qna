# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).show()

  $('#new_answer_comment').on 'ajax:success', (e, data, status, xhr) ->
    answerId = $(this).data('commentableId')
    msg = $.parseJSON(xhr.responseText)
    if typeof msg['comment'] != 'undefined'
      $('.comment-body-' + answerId).val('')
      $('.a-comments-' + answerId).append('<p>' + msg['comment'] + '</p>')
      $('.a-comments-errors-' + answerId).html('')
    if typeof msg['error'] != 'undefined'
      $('.a-comments-errors-' + answerId).html('<font color=red>' + msg['error'] + '</font>')

  $('a#a-vote-up').bind 'ajax:success', (e, data, status, xhr) ->
    answerId = $(this).data('answerId')
    $('.a-vote-button-up-' + answerId).hide()
    $('.a-vote-button-down-' + answerId).hide()
    $('.a-cancel-vote-' + answerId).show()
    rating = $.parseJSON(xhr.responseText)
    $('#a-rating-' + answerId).html(rating)

  $('a#a-vote-down').bind 'ajax:success', (e, data, status, xhr) ->
    answerId = $(this).data('answerId')
    $('.a-vote-button-up-' + answerId).hide()
    $('.a-vote-button-down-' + answerId).hide()
    $('.a-cancel-vote-' + answerId).show()
    rating = $.parseJSON(xhr.responseText)
    $('#a-rating-' + answerId).html(rating)

  $('a#a-cancel-vote').bind 'ajax:success', (e, data, status, xhr) ->
    answerId = $(this).data('answerId')
    $('.a-cancel-vote-' + answerId).hide()
    $('.a-vote-button-up-' + answerId).show()
    $('.a-vote-button-down-' + answerId).show()
    rating = $.parseJSON(xhr.responseText)
    $('#a-rating-' + answerId).html(rating)

document.addEventListener('turbolinks:load', ready)
