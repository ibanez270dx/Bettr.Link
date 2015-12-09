@BettrLink ||= {}
@BettrLink.Parser =
  BettrLink: this.BettrLink
  promises: {}

  scrape: ->
    # @_metatags()

    $.when(@_globals(), @_headers(), @_location()).then (g, h, l) =>
      console.log " => globals: ", g
      console.log " => headers: ", h
      console.log " => location: ", l

  setGlobals: (data) ->
    console.log "setGlobals: ", data
    console.log "circular? ", CircularJSON.parse(data)
    @promises.globals.resolve(CircularJSON.parse(data))

  ##############################################################################

  _globals: ->
    @promises.globals = (deferred = $.Deferred())
    url = chrome.extension.getURL "javascripts/views/window.js"
    $('head').append $("<script src='#{url}'></script>")
    deferred.promise()

  _headers: ->
    response = {}
    $.get(document.location).then (data, status, xhr) ->
      for header in xhr.getAllResponseHeaders().split('\n')
        pair = header.toString().trim().split(': ')
        response[pair[0]] = pair[1]
      response

  _location: ->
    location = document.location
    $.Deferred().resolve(
      protocol: location.protocol
      host: location.host
      hostname: location.hostname
      href: location.href
      origin: location.origin
      port: location.port
      pathname: location.pathname
      search: location.search
      hash: location.hash
    ).promise()

  _metatags: ->
    console.log "parse!"
    result =
      site: @getMeta('site')
      type: @getMeta('type')
      category: @getMeta('category')
      title: @getMeta('title')
      description: @getMeta('description')
      keywords: @getMeta('keywords')
      icon: @getMeta('icon')
      image: @getMeta('image')
      author: @getMeta('author')
      published: @getMeta('published')
      url: @getMeta('url')
      # analysis: @analyzeText($('body').text())

  ##############################################################################

  tags:
    site:        ['[property="og:site_name"]','[name="application-name"]','[name="apple-mobile-web-app-title"]']
    type:        ['[property="og:type"]','[name="medium"]','[name="Classification"]','[property="og:video:type"]','[property="og:audio:type"]']
    category:    ['[name="category"]','[name="topic"]']
    title:       ['[property="og:title"]','[name="twitter:title"]','[itemprop="name"]','[name="pagename"]','[name="apple-mobile-web-app-title"]','document.title']
    description: ['[property="og:description"]','[name="description"]','[name="subject"]','[name="abstract"]','[name="subtitle"]']
    keywords:    ['[name="keywords"]']
    icon:        ['[rel="fluid-icon"]','[rel="shortcut icon"]','[rel="apple-touch-icon"]']
    image:       ['[property="og:image"]','[rel="apple-touch-startup-image"]']
    author:      ['[name="author"]','[name="owner"]','[name="designer"]','[property="fb:admins"]','[name="me"]']
    published:   ['[name="date"]']
    url:         ['[name="url"]','[name="identifier-URL"]']

  getContent: (target) ->
    element = switch
      when target.is('meta') then target.attr('content')
      when target.is('link') then target.attr('href')
      else target

  getMeta: (meta) ->
    for tag in @tags[meta]
      console.log "tag: ", tag
      content = @getContent $(tag)
      return content if content?.length > 0

  ##############################################################################
  # Find common keywords to use as suggested tags
  ##############################################################################

  stopWords: ["a","about","above","after","again","against","all","am","an","and","any","are","aren't","as",
    "at","be","because","been","before","being","below","between","both","but","by","can't","cannot",
    "could","couldn't","did","didn't","do","does","doesn't","doing","don't","down","during","each",
    "few","for","from","further","had","hadn't","has","hasn't","have","haven't","having","he","he'd",
    "he'll","he's","her","here","here's","hers","herself","him","himself","his","how","how's","i",
    "i'd","i'll","i'm","i've","if","in","into","is","isn't","it","it's","its","itself","let's","me",
    "more","most","mustn't","my","myself","no","nor","not","of","off","on","once","only","or","other",
    "ought","our","ours","ourselves","out","over","own","same","shan't","she","she'd","she'll","she's",
    "should","shouldn't","so","some","such","than","that","that's","the","their","theirs","them",
    "themselves","then","there","there's","these","they","they'd","they'll","they're","they've","this",
    "those","through","to","too","under","until","up","very","was","wasn't","we","we'd","we'll","we're",
    "we've","were","weren't","what","what's","when","when's","where","where's","which","while","who",
    "who's","whom","why","why's","with","won't","would","wouldn't","you","you'd","you'll","you're",
    "you've","your","yours","yourself","yourselves"]

  visibleText: ->
    $.map(window.contents(), (element) ->
      return $(element).text() if element.nodeType == 3
      return $(element).visibleText() if $(element).is(':visible')
    ).join ''

  # textWords: (text) ->
  #   words = text.match(/[a-zA-Z\-]+/g)
  #   if words?
  #     for i in [0..words.length]
  #       word = words[i]?.toLowerCase().trim()
  #       if @stopWords.indexOf(word) == -1
  #         words[i] = word
  #     words
  #
  # wordsFrequencies: (words) ->
  #   [frequencies, currentWord] = [{}, null]
  #   for i in [0..words.length]
  #     word = words[i]?.toLowerCase().trim()
  #     if @stopWords.indexOf(word) == -1
  #       currentWord = words[i]
  #       frequencies[currentWord] = (frequencies[currentWord] or 0) + 1
  #   frequencies
  #
  # sortedListOfWords: (wordsFrequencies) ->
  #   words = []
  #   for key of @wordsFrequencies
  #     words.push key if @wordsFrequencies.hasOwnProperty(key)
  #   words.sort()
  #
  # topTenWords: (freqs) ->
  #   [frequencies, result] = [[],[]]
  #
  #   for key of freqs
  #     frequencies.push [key, freqs[key]] if freqs.hasOwnProperty(key)
  #
  #   frequencies = frequencies.sort (freq1, freq2) ->
  #     if freq1[1] < freq2[1] then 1 else
  #       if freq1[1] > freq2[1] then -1 else 0
  #
  #   result[i] = frequencies[i] for i in [0..10]
  #
  # analyzeText: (text) ->
  #   words = @textWords(text)
  #   frequencies = @wordsFrequencies(words)
  #   used = @sortedListOfWords(frequencies)
  #   topTen = @topTenWords(frequencies)
  #   return topTen
