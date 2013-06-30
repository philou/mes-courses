describe('logout', function() {
  var logout = mesCourses.orders.logout
  var intervalToken;

  beforeEach(function() {
    jasmine.Clock.useMock();
    spyOn(jQuery.fn, 'incrementUpTo');

    intervalToken = logout.startUpdatingTransferRatio();
  });

  afterEach(function() {
    clearInterval(intervalToken);
  });

  it('increments transfer ratio up to 100', function() {
    jasmine.Clock.tick(1000);
    expect($('#transfer-ratio').incrementUpTo).toHaveBeenCalledWith(100);
  });

  it('increments transfer ratio every second', function() {
    jasmine.Clock.tick(999);
    expect($('#transfer-ratio').incrementUpTo).not.toHaveBeenCalled();

    jasmine.Clock.tick(1);
    expect($('#transfer-ratio').incrementUpTo.callCount).toEqual(1);

    jasmine.Clock.tick(1000);
    expect($('#transfer-ratio').incrementUpTo.callCount).toEqual(2);
  });

  it('refreshes the page once the logout iframe is loaded', function() {
    spyOn(mesCourses.refresh, 'doNow');

    logout.onRemoteStoreIFrameLoad();

    expect(mesCourses.refresh.doNow).toHaveBeenCalled();
  });
});
