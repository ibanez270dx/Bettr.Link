bettrlink = 'window.BettrLink'
page = undefined

#######################################
# Browser Action
#######################################

chrome.browserAction.onClicked.addListener (tab) ->
  injectCode "document.querySelector('bettrlink-ui')!=null", (isLoaded) ->
    return toggleUI() if isLoaded[0]
    loadUI()

loadUI = ->
  injectFile 'javascripts/lib/jquery-2.1.4.min.js'
  injectFile 'javascripts/lib/velocity.min.js'
  injectFile 'javascripts/lib/vibrant.min.js'
  injectFile 'javascripts/lib/circular-json.min.js'
  injectFile 'javascripts/components/helpers.js'
  injectFile 'javascripts/components/ui.js'
  injectCode 'window.location.toString()', (url) ->
    analyzeUrl url

toggleUI = ->
  injectCode "#{bettrlink}.UI.isActive", (isActive) ->
    unless isActive[0]
    then captureTabAndOpen()
    else injectCode "#{bettrlink}.UI.close()"

#######################################
# Messages
#######################################

chrome.runtime.onMessage.addListener (message) ->
  console.log "message: ", message
  switch message.event
    when 'captureTabAndOpen' then captureTabAndOpen()
    when 'processDetails'    then processDetails(message)

#######################################
# Ajax Requests
#######################################

analyzeUrl = (url) ->
  $.ajax
    url: "http://api.bettrlink.dev/v1/analyze",
    data: { url: decodeURIComponent(url[0]) }
    success: (data) ->
      console.log "success: ", data
      page = datas
      chrome.runtime.sendMessage { event: 'pooping', page: data }, (response) ->
        console.log "response: ", response

#######################################
# Utility
#######################################

injectFile = (file, callback) ->
  chrome.tabs.executeScript null, file: file, (result) ->
    callback(result) if callback?

injectCode = (code, callback) ->
  chrome.tabs.executeScript null, code: code, (result) ->
    callback(result) if callback?

captureTabAndOpen = ->
  chrome.tabs.captureVisibleTab null, format: 'jpeg', quality: 80, (dataURI) ->
    injectCode "#{bettrlink}.UI.open('#{dataURI}')"

# processDetails = (data) ->
#   chrome.tabs.getSelected null, (tab) ->
#     chrome.tabs.sendMessage(tab.id, data) if tab
