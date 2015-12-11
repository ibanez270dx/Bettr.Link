class Parser
  metatags: {}
  promises: {}

  constructor: ->
    window.addEventListener 'message', ((event) =>
      return unless event.data.id is chrome.runtime.id
      window.trigger 'processDetails', @metatags
    ), false

    window.addEventListener 'BettrLink::Parser::Globals', (event) =>
      globals = CircularJSON.parse event.detail.globals
      @promises.globals.resolve JSON.parse(globals)

    window.waitFor ['jquery','circular-json'], =>
      @metatags = @_metatags()

  ##############################################################################

  _globals: ->
    @promises.globals = (deferred = $.Deferred())
    url = chrome.extension.getURL "javascripts/views/window.js"
    $('head').append $("<script src='#{url}'></script>")
    deferred.promise()

  # deprecated: this will eventually be done on the server side
  _headers: ->
    response = {}
    $.get(document.location).then (data, status, xhr) ->
      for header in xhr.getAllResponseHeaders().split('\n')
        pair = header.toString().trim().split(': ')
        response[pair[0]] = pair[1]
      response

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

  getContent: (target) ->
    switch
      when $(target).is('meta') then $(target).attr('content')
      when $(target).is('link') then $(target).attr('href')
      else $(target)

  getMeta: (meta) ->
    for tag in @tags[meta]
      content = @getContent(tag)
      return content if content?.length > 0

####################################################
# Initialize
####################################################

@BettrLink ||= {}
@BettrLink.Parser = new Parser()
