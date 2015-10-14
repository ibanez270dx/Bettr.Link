bettrlink = 'window.BettrLink'

#######################################
# Browser Action
#######################################

chrome.browserAction.onClicked.addListener (tab) ->
  injectCode "#{bettrlink}!=null", (isLoaded) ->
    return toggleUI() if isLoaded[0]
    injectFile 'javascripts/lib/jquery-2.1.4.min.js'
    injectFile 'javascripts/lib/velocity.min.js'
    injectFile 'javascripts/lib/vibrant.min.js'
    injectFile 'javascripts/bettrlink.js', ->
      toggleUI()

toggleUI = ->
  injectCode "#{bettrlink}.isActive", (isActive) ->
    unless isActive[0]
    then captureTabAndOpen()
    else injectCode "#{bettrlink}.close()"

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
    injectCode "#{bettrlink}.open('#{dataURI}')"
