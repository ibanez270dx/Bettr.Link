class Parser

  constructor: ->
    @url = window.location.toString()

    window.waitFor ['jquery'], =>
      console.log "--> http://api.bettrlink.dev/v1/analyze?url=#{@url}"

      # I suppose we'll just call the new endpoint
      # $.ajax
      #   url: "http://api.bettrlink.dev/v1/analyze",
      #   data: { url: @url }
      #   success: (data) ->
      #     console.log "success: ", data
      #     chrome.runtime.sendMessage { event: 'pooping', page: data }, (response) ->
      #       console.log "response: ", response


####################################################
# Initialize
####################################################

@BettrLink ||= {}
@BettrLink.Parser = new Parser()
