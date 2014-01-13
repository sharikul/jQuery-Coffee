define [
    '../ajax'

], (jQuery) ->

    jQuery._evalUrl = (url) ->

        jQuery.ajax

            url: url
            type: 'GET'
            dataType: 'script'
            async: false
            global: false
            'throws': true

    jQuery._evalUrl
