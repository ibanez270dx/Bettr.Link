do ->
  globals = {}
  globalsBlacklist = ['__commandLineAPI','applicationCache','chrome','closed','console','crypto','CSS','defaultstatus',
    'defaultStatus','devicePixelRatio','document','external','frameElement','history','indexedDB','innerHeight',
    'innerWidth','length','localStorage','location','name','offscreenBuffering','opener','outerHeight','outerWidth',
    'pageXOffset','pageYOffset','performance','screen','screenLeft','screenTop','screenX','screenY','scrollX',
    'scrollY','sessionStorage','speechSynthesis','status','styleMedia']
  prototype = Object.getPrototypeOf(window)
  property = undefined

  for property of window
    if !~property.indexOf('webkit') and                # no webkit properties
       !(property of prototype) and                    # property not in prototype
       !(window[property] == window) and               # property isn't window
       !(window[property] instanceof BarProp) and      # isn't a BarProp object
       !(window[property] instanceof Navigator) and    # isn't a Navigator object
       !~globalsBlacklist.indexOf(property)            # isn't in the blacklist
      globals[property] = window[property]

  anchor = document.createElement('a')
  extensionId = (anchor.href = document.currentScript.src.split('/')[2])
  url = "chrome-extension://#{extensionId}/javascripts/lib/circular-json.min.js"

  $.getScript url, ->
    window.dispatchEvent new CustomEvent 'BettrLink::DataProxy',
      detail: { globals: JSON.stringify(CircularJSON.stringify(globals)) }
