var mesCourses = mesCourses || {};

mesCourses.refresh = {

    doNow: function() {
        var refreshUrl = mesCourses.refresh.extractRefreshUrl($('meta[http-equiv=refresh]').attr('content'));
        if (refreshUrl !== null) {
            mesCourses.refresh.doRedirect(refreshUrl);
        }
    },

    extractRefreshUrl: function(refreshContent) {
        if (refreshContent === undefined) {
            return null;
        }
        var urlMatch = /url=([^;]*)/.exec(refreshContent)
        if (urlMatch === null) {
            return '';
        }
        return window.location.protocol + '//' + window.location.host + urlMatch[1];
    },

    doRedirect: function(href) {
        window.location.assign(href);
    }
};
