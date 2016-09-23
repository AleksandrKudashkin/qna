# ready = ->
#   questionId = $('.q-comments').data('questionId')
#   PrivatePub.subscribe '/questions/' + questionId + '/comments', (data, channel) ->
#     comment = $.parseJSON(data['comment'])
#     $('.q-comments').append('<p>' + comment.body + '</p>')

# document.addEventListener('turbolinks:load', ready)
