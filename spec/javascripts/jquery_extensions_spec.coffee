# Copyright (C) 2014 by Philippe Bourgau


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
