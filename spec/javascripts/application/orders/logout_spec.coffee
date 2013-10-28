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
