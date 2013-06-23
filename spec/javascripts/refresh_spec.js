
describe('refresh', function() {

  it('does not extract any refresh url without meta refresh tag', function() {
    expect(extractRefreshUrl()).toBe(null);
  });

});
