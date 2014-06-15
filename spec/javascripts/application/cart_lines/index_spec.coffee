# Copyright (C) 2014 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.



describe 'mesCourses.cartLines.index', ->
  cursor = redirect = index = spyAjax = null

  beforeEach ->
    cursor = window.mesCourses.cursor
    redirect = window.mesCourses.redirect
    index = window.mesCourses.cartLines.index

  it 'ajax submit does not skip default submit', ->
    expect(index.continueDefaultSubmit).toBe(true)

  describe 'actual ajax submit', ->

    beforeEach ->
      index.continueDefaultSubmit = false

      spyOn(redirect, 'doRedirect')
      loadFixtures('storeLoginForm.html', 'contentWrapper.html')
      index.setUp()
      spyAjax = spyOn($, 'ajax')

    afterEach ->
      cursor.stopWaiting()

    it 'makes store-login POST go through ajax', ->
      $('#login').val('gyzmo')
      $('#password').val('cinema-party')
      $('#submit').click()

      ajaxParams = $.ajax.mostRecentCall.args[0]

      expect(ajaxParams.url).toEqual('#ajax-action')
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
        $.fx.off = true
        spyAjax.andCallFake((params) -> ajaxParams = params)
        $('#submit').click()

      it 'sets the cursor to waiting during ajax request', ->
        ajaxParams.beforeSend()
        expect(document.body.style.cursor).toEqual('wait')

      it 'resets the cursor a few seconds after the ajax call', ->
        jasmine.Clock.useMock();
        ajaxParams.beforeSend()

        ajaxParams.complete()
        expect(document.body.style.cursor).toEqual('wait')

        jasmine.Clock.tick(index.storeIFrameLoadTimeSpan + 1);
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
