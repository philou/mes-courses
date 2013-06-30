jQuery.fn.incrementUpTo = function(max) {
  var value = parseInt(this.text());
  if (value < max) {
    value = value + 1;
  }
  this.text(value.toString());
};
