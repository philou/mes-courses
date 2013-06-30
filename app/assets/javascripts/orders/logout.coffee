window.mesCourses or= {}
window.mesCourses.orders or= {}

window.mesCourses.orders.logout = {

  startUpdatingTransferRatio: ->
    setInterval ->
      $('#transfer-ratio').incrementUpTo(100)
    , 1000

  onRemoteStoreIFrameLoad: ->
    mesCourses.refresh.doNow()
}
