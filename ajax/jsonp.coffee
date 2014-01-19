define [
    '../core'
    './var/nonce'
    './var/rquery'
    '../ajax'

], (jQuery, nonce, rquery) ->

    oldCallbacks = []
    rjsonp = /(=)\?(?=&|$)|\?\?/

    jQuery.ajaxSetup
        jsonp: 'callback'

        jsonpCallback: ->
            callback = oldCallbacks.pop() or ("#{jQuery.expando}_#{nonce++}")
            @[callback] = yes

            callback

    jQuery.ajaxPrefilter 'json jsonp', (s, originalSettings, jqXHR) ->

        callbackName = overwritten = responseContainer = undefined

        jsonProp = if s.jsonp isnt no and ( rjsonp.test s.url ) 
        then 'url' else typeof s.data is 'string' and not (s.contentType or '').indexOf('application/x-www-form-urlencoded') and 'data'

        if jsonProp or s.dataTypes[0] is 'jsonp'
            callbackName = if s.jsonpCallback = jQuery.isFunction s.jsonpCallback then s.jsonpCallback() else s.jsonpCallback

            if jsonProp
                s[ jsonProp ] = s[ jsonProp ].replace rjsonp, "$1#{callbackName}"

            else if s.jsonp isnt no
                s.url += ( if rquery.test s.url then '&' else '?') + "#{s.jsonp}=#{callbackName}"

            s.converters['script json'] = ->
                if not responseContainer
                    jQuery.error "#{callbackName} was not called"

                responseContainer[0]

            s.dataTypes[0] = 'json'

            overwritten = window[callbackName]

            window[callbackName] = ->
                responseContainer = arguments

            jqXHR.always ->
                window[callbackName] = overwritten

                if s[callbackName]
                    s.jsonpCallback = originalSettings.jsonpCallback

                    oldCallbacks.push callbackName

                if responseContainer and jQuery.isFunction overwritten
                    overwritten responseContainer[0]

                responseContainer = overwritten = undefined

            'script'
