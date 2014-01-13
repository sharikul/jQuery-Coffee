define [
    '../core'
    '../var/support'
    '../ajax'

], (jQuery, support) ->

    jQuery.ajaxSettings.xhr = ->

        try
            return new XMLHttpRequest()
        catch e

        
    xhrId = 0
    xhrCallbacks = {}

    xhrSuccessStatus = 

        0: 200
        1223: 204

    xhrSupported = jQuery.ajaxSettings.xhr()

    if window.ActiveXObject
        jQuery(window).on 'unload', ->
            for key in xhrCallbacks
                key()

    support.cors = !!xhrSupported and ('withCredentials' in xhrSupported)
    support.ajax = xhrSupported = !!xhrSupported

    jQuery.ajaxTransport ->

        callback = undefined

        if support.cors or xhrSupported and !options.crossDomain
            return {

                send: (headers, complete) ->

                    i = undefined
                    xhr = options.xhr()
                    id = ++xhrId

                    xhr.open options.type, options.url, options.async, options.username, options.password

                    if options.xhrFields
                        for i of options.xhrFields
                            xhr[i] = options.xhrFields[i]

                    if options.mimeType and xhr.overrideMimeType
                        xhr.overrideMimeType options.mimeType

                    if not options.crossDomain and !headers['X-Requested-With']
                        headers['X-Requested-With'] = 'XMLHttpRequest'

                    for i of headers
                        xhr.setRequestHeader i, headers[i]

                    callback = (type) ->

                        ->
                            if callback
                                delete xhrCallbacks[ id ]

                                callback = xhr.onload = xhr.onerror = null

                                if type is 'abort'
                                    xhr.abort()

                                else if type is 'error'
                                    complete xhr.status, xhr.statusText


                                else
                                    complete xhrSuccessStatus[ xhr.status ] or xhr.status, xhr.statusText, ( if typeof xhr.responseText is 'string' then{text: xhr.responseText} else undefined), xhr.getAllResponseHeaders()

                    xhr.onload = callback()
                    xhr.onerror = callback 'error'

                    callback = xhrCallbacks[ id ] = callback 'abort'

                    xhr.send options.hasContent and options.data or null

                abort: ->
                    if callback
                        callback()

            }