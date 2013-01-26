window.bayes = new classifier.Bayesian();
bayes.fromJSON(classifier_info) if @['classifier_info']

class Highlight
  highlighted_text: ->
    text = $('<div/>').html( @data('original_html').replace(/<br>/g, 'REPLACEMENT_LINEBREAK')).text()

    text = hljs.highlightAuto(text).value.replace(/REPLACEMENT_LINEBREAK/g, '<br>')

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
    if original_text.indexOf('`') != -1
      # if there are backticks, don't be smart about it
      @setDisplay bayes.classify('text')
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
  setTimeout(highlightNewMessages, 200)

setTimeout(highlightNewMessages, 1000)

console.log('loaded highlight 3')


