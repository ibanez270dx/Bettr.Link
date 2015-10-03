(function() {
  this.BettrLink = {
    appRoot: chrome.extension.getURL('/'),
    isActive: false,
    overlay: function() {
      return $('#bettrlink-overlay');
    },
    capture: function() {
      return $('#bettrlink-capture');
    },
    sidebar: function() {
      return $('#bettrlink-sidebar');
    },
    iframe: function() {
      return $('#bettrlink-iframe');
    },
    injectHTML: function() {
      return $.get(this.appRoot + "views/injected.html", (function(_this) {
        return function(html) {
          $('body').append(html);
          _this.iframe().attr('src', _this.appRoot + "views/index.html");
          return _this.toggle();
        };
      })(this));
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
      this.capture().attr('src', dataUri).velocity({
        blur: 6,
        opacity: 0.4
      }, {
        duration: 500,
        begin: (function(_this) {
          return function(capture) {
            $('html').addClass('bettrlink-no-scroll');
            _this.scrapePageInfo();
            return _this.overlay().show();
          };
        })(this)
      });
      this.sidebar().velocity({
        translateX: ["0px", "400px"]
      }, {
        duration: 435,
        easing: [0.175, 0.885, 0.32, 1.275]
      });
      return this.isActive = true;
    },
    close: function() {
      this.capture().velocity({
        blur: 0,
        opacity: 1
      }, {
        duration: 600,
        complete: (function(_this) {
          return function() {
            $('html').removeClass('bettrlink-no-scroll');
            return _this.overlay().hide();
          };
        })(this)
      });
      this.sidebar().velocity({
        translateX: ["400px", "0px"]
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

  this.BettrLink;

}).call(this);
