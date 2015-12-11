
@waitFor = (variables, callback) ->
  loaded = []
  for variable in variables
    loaded.push switch variable
      when "jquery"        then @jQuery?
      when "velocity"      then @jQuery.Velocity?
      when "vibrant"       then @Vibrant?
      when "circular-json" then @CircularJSON?
  if loaded.indexOf(false) >= 0
  then setTimeout (-> waitFor(variables, callback)), 10
  else callback()

@trigger = (event, data) ->
  chrome.runtime.sendMessage { event: event, data: data }
