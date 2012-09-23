$ ->
  GTalkSyntax.data_collection_option (value = 'localhost:3000')->
    if value == 'on' || value == 'off'
      $("option[value=#{value}]").attr('selected', 'selected')
    else
      $("option[value=custom]").attr('selected', 'selected')
      $('#collection_custom_url').val(value).show()

$(document).on 'change', '#collection_method_input, #collection_custom_url', ->
  if (value = $('#collection_method_input').val()) == 'custom'
    $('#collection_custom_url').show()
    value = $('#collection_custom_url').val()
  else
    $('#collection_custom_url').hide()

  GTalkSyntax.data_collection_option value, (value)->
    $('#collection_method_status').html("saved: #{value}")


