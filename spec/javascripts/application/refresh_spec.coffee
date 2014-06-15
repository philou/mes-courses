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



describe 'refresh', ->
  redirect = window.mesCourses.redirect
  refresh = window.mesCourses.refresh

  beforeEach ->
    # first make sure the jasmine page is as expected
    expect($('meta[http-equiv=refresh]')).not.toExist()

    # never do a real redirect
    spyOn(redirect, 'doRedirect')

  afterEach ->
    $('meta[http-equiv=refresh]').remove()

  it 'does not extract any refresh url without meta refresh tag', ->
    expect(refresh.extractRefreshUrl(undefined)).toBe null

  it 'extracts a blank url from a simple meta refresh tag', ->
    expect(refresh.extractRefreshUrl("1000000000")).toBe ''

  it 'extracts the actual url from a full meta refresh tag', ->
    expect(refresh.extractRefreshUrl("1000000000; url=/blog/posts/3")).toBe(window.location.protocol + '//' + window.location.host + '/blog/posts/3')

  it 'really refreshes the page to the specified url', ->
    refreshContent = '1000000000; url=/page/4'
    $('head').append('<meta http-equiv="refresh" content="' + refreshContent + '" />')

    refresh.doNow()

    expect(redirect.doRedirect).toHaveBeenCalledWith refresh.extractRefreshUrl(refreshContent)

  it 'does nothing if no meta refresh tage is there', ->
    refresh.doNow()

    expect(redirect.doRedirect).not.toHaveBeenCalled()
