do ->
  globals = {}
  globalsBlacklist = ['__commandLineAPI','applicationCache','chrome','closed','console','crypto','CSS','defaultstatus',
    'defaultStatus','devicePixelRatio','document','external','frameElement','history','indexedDB','innerHeight',
    'innerWidth','length','localStorage','location','name','offscreenBuffering','opener','outerHeight','outerWidth',
    'pageXOffset','pageYOffset','performance','screen','screenLeft','screenTop','screenX','screenY','scrollX',
    'scrollY','sessionStorage','speechSynthesis','status','styleMedia']
  property = undefined
  prototype = Object.getPrototypeOf(window)

  for property of window
    if !~property.indexOf('webkit') and
       !(property of prototype) and
       window[property] != window and
       !(window[property] instanceof BarProp) and
       !(window[property] instanceof Navigator) and
       !~globalsBlacklist.indexOf(property)
      globals[property] = window[property]

  window.dispatchEvent new CustomEvent 'BettrLinkDataProxy',
    detail: { globals: JSON.stringify(globals) }
