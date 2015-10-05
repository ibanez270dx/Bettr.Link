(function() {
  var initialize;

  this.BettrLink = {
    isActive: false,
    shadowDOM: 'bettrlink-ui::shadow',
    article: function() {
      return $("" + this.shadowDOM + " article");
    },
    overlay: function() {
      return $("" + this.shadowDOM + " #overlay");
    },
    capture: function() {
      return $("" + this.shadowDOM + " #capture");
    },
    sidebar: function() {
      return $("" + this.shadowDOM + " aside");
    },
    iframe: function() {
      return $("" + this.shadowDOM + " iframe");
    },
    injectComponents: function() {
      $(document.head).append($('<link>').attr({
        rel: 'import',
        href: chrome.extension.getURL('views/components.html')
      }));
      return this.iframe().attr('src', chrome.extension.getURL('views/index.html'));
    },
    scrapePageInfo: function() {
      var page;
      page = {
        site: $('meta[property*=site_name]') || $('title'),
        name: $('meta[property*=title]') || $('meta[itemprop*=name]') || $('meta[name*=title]') || $('title'),
        desc: $('meta[property*=description]') || $('meta[itemprop*=description]') || $('meta[name*=description]')
      };
      console.log("page: ", page);
      $('#bettrlink-site-title').text(page.name.text());
      return $('#bettrlink-site-url').text(window.location.toString());
    },
    open: function() {
      return chrome.runtime.sendMessage('captureVisibleTab', (function(_this) {
        return function(dataURI) {
          _this.overlay().velocity({
            opacity: 1
          }, {
            duration: 500
          });
          _this.capture().attr('src', dataURI).velocity({
            blur: 6,
            opacity: 0.4
          }, {
            duration: 500,
            begin: function() {
              _this.article().show();
              _this.scrapePageInfo();
              return $('html').css({
                overflow: 'hidden'
              });
            }
          });
          _this.sidebar().velocity({
            translateX: ["0px", "400px"],
            boxShadow: '25px 0px 50px 25px #101115'
          }, {
            duration: 435,
            easing: [0.175, 0.885, 0.32, 1.275]
          });
          return _this.isActive = true;
        };
      })(this));
    },
    close: function() {
      this.overlay().velocity({
        opacity: 0
      }, {
        duration: 500
      });
      this.capture().velocity({
        blur: 0,
        opacity: 1
      }, {
        duration: 600,
        complete: (function(_this) {
          return function() {
            _this.article().hide();
            return $('html').css({
              overflow: 'initial'
            });
          };
        })(this)
      });
      this.sidebar().velocity({
        translateX: ["400px", "0px"],
        boxShadow: '0px 0px 0px 0px transparent'
      }, {
        duration: 500,
        easing: "ease-out"
      });
      return this.isActive = false;
    },
    toggle: function() {
      if (this.isActive) {
        return this.close();
      } else {
        return this.open();
      }
    }
  };

  document.addEventListener('BettrLink', (function(_this) {
    return function(event) {
      console.log('BettrLinkEvent: ', event);
      switch (event.detail) {
        case "open":
          return _this.BettrLink.open();
      }
    };
  })(this));

  initialize = ((function(_this) {
    return function() {
      if ((_this.jQuery != null) && (_this.jQuery.Velocity != null) && (_this.Vibrant != null)) {
        return _this.BettrLink.injectComponents();
      } else {
        return setTimeout('initialize()', 10);
      }
    };
  })(this))();

}).call(this);
