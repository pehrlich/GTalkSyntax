Array.prototype.includes = (item)->
  @indexOf(item) >= 0


$.fn.concat = (concat)->
  @val(@val() + concat)

$.fn.replace = (one, two)->
  html = @html()
  @html html.replace(one, two)

$.fn.disable = ->
  @addClass 'disabled'
  @each ->
    el = $(this)
    if el.is ":input"
      el.attr('disabled', 'disabled')
    else
      el.find(':input').disable().end()

$.fn.enable = ->
  @removeClass 'disabled'
  @each ->
    el = $(this)
    if el.is ":input"
      el.removeAttr 'disabled'
    else
      el.find(':input').enable().end()

$.fn.href = (value)->
  if value
    @attr('href', value)
  else
    @attr('href')


$.fn.check = ->
  @attr('checked', 'checked')

$.fn.uncheck = ->
  @attr('checked', false)

$.fn.is_checked = ->
  if @is(':input')
    @is(':checked')
  else if @is('label[for]')
    $("##{@attr('for')}").is_checked()
  else
    throw 'not an input'



window.mobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent)