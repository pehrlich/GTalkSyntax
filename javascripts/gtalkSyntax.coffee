# todo: can we get rid of underscore.js?
class window.GTalkSyntax
  # set this to true when publishing to the web store to turn on analytics.
  @published: false
  @host: null

  @refresh_host: ->
    chrome.storage.sync.get 'data_collection_option', (items)=>
      console.log('refresh host2', this, arguments)
      @host = switch items.data_collection_option
        when 'on'
          'http://gtalksyntax.herokuapp.com'
        when 'off'
          null
        else
          items.data_collection_option

  @url: (path)->
    unless @host
      throw "Highlight: data collection disabled, no host set"
    "#{@host}/#{path.replace(/^\//, '')}"

  # creates a getter/setter method which takes an optional value and mandatory callback.
  @attr_accessor: (name, attr_default) ->
    @[name] = (value, callback) ->
      if $.isFunction(value) && !callback
        callback = value
        value = undefined

      if value != undefined
        options = {}
        options[name] = value
        # in what could be a bug, no args are passed to the callback by chrome.  We alter this behavior here:
        chrome.storage.sync.set options, ->
          callback(this.args[1][name])
      else
        chrome.storage.sync.get name, (items)->
          callback(items[name] || attr_default)

  # sends a message to the background page
  # takes an optional callback
  @send: (command, options, callback) ->
    options.command = command
    callback ||= ()->
      console.log 'Message Response', arguments
    chrome.extension.sendMessage options, callback

  @track: (verb, noun) ->
    if @published
      @send('track', {noun: noun, verb: verb})
    else
      console.log "Faux tracking #{verb} #{noun}"

  @attr_accessor('data_collection_option', 'off')
  @attr_accessor('auto_detect_option', false)
  @refresh_host()