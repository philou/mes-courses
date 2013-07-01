window.jQuery.fn.incrementUpTo = (max) ->
  value = parseInt(this.text())
  if (value < max)
    value = value + 1

  this.text(value.toString())

