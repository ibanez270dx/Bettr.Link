(function() {
  chrome.browserAction.onClicked.addListener(function(tab) {
    return chrome.tabs.executeScript(tab.id, {
      code: 'window.BettrLink===undefined'
    }, function(result) {
      if (result[0]) {
        chrome.tabs.executeScript(null, {
          file: 'javascripts/lib/jquery-2.1.4.min.js'
        });
        chrome.tabs.executeScript(null, {
          file: 'javascripts/lib/velocity.min.js'
        });
        chrome.tabs.executeScript(null, {
          file: 'javascripts/lib/vibrant.min.js'
        });
        return chrome.tabs.executeScript(null, {
          file: 'javascripts/bettrlink.js'
        });
      } else {
        return chrome.tabs.executeScript(null, {
          code: 'window.BettrLink.toggle()'
        });
      }
    });
  });

  chrome.runtime.onMessage.addListener(function(request, sender, sendResponse) {
    console.log("request: ", request);
    console.log("sender: ", sender);
    console.log("sendResponse: ", sendResponse);
    switch (request) {
      case 'captureVisibleTab':
        chrome.tabs.captureVisibleTab(null, {
          format: 'jpeg',
          quality: 80
        }, function(dataURI) {
          return sendResponse(dataURI);
        });
        break;
      case 'openUI':
        console.log("open it!");
    }
    return true;
  });

}).call(this);
