
@BettrLink =
  isReady: false
  isActive: false
  injected: false
  shadowDOM: 'bettrlink-ui::shadow'

  ### Helpers ######################################

  capture: ->
    $("#{@shadowDOM} #capture")

  details: ->
    container: $("#{@shadowDOM} section")
    iframe: $("#{@shadowDOM} section iframe")

  sidebar: ->
    container: $("#{@shadowDOM} aside")
    iframe: $("#{@shadowDOM} aside iframe")

  getView: (view) ->
    chrome.extension.getURL("views/#{view}.html")

  ### Controls #####################################

  open: (capture) ->
    @capture().attr('src', capture)
    @details().container.velocity { opacity: 1 },
      duration: 500, display: 'block', begin: =>
        $('html').css overflow: 'hidden'
    @sidebar().container.velocity { translateX: ["0px","400px"] },
      duration: 435, easing: [0.175, 0.885, 0.32, 1.275]
    @isActive = true

  close: ->
    @details().container.velocity { opacity: 0 },
      duration: 500, display: 'none', complete: =>
        $('html').css overflow: 'initial'
    @sidebar().container.velocity { translateX: ["400px","0px"] },
      duration: 500, easing: "ease-out"
    @isActive = false

  ### Web Components ###############################

  injectComponents: ->
    $('head').append """<link rel="import" href="#{@getView('components')}">"""

  attachComponents: ->
    @details().iframe.attr 'src', @getView('details/index')
    @sidebar().iframe.attr 'src', @getView('sidebar/index')

####################################################
#  Messages
####################################################

window.addEventListener 'BettrLinkAttached', (event) ->
  @BettrLink.attachComponents()

window.addEventListener 'BettrLinkDetached', (event) ->
  @BettrLink.isReady = false

####################################################
#  Initialize
####################################################

initialize = =>
  if @jQuery? and @jQuery.Velocity? and @Vibrant?
  then @BettrLink.injectComponents()
  else setTimeout 'initialize()', 10

initialize()
