window.mesCourses or= {}
window.mesCourses.cursor = {
  startWaiting: ->
    document.body.style.cursor = 'wait'
  stopWaiting: ->
    document.body.style.cursor = 'auto'
}
