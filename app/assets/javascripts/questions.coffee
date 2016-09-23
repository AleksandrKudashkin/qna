# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('form#edit-question').hide()

  $('.edit-question-link').click (e) ->
    e.preventDefault()
    $(this).hide()
    $('form#edit-question').show()

  $('.new-question-comment').on 'ajax:success', (e, data, status, xhr) ->
    msg = $.parseJSON(xhr.responseText)
    if typeof msg['comment'] != 'undefined'
      $('input#comment_body.form-control').val('')
    # $('.q-comments').append('<p>' + msg['comment'] + '</p>')
      $('.q-comments-errors').html('')
    if typeof msg['error'] != 'undefined'
      $('.q-comments-errors').html('<font color=red>' + msg['error'] + '</font>')

  $('a#q-vote-up').bind 'ajax:success', (e, data, status, xhr) ->
    $('.vote-button-up').hide()
    $('.vote-button-down').hide()
    $('.cancel-vote').show()
    rating = $.parseJSON(xhr.responseText)
    $('.q-rating').html(rating)

  $('a#q-vote-down').bind 'ajax:success', (e, data, status, xhr) ->
    $('.vote-button-up').hide()
    $('.vote-button-down').hide()
    $('.cancel-vote').show()
    rating = $.parseJSON(xhr.responseText)
    $('.q-rating').html(rating)

  $('a#q-cancel-vote').bind 'ajax:success', (e, data, status, xhr) ->
    $('.cancel-vote').hide()
    $('.vote-button-up').show()
    $('.vote-button-down').show()
    rating = $.parseJSON(xhr.responseText)
    $('.q-rating').html(rating)

  questionId = $('.q-comments').data('questionId')
  PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
    comment = $.parseJSON(data['comment'])
    if comment.commentable_type == 'Question'
      $('.q-comments').append('<p>' + comment.body + '</p>')
    if comment.commentable_type == 'Answer'
      $('.a-comments-' + comment.commentable_id).append('<p>' + comment.body + '</p>')

  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    html = '<h3><i class="fa fa-question-circle"></i><a href=/questions/' + question.id + '>' + question.title + '</a></h3><p>' + question.body + '</p>'
    $('.questions').append(html)
    $('#new_comment').find("comment_body").val()

document.addEventListener('turbolinks:load', ready)
