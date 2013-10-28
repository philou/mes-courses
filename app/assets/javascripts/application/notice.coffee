window.mesCourses or= {}
window.mesCourses.notice = {
  display: (message) ->
    $("<div class=\"notice\"><p>#{message}</p></div>").insertAfter($('#path-bar'))
}
