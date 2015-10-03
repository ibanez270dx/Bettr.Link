(function() {
  chrome.browserAction.onClicked.addListener((function(_this) {
    return function(tab) {
      return chrome.tabs.captureVisibleTab(null, {
        format: 'jpeg',
        quality: 80
      }, function(dataUri) {
        return chrome.tabs.executeScript(tab.id, {
          code: "var dataUri = '" + dataUri + "'"
        }, function() {
          return chrome.tabs.executeScript(tab.id, {
            code: 'window.BettrLink===undefined'
          }, function(result) {
            if (!result[0]) {
              return chrome.tabs.executeScript(null, {
                code: 'window.BettrLink.toggle()'
              });
            } else {
              chrome.tabs.insertCSS(null, {
                file: 'stylesheets/injected.css'
              });
              return chrome.tabs.executeScript(null, {
                file: 'javascripts/jquery-2.1.4.min.js'
              }, function() {
                return chrome.tabs.executeScript(null, {
                  file: 'javascripts/velocity.min.js'
                }, function() {
                  return chrome.tabs.executeScript(null, {
                    file: 'javascripts/vibrant.min.js'
                  }, function() {
                    return chrome.tabs.executeScript(null, {
                      file: 'javascripts/bettrlink.js'
                    }, function() {
                      return chrome.tabs.executeScript(null, {
                        code: 'window.BettrLink.injectHTML()'
                      });
                    });
                  });
                });
              });
            }
          });
        });
      });
    };
  })(this));

}).call(this);
