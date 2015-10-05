#######################################
# Browser Action
#######################################

chrome.browserAction.onClicked.addListener (tab) ->
  chrome.tabs.executeScript tab.id, code: 'window.BettrLink===undefined', (result) ->
    if result[0]
      # Inject javascripts
      chrome.tabs.executeScript null, file: 'javascripts/lib/jquery-2.1.4.min.js'
      chrome.tabs.executeScript null, file: 'javascripts/lib/velocity.min.js'
      chrome.tabs.executeScript null, file: 'javascripts/lib/vibrant.min.js'
      chrome.tabs.executeScript null, file: 'javascripts/bettrlink.js'
    else
      # BettrLink is already loaded, just toggle sidebar
      chrome.tabs.executeScript null, code: 'window.BettrLink.toggle()'

#######################################
# Message Passing
#######################################

chrome.runtime.onMessage.addListener (request, sender, sendResponse) ->
  console.log "request: ", request
  console.log "sender: ", sender
  console.log "sendResponse: ", sendResponse

  switch request
    when 'captureVisibleTab'
      chrome.tabs.captureVisibleTab null, format: 'jpeg', quality: 80, (dataURI) ->
        sendResponse dataURI
    when 'openUI'
      console.log "open it!"

  return true  # required to be asynchronous
