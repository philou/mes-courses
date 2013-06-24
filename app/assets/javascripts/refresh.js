// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var Refresh = {

    doNow: function() {
        var refreshUrl = Refresh.extractRefreshUrl($('meta[http-equiv=refresh]').attr('content'));
        if (refreshUrl !== null) {
            Refresh.doRedirect(refreshUrl);
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
