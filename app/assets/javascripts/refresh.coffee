window.mesCourses or= {}

window.mesCourses.refresh = {

  doNow: ->
    refreshUrl = mesCourses.refresh.extractRefreshUrl($('meta[http-equiv=refresh]').attr('content'))
    if (refreshUrl != null)
      mesCourses.refresh.doRedirect(refreshUrl)

  extractRefreshUrl: (refreshContent) ->
    if (refreshContent == undefined)
      return null

    urlMatch = /url=([^;]*)/.exec(refreshContent)
    if (urlMatch == null)
      return ''

    window.location.protocol + '//' + window.location.host + urlMatch[1]

  doRedirect: (href) ->
    window.location.assign(href)
}
