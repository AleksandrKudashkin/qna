$(document).on "ajax:error", (evt, xhr, status, error) ->
  if (xhr.status == 403)
    errors = xhr.responseJSON.errors
    html = "<div class='alert alert-danger'><a href='#' class='close' data-dismiss='alert'
    alia-label='close'>&times</a>" + errors + "</div>"
    $('.layout-errors').append(html)
