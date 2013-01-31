window.bayes = new classifier.Bayesian();
bayes.fromJSON(classifier_info) if @['classifier_info']

auto_detect_option = false

GTalkSyntax.auto_detect_option (value) ->
  auto_detect_option = value

class Highlight
  highlighted_text: ->
    text = $('<div/>').html( @data('original_html').replace(/<br>/g, "\n")).text()

    text = hljs.highlightAuto(text).value.replace(/\n/g, '<br>')

    "<pre style='overflow-x: auto;'><code>#{text}</code></pre>"


  baysian_data: ->
    # todo: make use of keyword_count, r, and so on.
    @text().split(' ')


  setDisplay: (category)->
    if category == 'text'
      original_html = @data('original_html')
      original_html = original_html.replace /`(.+?)`/g, (match, text, urlId)->
        " <pre style='overflow-x: auto; display: inline-block;'><code>#{text}</code></pre> "
      @html original_html
    else if category == 'code'
      @html @highlighted_text()

    @add_hud()

  setCategory: (category)->
    @setDisplay category


    # todo: get rid of this? don't? Persist w/ localstorage?
    bayes.train(@baysian_data() , category)

    if GTalkSyntax.host
      console.log('training', GTalkSyntax.url('/classifiers/1/train'))
      # todo: move to custom "remote" backend? Fancy classifier version?
      $.post GTalkSyntax.url('/classifiers/1/train'), {cat: category, doc: @baysian_data()}


  guess: ->
    original_text = @text()
    if auto_detect_option == false || original_text.indexOf('`') != -1
      # if there are backticks, don't be smart about it
      @setDisplay 'text'
    else
      @setDisplay bayes.classify(original_text)

  add_hud: ->
    @append("<div class='GTalkSyntax-HUD'><span class='GTalkSyntax-text'>text</span> | <span class='GTalkSyntax-code'>code</span></div>")
    @find(".GTalkSyntax-code").click => @setCategory 'code'
    @find(".GTalkSyntax-text").click => @setCategory 'text'


# to be called on a span with text
$.fn.highlight = ->
  @each (index, element) ->

    element = $(element)
    for key, value of Highlight::
      element[key] = value

    element.css({position: 'relative'}).data( {original_html: element.html()} ).guess()


highlightNewMessages = ->
  $('[role=log] .kl').filter( -> $(@).find('.GTalkSyntax-HUD').length < 1 ).highlight();
  setTimeout(highlightNewMessages, 150)

setTimeout(highlightNewMessages, 1000)

console.log('loaded highlight')


