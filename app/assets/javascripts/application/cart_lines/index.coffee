window.mesCourses or= {}
window.mesCourses.cartLines or= {}
window.mesCourses.cartLines.index = {
  setUp: ->
    setUpStoreLoginFormAjax()

  continueDefaultSubmit: true
  storeIFrameLoadTimeSpan: 5000
}

self = window.mesCourses.cartLines.index

setUpStoreLoginFormAjax = ->
  $('form.store-login').submit(ajaxForwardStore)

ajaxForwardStore = ->
  valuesToSubmit = $(this).serialize();
  url = $(this).attr('ajax-action')
  $.ajax({
    type: 'POST',
    url: url,
    data: valuesToSubmit,
    dataType: 'JSON'
    success: (json) ->
      window.mesCourses.redirect.doRedirect(json.redirect)

    beforeSend: beforeForwardStore,
    complete: afterForwardStore
  })
  self.continueDefaultSubmit

continueDefaultSubmit = ->

beforeForwardStore = ->
  window.mesCourses.cursor.startWaiting()
  window.mesCourses.notice.display('Votre panier va être transféré dans quelques secondes')
  window.mesCourses.scrollToTop()

afterForwardStore = ->
  setTimeout(window.mesCourses.cursor.stopWaiting, self.storeIFrameLoadTimeSpan)

