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



describe 'mesCourses.orders.logout', ->
  logout = window.mesCourses.orders.logout

  beforeEach ->
    jasmine.Clock.useMock()
    spyOn(jQuery.fn, 'incrementUpTo').andCallThrough()

    loadFixtures('sandbox.html')
    $('#sandbox').append('<span id="transfer-ratio">90</transfer-ratio>')
    $('#sandbox').append('<span id="another-ratio">90</transfer-ratio>')
    logout.setUp()

  afterEach ->
    logout.tearDown()

  it 'increments transfer ratio up to 100', ->

    jasmine.Clock.tick(1000)
    expect($('#transfer-ratio').incrementUpTo).toHaveBeenCalledWith 100

  it 'increments transfer ratio every second', ->
    jasmine.Clock.tick(999)
    expect($('#transfer-ratio').incrementUpTo).not.toHaveBeenCalled()

    jasmine.Clock.tick(1)
    expect($('#transfer-ratio').incrementUpTo.callCount).toEqual 1

    jasmine.Clock.tick(1000)
    expect($('#transfer-ratio').incrementUpTo.callCount).toEqual 2

  it 'only increments transfer ratio', ->
    initialOtherRatio = $('#another-ratio').text()

    jasmine.Clock.tick(1000)

    expect($('#another-ratio').text()).toEqual initialOtherRatio

  it 'refreshes the page once the logout iframe is loaded', ->
    spyOn(window.mesCourses.refresh, 'doNow')

    logout.onRemoteStoreIFrameLoad()

    expect(window.mesCourses.refresh.doNow).toHaveBeenCalled()
