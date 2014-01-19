define [
    '../core'
    '../ajax'

], (jQuery) ->

    jQuery.ajaxSetup
        accepts: 
            script: 'text/javascript, application/javascript, application/ecmascript, application/x-ecmascript'

        contents: 
            script: /(?:java|ecma)script/

        converters: 
            'text script': (text) ->
                jQuery.globalEval text

                text

    jQuery.ajaxPrefilter 'script', (s) ->

        if s.cache is undefined
            s.cache = off

        if s.crossDomain
            s.type = 'GET'


    jQuery.ajaxTransport 'script', (s) ->

        if s.crossDomain
            script = callback = undefined

            return {
                send: (_, complete) ->

                    script = jQuery('<script>').prop(

                        async: yes
                        charset: s.scriptCharset
                        src: s.url

                    ).on('load error', 

                        callback = (evt) ->
                            script.remove
                            callback = null

                            if evt
                                complete (if evt.type is error then 404 else 200), evt.type

                    )

                    document.head.appendChild script[0]

                abort: ->
                        callback() if callback
            }
