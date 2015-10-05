
# Imported DOM (components.html)
importDoc = document.currentScript.ownerDocument

# Configure & register BettrLink UI element
document.registerElement 'bettrlink-ui',
  prototype: Object.create HTMLElement.prototype,
    createdCallback: value: ->
      console.log 'bettrlink-ui created'
      template = importDoc.querySelector 'template'
      imported = document.importNode template.content, true
      @createShadowRoot().appendChild imported

    attachedCallback: value: ->
      console.log 'bettrlink-ui attached'
      document.dispatchEvent new CustomEvent 'BettrLink',
        detail: 'open'

    detachedCallback: value: ->
      console.log 'bettrlink-ui detached'

    attributeChangedCallback: value: ->
      console.log 'bettrlink-ui changed'

# Add to the main document
document.body.appendChild(
  document.createElement 'bettrlink-ui'
);
