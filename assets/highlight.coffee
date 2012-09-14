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


  setCategory: (category)->
    if category == 'text'
      @html( @data('original_html') )
    else if category == 'code'
      @html @highlighted_text()

    @add_hud()

    bayes.train(@baysian_data() , category);

  guess: ->
    @setCategory bayes.classify @text()

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

console.log('loaded highlight')


