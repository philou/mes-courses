describe 'mesCourses.cartLines.index', ->
  cursor = redirect = index = spyAjax = null

  beforeEach ->
    cursor = window.mesCourses.cursor
    redirect = window.mesCourses.redirect
    index = window.mesCourses.cartLines.index

    spyOn(redirect, 'doRedirect')
    loadFixtures('storeLoginForm.html', 'contentWrapper.html')
    index.setUp()
    spyAjax = spyOn($, 'ajax')

  it 'makes store-login POST go through ajax', ->
    $('#login').val('gyzmo')
    $('#password').val('cinema-party')
    $('#submit').click()

    ajaxParams = $.ajax.mostRecentCall.args[0]

    expect(ajaxParams.url).toEqual('#store-login-form')
    expect(ajaxParams.type).toEqual('POST')
    expect(ajaxParams.dataType).toEqual('JSON')
    expect(ajaxParams.data).toEqual($('#store-login').serialize())

  it 'follows the redirection on success', ->
    redirection = '/success'
    spyAjax.andCallFake((params) -> params.success({redirect: redirection }))

    $('#submit').click()

    expect(redirect.doRedirect).toHaveBeenCalledWith(redirection)

  describe 'during the ajax call', ->
    ajaxParams = {}

    beforeEach ->
      ajaxParams = {}
      spyAjax.andCallFake((params) -> ajaxParams = params)
      $('#submit').click()

    it 'sets the cursor to waiting during ajax request', ->
      ajaxParams.beforeSend()
      expect(document.body.style.cursor).toEqual('wait')

      ajaxParams.complete()
      expect(document.body.style.cursor).toEqual('auto')

    it "visibly displays a 'please wait' notice to the user", ->
      window.scrollTo(0,100)

      ajaxParams.beforeSend()
      thereShouldBeNotice('Votre panier va être transféré dans quelques secondes')
      noticeShouldBeVisible()

    windowShouldBeAtTop = ->
      expect(window.pageYOffset).toEqual(0)
    noticeShouldBeVisible = windowShouldBeAtTop

    thereShouldBeNotice = (message) ->
      expect($('div.notice').text()).toEqual(message)
      expect($('#path-bar').next()[0]).toEqual($('div.notice')[0])
