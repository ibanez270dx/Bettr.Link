
# Tell Parser we're ready for data
@parent.postMessage { id: chrome.runtime.id, view: 'details', trigger: 'ready' }, "*"

# Listen for messages triggered from the background script
# chrome.runtime.onMessage.addListener (message, sender) ->
#   console.log "onMessage (#{sender.id} : #{chrome.runtime.id})"
#   return unless sender.id is chrome.runtime.id
#   [event, data] = [message.event, message.data]
#   console.log "details-event: ", event
#   console.log "details-data: ", data

  # if event is "processDetails"
  #   for key, value of data
  #     $("#details [name=#{key}]").val value
  #
  #   imagePath = unless data['image']?
  #   then $(document.querySelector('bettrlink-ui').shadowRoot).find('#capture').attr('src')
  #   else data['image']
  #
  #   $('#thumbnail').css 'background-image', "url(#{imagePath})"
  #   console.log "background image: ", imagePath

# Listen for changes on bettrlink-ui element
# $('bettrlink-ui')



# Autosize textareas and fix initial height
fixTextareas = ->
  textareas = $('textarea')
  textareas.textareaAutoSize()
  previous = textareas.first().height()
  fixInitHeight = (tries) ->
    return if tries is 0 or textareas.first().height() isnt previous
    textareas.trigger 'input'
    setTimeout (-> fixInitHeight tries-1), 10
  fixInitHeight 10  # attempt to fix height a maximum of 10 times

####################################################
# Initialize
####################################################

$(document).ready ->
  fixTextareas()
