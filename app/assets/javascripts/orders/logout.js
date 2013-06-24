function incrementUpTo(query, max) {
  var element = $(query);
  var value = parseInt(element.text());
  if (value < max) {
    value = value + 1;
  }
  element.text(value.toString());
}

$(document).ready(function(){
  setInterval(function(){
    incrementUpTo('#transfer-ratio', 100);
  }, 1000);
});

function onRemoteStoreIFrameLoad() {
    Refresh.doNow();
};
