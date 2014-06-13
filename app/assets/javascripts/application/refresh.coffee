# Copyright (C) 2014 by Philippe Bourgau


window.mesCourses or= {}
window.mesCourses.refresh = {

  doNow: ->
    refreshUrl = this.extractRefreshUrl($('meta[http-equiv=refresh]').attr('content'))
    if (refreshUrl != null)
      mesCourses.redirect.doRedirect(refreshUrl)

  extractRefreshUrl: (refreshContent) ->
    if (refreshContent == undefined)
      return null

    urlMatch = /url=([^;]*)/.exec(refreshContent)
    if (urlMatch == null)
      return ''

    window.location.protocol + '//' + window.location.host + urlMatch[1]
}
