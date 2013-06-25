describe('jquery extensions', function() {

    var initialValue = 12;

    beforeEach(function() {
        loadFixtures('intSpan.html');
        $('#counter').text(initialValue.toString());
    });

    it('can increment any integer span', function() {
        $('#counter').incrementUpTo(10000000);

        expect($('#counter').text()).toBe((initialValue + 1).toString());
    });

    it('stops incrementing once the ceiling is reached', function() {
        $('#counter').incrementUpTo(initialValue);

        expect($('#counter').text()).toBe(initialValue.toString());
    });
});
