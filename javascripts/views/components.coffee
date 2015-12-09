# Reference Imported DOM (components.html)
importDoc = document.currentScript.ownerDocument

##################################################
# Configure & register BettrLink UI element
##################################################
document.registerElement 'bettrlink-ui',
  prototype: Object.create HTMLElement.prototype,
    createdCallback: value: ->
      template = importDoc.querySelector 'template'
      imported = document.importNode template.content, true
      @createShadowRoot().appendChild imported
    attachedCallback: value: ->
      window.dispatchEvent new CustomEvent 'BettrLink::Attached'
