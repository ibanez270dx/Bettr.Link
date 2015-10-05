(function() {
  var importDoc;

  importDoc = document.currentScript.ownerDocument;

  document.registerElement('bettrlink-ui', {
    prototype: Object.create(HTMLElement.prototype, {
      createdCallback: {
        value: function() {
          var imported, template;
          console.log('bettrlink-ui created');
          template = importDoc.querySelector('template');
          imported = document.importNode(template.content, true);
          return this.createShadowRoot().appendChild(imported);
        }
      },
      attachedCallback: {
        value: function() {
          console.log('bettrlink-ui attached');
          return document.dispatchEvent(new CustomEvent('BettrLink', {
            detail: 'open'
          }));
        }
      },
      detachedCallback: {
        value: function() {
          return console.log('bettrlink-ui detached');
        }
      },
      attributeChangedCallback: {
        value: function() {
          return console.log('bettrlink-ui changed');
        }
      }
    })
  });

  document.body.appendChild(document.createElement('bettrlink-ui'));

}).call(this);
