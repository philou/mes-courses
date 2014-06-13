# Copyright (C) 2014 by Philippe Bourgau


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
