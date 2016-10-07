ready = ->
  $(document).on "ajax:error", (evt, xhr, status, error) ->
    if (xhr.status == 403)
      html = "<div class='alert alert-danger'><a href='#' class='close' data-dismiss='alert'
      alia-label='close'>&times</a>" + xhr.responseJSON.errors + "</div>"
      $('.layout-errors').append(html)

document.addEventListener('turbolinks:load', ready)
