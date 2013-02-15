textarea = document.getElementById('textarea')

# any method here will have @request, @sender, and @respond available
# add a new method to make a named command
Background = {
  receive_message: (request, sender, respond) ->
    console.log("from the extension", request)
    unless request.command
      throw 'No Command given.'

    Background.request = request
    Background.sender = sender
    Background.respond = respond
    Background[request.command]()

  copy: ->
    if @request.content == ''
      @respond {status: 'Empty string given.'}
      return

    textarea.value = @request.content
    textarea.select()
    @respond {status: document.execCommand('Copy')}

  track: ->
    _gaq.push(['_trackEvent', @request.noun, @request.verb]);
    @respond {status: "Tracking #{@request.noun} #{@request.verb}"}
}


chrome.extension.onMessage.addListener Background.receive_message
