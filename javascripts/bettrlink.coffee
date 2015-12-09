
####################################################
# Message Passing
####################################################

@addEventListener 'BettrLink::Attached', (event) ->
  # Attach and Register UI Components
  unless @BettrLink.UI.isRegistered
    @BettrLink.UI.attachComponents()
    @BettrLink.UI.isRegistered = true

  # Kick off scraping / parsing
  @BettrLink.Parser.scrape()

# @addEventListener 'BettrLink::DataProxy', (event) ->
#   console.log "hit dataproxy"
#   if (data = event.detail).globals?
#     @BettrLink.Parser.setGlobals data.globals

####################################################
#  Initialize
####################################################

initialize = ->
  @BettrLink.UI.injectComponents()
  @BettrLink.Parser.scrape()

waitForScripts = =>
  if @jQuery? and @jQuery.Velocity? and @Vibrant?
  then initialize()
  else setTimeout 'waitForScripts()', 10
