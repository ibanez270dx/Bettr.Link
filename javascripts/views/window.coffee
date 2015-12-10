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
    if window[property]? and                           # property exists
       !~property.indexOf('webkit') and                # not a webkit property
       !(property of prototype) and                    # not a prototype property
       !(window[property] == window) and               # not window itself
       !(window[property] instanceof BarProp) and      # not a BarProp object
       !(window[property] instanceof Navigator) and    # not a Navigator object
       !~globalsBlacklist.indexOf(property)            # not in the blacklist
      globals[property] = window[property]

  # Grab the extension ID
  extensionId = document.currentScript.src.split('/')[2]
  extensionURL = "chrome-extension://#{extensionId}"

  $.getScript "#{extensionURL}/javascripts/lib/circular-json.min.js", ->
    window.dispatchEvent new CustomEvent 'BettrLink::Parser::Globals',
      detail: { globals: JSON.stringify(CircularJSON.stringify(globals)) }
