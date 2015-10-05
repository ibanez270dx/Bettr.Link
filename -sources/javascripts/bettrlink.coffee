
@BettrLink =
  isActive: false
  shadowDOM: 'bettrlink-ui::shadow'

  article: -> $("#{@shadowDOM} article")
  overlay: -> $("#{@shadowDOM} #overlay")
  capture: -> $("#{@shadowDOM} #capture")
  sidebar: -> $("#{@shadowDOM} aside")
  iframe: -> $("#{@shadowDOM} iframe")

  injectComponents: ->
    # BettrLink Web Component
    $(document.head).append $('<link>').attr
      rel: 'import', href: chrome.extension.getURL('views/components.html')

    # Point iFrame
    @iframe().attr 'src', chrome.extension.getURL('views/index.html')

  scrapePageInfo: ->
    page =
      site: $('meta[property*=site_name]') || $('title')
      name: $('meta[property*=title]') || $('meta[itemprop*=name]') || $('meta[name*=title]') || $('title')
      desc: $('meta[property*=description]') || $('meta[itemprop*=description]') || $('meta[name*=description]')
    console.log "page: ", page
    $('#bettrlink-site-title').text page.name.text()
    $('#bettrlink-site-url').text window.location.toString()

  open: ->
    chrome.runtime.sendMessage 'captureVisibleTab', (dataURI) =>
      @overlay().velocity { opacity: 1 }, duration: 500

      @capture().attr('src', dataURI).velocity { blur: 6, opacity: 0.4 },
        duration: 500, begin: =>
          @article().show()
          @scrapePageInfo()
          $('html').css
            overflow: 'hidden'

      @sidebar().velocity { translateX: ["0px","400px"], boxShadow: '25px 0px 50px 25px #101115' },
        duration: 435, easing: [0.175, 0.885, 0.32, 1.275]

      @isActive = true

  close: ->
    @overlay().velocity { opacity: 0 }, duration: 500

    @capture().velocity { blur: 0, opacity: 1 },
      duration: 600, complete: =>
        @article().hide()
        $('html').css
          overflow: 'initial'

    @sidebar().velocity { translateX: ["400px","0px"], boxShadow: '0px 0px 0px 0px transparent' },
      duration: 500, easing: "ease-out"

    @isActive = false

  toggle: ->
    if @isActive
    then @close()
    else @open()

####################################################
#  Listeners
####################################################

document.addEventListener 'BettrLink', (event) =>
  console.log 'BettrLinkEvent: ', event
  switch event.detail
    when "open" then @BettrLink.open()

####################################################
#  Initialize
####################################################

initialize = (=>
  if @jQuery? and @jQuery.Velocity? and @Vibrant?
  then @BettrLink.injectComponents()
  else setTimeout 'initialize()', 10
)()
