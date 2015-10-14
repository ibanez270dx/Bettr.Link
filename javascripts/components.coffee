
# Reference Imported DOM (components.html)
importDoc = document.currentScript.ownerDocument

# Configure & register BettrLink UI element
document.registerElement 'bettrlink-ui',
  prototype: Object.create HTMLElement.prototype,
    createdCallback: value: ->
      template = importDoc.querySelector 'template'
      imported = document.importNode template.content, true
      @createShadowRoot().appendChild imported

    attachedCallback: value: ->
      console.log 'bettrlink-ui attached'
      window.dispatchEvent new CustomEvent 'BettrLinkAttached'

    detachedCallback: value: ->
      console.log 'bettrlink-ui detached'
      window.dispatchEvent new CustomEvent 'BettrLinkDetached'

    attributeChangedCallback: value: ->
      console.log 'bettrlink-ui changed'

# Add to the main document
document.body.appendChild(
  document.createElement 'bettrlink-ui'
);
