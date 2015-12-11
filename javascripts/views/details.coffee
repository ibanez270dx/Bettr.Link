# Tell Parser we're ready for data
@parent.postMessage { id: chrome.runtime.id, view: 'details', trigger: 'ready' }, "*"

# Listen for messages triggered from the background script
@chrome.runtime.onMessage.addListener (message, sender) ->
  return unless sender.id is chrome.runtime.id

  if message.event is "processDetails"
    console.log "success ", message.data

    # now manipulate the dom....
