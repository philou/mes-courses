describe 'logout', ->
  logout = window.mesCourses.orders.logout
  intervalToken = null

  beforeEach ->
    jasmine.Clock.useMock()
    spyOn(jQuery.fn, 'incrementUpTo')

    intervalToken = logout.startUpdatingTransferRatio()

  afterEach ->
    clearInterval(intervalToken)

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

  it 'refreshes the page once the logout iframe is loaded', ->
    spyOn(window.mesCourses.refresh, 'doNow')

    logout.onRemoteStoreIFrameLoad()

    expect(window.mesCourses.refresh.doNow).toHaveBeenCalled()
