// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function refreshNow() {
  var refreshUrl = extractRefreshUrl();
  if (refreshUrl !== null) {
    window.location.assign(refreshUrl);
  }
};

function extractRefreshUrl() {
  var refreshContent = $('meta[http-equiv=refresh]').attr('content');
  if (refreshContent === undefined) {
    return null;
  }
  var urlMatch = /url=([^;]*)/.exec(refreshContent)
  if (urlMatch === null) {
    return '';
  }
  return window.location.protocol + '//' + window.location.host + urlMatch[1];
};
