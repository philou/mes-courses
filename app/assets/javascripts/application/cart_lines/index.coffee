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

