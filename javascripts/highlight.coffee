window.bayes = new classifier.Bayesian();
bayes.fromJSON(classifier_info) if @['classifier_info']

auto_detect_option = false

GTalkSyntax.auto_detect_option (value) ->
  auto_detect_option = value

class Highlight
  # all methods in this class are copied on to a jQuery object, so 'this' can be treated as one.
  highlighted_text: ->
    text = $('<div/>').html( @data('original_html').replace(/<br>/g, "\n")).text()

    text = hljs.highlightAuto(text).value.replace(/\n/g, '<br>')

    "<pre style='overflow-x: auto;'><code style='overflow-x: auto;'>#{text}</code></pre>"


  baysian_data: ->
    # todo: make use of keyword_count, r, and so on.
    @text().split(' ')


  setDisplay: (category)->
    if category == 'text'
      original_html = @data('original_html')
      # recognize backtics for inline code highlighting:
      original_html = original_html.replace /`(.+?)`/g, (match, text, urlId)->
        " <pre style='overflow-x: auto; display: inline-block;'><code>#{text}</code></pre> "
      @html original_html
    else if category == 'code'
      @html @highlighted_text()

    @add_hud()
    @find(".GTalkSyntax-#{category}").addClass('current')

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
    @append "
      <div class='GTalkSyntax-HUD'>
        <span class='GTalkSyntax-text'>text</span> |
        <span class='GTalkSyntax-code'>code</span>
        <span class='GTalkSyntax-caret'>
          <b></b>
        </span>
        <ul class='dropdown-menu'>
          <li class='GTalkSyntax-copy'>
            Copy Code
          </li>
          <li class='GTalkSyntax-share'>
            Share Plugin
          </li>
        </ul>
     </div>
      "
    @code_button().click =>
      @setCategory 'code'
      GTalkSyntax.track 'click', 'code'
    @text_button().click =>
      @setCategory 'text'
      GTalkSyntax.track 'click', 'text'
    @find(".GTalkSyntax-caret").click (e)=>
      @dropdown().toggle()
      GTalkSyntax.track 'toggle', 'dropdown'
    @share_link().click (e)=>
      @text_area().concat(' https://chrome.google.com/webstore/detail/gtalk-syntax-highlighting/okpdnaeoefggpaccmolhoaiffmmdoool ')
      GTalkSyntax.track 'click', 'share plugin'
    @copy_link().click (e)=>
      GTalkSyntax.track 'click', 'copy contents'
      chrome.extension.sendMessage {command: "copy", content: $("<span>#{@data('original_html')}</span>").text()}, (response) ->
        console.log 'Message Response', response

  hud: -> @find(".GTalkSyntax-HUD:first")
  menu: -> @find('ul.dropdown-menu')
  share_link: -> @find(".GTalkSyntax-share")
  copy_link: -> @find(".GTalkSyntax-copy")
  dropdown: -> @find(".dropdown-menu")
  text_area: -> @closest('[role=dialog]').find('textarea:first')
  code_button: ->  @find(".GTalkSyntax-code")
  text_button: ->  @find(".GTalkSyntax-text")



# to be called on a span with text
$.fn.highlight = ->
  @each (index, element) ->
    el = $(element)
    for key, value of Highlight::
      el[key] = value

    el.css({position: 'relative'}).data( {original_html: el.html()} ).guess()

    el.on 'mouseenter', (e)->
      el.hud().show()
    el.on 'mouseleave', (e)->
      el.hud().hide()


highlightNewMessages = ->
  # only highlight unhighlighted message items
  $('[role=log] .kl, [role=log] .kk [id]').filter( -> $(@).find('.GTalkSyntax-HUD').length < 1 ).highlight();
  setTimeout(highlightNewMessages, 150)

setTimeout(highlightNewMessages, 1000)


console.log 'Loaded gTalk Highlighter'

