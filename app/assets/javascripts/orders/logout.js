// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function(){
  setInterval(function(){
    var ratioElement = $('#transfer-ratio');
    var ratio = parseInt(ratioElement.text());
    if (ratio < 100) {
      ratio = ratio + 1;
    }
    ratioElement.text(ratio.toString())
  }, 1000);
});

function onRemoteStoreIFrameLoad() {
    refreshNow();
};