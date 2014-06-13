# Copyright (C) 2014 by Philippe Bourgau


window.mesCourses or= {}
window.mesCourses.orders or= {}
window.mesCourses.orders.logout = {

  setUp: ->
    @intervalToken = startUpdatingTransferRatio()

  onRemoteStoreIFrameLoad: ->
    mesCourses.refresh.doNow()

  tearDown: ->
    clearInterval(@intervalToken)
}

startUpdatingTransferRatio = ->
  setInterval ->
    $('#transfer-ratio').incrementUpTo(100)
  , 1000

