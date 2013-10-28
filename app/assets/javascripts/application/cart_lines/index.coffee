window.mesCourses or= {}
window.mesCourses.cartLines or= {}
window.mesCourses.cartLines.index = {
  setUp: ->
    setUpStoreLoginFormAjax()
}

setUpStoreLoginFormAjax = ->
  $('form.store-login').submit(ajaxForwardStore)

ajaxForwardStore = ->
  valuesToSubmit = $(this).serialize();
  url = $(this).attr('action')
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
  false

beforeForwardStore = ->
  window.mesCourses.cursor.startWaiting()
  window.mesCourses.notice.display('Votre panier va être transféré dans quelques secondes')
  window.mesCourses.scrollToTop()

afterForwardStore = ->
  window.mesCourses.cursor.stopWaiting()

