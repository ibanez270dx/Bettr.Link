
####################################################
#  Messages
####################################################

window.addEventListener 'BettrLinkAttached', (event) ->
  # Attach and Register UI Components
  unless @BettrLink.UI.isRegistered
    @BettrLink.UI.attachComponents()
    @BettrLink.UI.isRegistered = true
  # Kick off scraping / parsing
  @BettrLink.Parser.scrape()

window.addEventListener 'BettrLinkDataProxy', (event) ->
  if (data = event.detail).globals?
    @BettrLink.Parser.setGlobals data.globals

####################################################
#  Initialize
####################################################

initialize = =>
  if @jQuery? and @jQuery.Velocity? and @Vibrant?
  then @BettrLink.UI.injectComponents()
  else setTimeout 'initialize()', 10

initialize()
