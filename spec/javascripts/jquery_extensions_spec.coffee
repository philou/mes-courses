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



describe 'jquery extensions', ->

  initialValue = 12

  beforeEach ->
    loadFixtures('intSpan.html')
    $('#counter').text(initialValue.toString())

  it 'can increment any integer span', ->
    $('#counter').incrementUpTo(10000000)

    expect($('#counter').text()).toBe (initialValue + 1).toString()

  it 'stops incrementing once the ceiling is reached', ->
    $('#counter').incrementUpTo(initialValue)

    expect($('#counter').text()).toBe initialValue.toString()
