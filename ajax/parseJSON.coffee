define [
    '../core'

], (jQuery) ->
    
    jQuery.parseJSON = (data) ->
        JSON.parse data + ''

    jQuery.parseJSON