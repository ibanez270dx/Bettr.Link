
# Browser Action
chrome.browserAction.onClicked.addListener (tab) =>

  # Take Screenshot
  chrome.tabs.captureVisibleTab null, format: 'jpeg', quality: 80, (dataUri) =>

    # Store screenshot dataUri to
    chrome.tabs.executeScript tab.id, code: "var dataUri = '#{dataUri}'", =>

      # Load BettrLink sidebar
      chrome.tabs.executeScript tab.id, code: 'window.BettrLink===undefined', (result) =>

        unless result[0]
          chrome.tabs.executeScript null, code: 'window.BettrLink.toggle()'
        else
          chrome.tabs.insertCSS null, file: 'stylesheets/injected.css'
          chrome.tabs.executeScript null, file: 'javascripts/jquery-2.1.4.min.js', ->
            chrome.tabs.executeScript null, file: 'javascripts/velocity.min.js', ->
              chrome.tabs.executeScript null, file: 'javascripts/vibrant.min.js', ->
                chrome.tabs.executeScript null, file: 'javascripts/bettrlink.js', ->
                  chrome.tabs.executeScript null, code: 'window.BettrLink.injectHTML()'
