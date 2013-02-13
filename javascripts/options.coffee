$ ->
  GTalkSyntax.data_collection_option (value = 'localhost:3000')->
    if value == 'on' || value == 'off'
      $("option[value=#{value}]").attr('selected', 'selected')
    else
      $("option[value=custom]").attr('selected', 'selected')
      $('#collection_custom_url').val(value).show()

  GTalkSyntax.auto_detect_option (value = false)->
    $('#auto_detect_input').check() if value


  $('figure.kudo.kudoable').kudoable();




$(document).on 'change', '#collection_method_input, #collection_custom_url', ->
  value = $('#collection_method_input').val()

  # we track before learning the value of the field, for privacy reasons
  GTalkSyntax.track "Set #{value}", 'Data Collection'

  if value == 'custom'
    $('#collection_custom_url').show()
    value = $('#collection_custom_url').val()
  else
    $('#collection_custom_url').hide()

  GTalkSyntax.data_collection_option value, (value)->
    $('#collection_method_status').html "Saved: #{value}"


$(document).on 'change', '#auto_detect_input', ->
  is_enabled = $('#auto_detect_input').is_checked()
  GTalkSyntax.auto_detect_option is_enabled, (value)->
    $('#auto_detect_status').html "Saved: #{value}"

  if is_enabled
    GTalkSyntax.track 'Enable', 'Auto detection'
  else
    GTalkSyntax.track 'Disable', 'Auto detection'