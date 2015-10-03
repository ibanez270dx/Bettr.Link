
@BettrLink =
  appRoot: chrome.extension.getURL('/')
  isActive: false

  overlay: -> $('#bettrlink-overlay')
  capture: -> $('#bettrlink-capture')
  sidebar: -> $('#bettrlink-sidebar')
  iframe: -> $('#bettrlink-iframe')

  injectHTML: ->
    $.get @appRoot+"views/injected.html", (html) =>
      $('body').append html
      @iframe().attr 'src', @appRoot+"views/index.html"
      @toggle()

  scrapePageInfo: ->
    page =
      site: $('meta[property*=site_name]') || $('title')
      name: $('meta[property*=title]') || $('meta[itemprop*=name]') || $('meta[name*=title]') || $('title')
      desc: $('meta[property*=description]') || $('meta[itemprop*=description]') || $('meta[name*=description]')
    console.log "page: ", page
    $('#bettrlink-site-title').text page.name.text()
    $('#bettrlink-site-url').text window.location.toString()

  open: ->
    @capture().attr('src', dataUri).velocity(
      { blur: 6, opacity: 0.4 },
      { duration: 500, begin: (capture) =>
        $('html').addClass 'bettrlink-no-scroll'
        @scrapePageInfo()
        @overlay().show()
      })
    @sidebar().velocity(
      { translateX: ["0px","400px"] },
      { duration: 435, easing: [0.175, 0.885, 0.32, 1.275] })
    @isActive = true

  close: ->
    @capture().velocity(
      { blur: 0, opacity: 1 },
      { duration: 600, complete: =>
        $('html').removeClass 'bettrlink-no-scroll'
        @overlay().hide()
      })
    @sidebar().velocity(
      { translateX: ["400px","0px"] },
      { duration: 500, easing: "ease-out" })
    @isActive = false

  toggle: ->
    if @isActive then @close() else @open()

####################################################

@BettrLink
