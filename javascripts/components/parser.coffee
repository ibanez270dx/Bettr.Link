class Parser
  data: {}
  promises: {}

  constructor: ->
    window.addEventListener 'BettrLink::Parser::Globals', (event) =>
      globals = CircularJSON.parse event.detail.globals
      @promises.globals.resolve JSON.parse(globals)

    window.waitFor ['jquery','circular-json'], =>
      $.when(@_globals(), @_headers(), @_location()).then (g, h, l) =>
        console.log " => metatags: ", @_metatags()
        console.log " => globals: ", g
        console.log " => headers: ", h
        console.log " => location: ", l

  ##############################################################################

  _globals: ->
    @promises.globals = (deferred = $.Deferred())
    url = chrome.extension.getURL "javascripts/views/window.js"
    $('head').append $("<script src='#{url}'></script>")
    deferred.promise()

  _headers: ->
    response = {}
    $.get(document.location).then (data, status, xhr) ->
      for header in xhr.getAllResponseHeaders().split('\n')
        pair = header.toString().trim().split(': ')
        response[pair[0]] = pair[1]
      response

  _location: ->
    location = document.location
    $.Deferred().resolve(
      protocol: location.protocol
      host: location.host
      hostname: location.hostname
      href: location.href
      origin: location.origin
      port: location.port
      pathname: location.pathname
      search: location.search
      hash: location.hash
    ).promise()

  _metatags: ->
    site: @getMeta('site')
    type: @getMeta('type')
    category: @getMeta('category')
    title: @getMeta('title')
    description: @getMeta('description')
    keywords: @getMeta('keywords')
    icon: @getMeta('icon')
    image: @getMeta('image')
    author: @getMeta('author')
    published: @getMeta('published')
    url: @getMeta('url')

  ##############################################################################

  tags:
    site:        ['[property="og:site_name"]','[name="application-name"]','[name="apple-mobile-web-app-title"]']
    type:        ['[property="og:type"]','[name="medium"]','[name="Classification"]','[property="og:video:type"]','[property="og:audio:type"]']
    category:    ['[name="category"]','[name="topic"]']
    title:       ['[property="og:title"]','[name="twitter:title"]','[itemprop="name"]','[name="pagename"]','[name="apple-mobile-web-app-title"]','document.title']
    description: ['[property="og:description"]','[name="description"]','[name="subject"]','[name="abstract"]','[name="subtitle"]']
    keywords:    ['[name="keywords"]']
    icon:        ['[rel="fluid-icon"]','[rel="shortcut icon"]','[rel="apple-touch-icon"]']
    image:       ['[property="og:image"]','[rel="apple-touch-startup-image"]']
    author:      ['[name="author"]','[name="owner"]','[name="designer"]','[property="fb:admins"]','[name="me"]']
    published:   ['[name="date"]']
    url:         ['[name="url"]','[name="identifier-URL"]']

  getContent: (target) ->
    switch
      when $(target).is('meta') then $(target).attr('content')
      when $(target).is('link') then $(target).attr('href')
      else $(target)

  getMeta: (meta) ->
    for tag in @tags[meta]
      content = @getContent(tag)
      return content if content?.length > 0

@BettrLink ||= {}
@BettrLink.Parser = new Parser()
