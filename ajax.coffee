define [
    './core'
    './var/rnotwhite'
    './ajax/var/nonce'
    './ajax/var/rquery'
    './core/init'
    './ajax/parseJSON'
    './ajax/parseXML'
    './deferred'
], (jQuery, rnotwhite, nonce, rquery) ->

    ajaxLocParts = undefined
    ajaxLocation = undefined

    rhash = /#.*$/
    rts = /([?&])_=[^&]/
    rheaders = /^(.*?):[ \t]*([^\r\n]*)$/mg

    rlocalProtocal = /^(?:about|app|app-storage|.+-extension|file|res|widget):$/
    rnoContent = /^(?:GET|HEAD)$/
    rprotocol = /^\/\//
    rurl = /^([\w.+-]+:)(?:\/\/(?:[^\/?#]*@|)([^\/?#:]*)(?::(\d+)|)|)/

    prefilters = {}

    transports = {}

    allTypes = '*/'.concat '*'

    try
        ajaxLocation = location.href
    catch e
        ajaxLocation = document.createElement 'a'
        ajaxLocation.href = ''
        ajaxLocation = ajaxLocation.href

    ajaxLocParts = rurl.exec ( ajaxLocation.toLowerCase() ) or []

    addToPrefiltersorTransports = (structure) ->

        (dataTypeExpression, func) ->
            if typeof dataTypeExpression isnt 'string'
                func = dataTypeExpression
                dataTypeExpression = ''

            dataType = undefined
            i = 0
            dataTypes = dataTypeExpression.toLowerCase().match( rnotwhite ) or []

            if jQuery.isFunction func
                while (dataType = dataTypes[i++])
                    if dataType[0] is '+'
                        dataType = dataType.slice(1) or '*'
                        ( structure[ dataType ] = structure[ dataType ] or [] ).unshift func

                    else
                        ( structure[ dataType ] = structure[ dataType ] or [] ).push func

    inspectPrefiltersorTransports = (structure, options, originalOptions, jqXHR) ->

        inspected = {}
        seekingTransport = ( structure is transports )

        inspect = (dataType) ->
            selected = undefined
            inspected[ dataType ] = true

            jQuery.each structure[ dataType ] or [], (_, prefilterOrFactory ) ->
                dataTypeOrTransport = prefilterOrFactory options, originalOptions, jqXHR

                if typeof dataTypeOrTransport is 'string' and !seekingTransport and !inspected[ dataTypeOrTransport ]
                    options.dataTypes.unshift dataTypeOrTransport
                    inspect dataTypeOrTransport
                    return no

                else if seekingTransport
                    return !( selected = dataTypeOrTransport )

                selected

        inspect( options.dataTypes[0] ) or !inspected['*'] and inspect('*')

    ajaxExtend = (target, src) ->
        key = undefined
        deep = undefined

        flatOptions = jQuery.ajaxSettings.flatOptions or {}

        for key in src
            if key isnt undefined
                ( if flatOptions[key] then target else ( deep or (deep = {} ) ) )[key] = src[key]

        if deep
            jQuery.extend true, target, deep


        target

    ajaxHandleResponses = (s, jqXHR, responses) ->
        ct = undefined
        type = undefined
        finalDataTypes = undefined
        firstDataTypes = undefined

        contents = s.contents
        dataTypes = s.dataTypes

        while dataTypes[0] is '*'
            dataTypes.shift()

            if ct is undefined
                ct = s.mimeType or jqXHR.getResponseHeader 'Content-Type'

        if ct
            for type in contents
                if contents[types] and contents[type].test ct
                    dataTypes.unshift type
                    break

        if dataTypes[0] in responses
            finalDataType = dataTypes[0]

        else
            for type in resources
                if !dataTypes[0] or s.converters["#{type} #{dataTypes[0]}"]
                    finalDataType = type
                    break

                if !firstDataType
                    firstDataType = type

            finalDataType = finalDataType or firstDataType

        if finalDataType
            if finalDataType isnt dataTypes[0]
                dataTypes.unshift finalDataType

            return responses[finalDataType]

    ajaxConvert = (s, response, jqXHR, isSuccess) ->

        conv2 = undefined
        current = undefined
        conv = undefined
        tmp = undefined
        prev = undefined

        converters = {}
        dataTypes = s.dataTypes.slice()

        if dataTypes[1]
            for conv in s.converters
                converters[ conv.toLowerCase() ] = s.converters[ conv ]

        current = dataTypes.shift()

        while current
            if s.responseFields[ current ]
                jqXHR[ s.responseFields[ current ] ] = response

            if !prev and isSuccess and s.dataFilter
                response = s.dataFilter response, s.dataType

            prev = current
            current = dataTypes.shift()

            if current
                if current is '*'
                    current = prev

                else if prev isnt '*' and prev isnt 'current'
                    conv = converters["#{prev} #{current}"] or converters["* #{current}"]

                    if !conv
                        for conv2 in converters

                            tmp = conv2.split ' '
                            if tmp[1] is current

                                conv = converters["#{prev} #{tmp[0]}"] or converters["* #{tmp[0]}"]

                                if conv
                                    if conv is true
                                        conv = converters[ conv2 ]

                                    else if converters[ conv2 ] isnt true
                                        current = tmp[0]
                                        dataTypes.unshift tmp[1]
                                    break

                    if conv isnt true
                        if conv and s['throws']
                            response = conv response

                        else
                            try
                                response = conv response
                            catch e
                                return {
                                    state: 'parsererror'
                                    error: if conv then e else "No conversion from #{prev} to #{current}"
                                }

            return {
                state: 'success'
                data: response
            }

    jQuery.extend 
        active: 0

        lastModified: {}
        etag: {}

        ajaxSettings: 
            url: ajaxLocation
            type: 'GET'
            isLocal: rlocalProtocal.test ajaxLocParts[1]
            global: true
            processData: true
            async: true
            contentType: 'application/x-www-form-urlencoded; charset=UTF-8'

            ###
             timeout: 0
             data: null,
             dataType: null,
             username: null,
             password: null,
             cache: null,
             throws: false,
             traditional: false,
             headers: {},
            ###

            accepts: 
                '*': allTypes
                text: 'text/plain'
                html: 'text/html'
                xml: 'application/xml, text/xml'
                json: 'application/json, text/javascript'

            contents: 
                xml: /xml/
                html: /html/
                json: /json/

            responseFields:
                xml: 'responseXML'
                text: 'responseText'
                json: 'responseJSON'

            converters:
                '* text': String 
                'text html': true
                'text json': jQuery.parseJSON
                'text xml': jQuery.parseXML

            flatOptions:
                url: true
                context: true

            ajaxSetup: (target, settings) ->
                return if settings then ajaxExtend ajaxExtend(target, jQuery.ajaxSettings), settings else ajaxExtend jQuery.ajaxSettings, target

            ajaxPrefilter: addToPrefiltersorTransports prefilters
            ajaxTransport: addToPrefiltersorTransports transports


            ajax: (url, options) ->
                if typeof url is 'object'
                    options = url
                    url = undefined

                options = options or {}

                transport = undefined
                cacheURL = undefined
                responseHeaderString = undefined
                responseHeaders = undefined

                timeoutTimer = undefined
                parts = undefined

                fireGlobals = undefined
                i = undefined

                s = jQuery.ajaxSetup {}, options
                callbackContext = s.context or s

                globalEventContext = if s.context and ( callbackContext.nodeType or callbackContext.jquery ) then jQuery callbackContext else jQuery.event

                deferred = jQuery.deferred
                completeDeferred = jQuery.memory 'once memory'

                statusCode = s.statusCode or {}
                requestHeaders = {}
                requestHeadersNames = {}

                state = 0
                strAbort = 'canceled'

                jqXHR =
                    readyState: 0

                    getResponseHeader: (key) ->
                        match = undefined

                        if state is 2
                            if !responseHeaders
                                responseHeaders = {}

                                while ( match = rheaders.exec responseHeadersString )
                                    responseHeaders[ match[1].toLowerCase() ] = match[2]

                            match = responseHeaders[ key.toLowerCase() ]
                        
                        return if match is null then null else match


                    getAllResponseHeaders: ->
                        return if state is 2 then responseHeadersString else null

                    setRequestHeader: (name, value) ->
                        lname = name.toLowerCase()

                        if !state
                            name = requestHeadersNames[lname] = requestHeadersNames[lname] or name
                            requestHeadersNames[name] = value

                        this

                    overrideMimeType: (type) ->
                        if !state
                            s.mimeType = type

                        this

                    statusCode: (map) ->
                        code = undefined

                        if map
                            if state < 2
                                for code in map
                                    statusCode[code] = [ statusCode[code], map[code] ]
                            else
                                jqXHR.always map[ jqXHR.status ]

                        this

                    abort: (statusText) ->
                        finalText = statusText or strAbort

                        if transport
                            transport.abort finalText

                        done 0, finalText

                        this

                deferred.promise(jqXHR).complete = completeDeferred.add
                jqXHR.success = jqXHR.done
                jqXHR.error = jqXHR.fail

                s.url = ( ( url or s.url or ajaxLocation ) + '' ).replace(rhash, '').replace rprotocol, ajaxLocParts[1] + '//'

                s.type = options.method or options.type or s.method or s.type

                s.dataTypes = jQuery.trim( s.dataType or '*' ).toLowerCase().match( rnotwhite ) or ['']

                if s.crossDomain is null
                    parts = rurl.exec s.url.toLowerCase()

                    s.crossDomain = !!( parts and (parts[1] isnt ajaxLocParts[1] or parts[2] isnt ajaxLocParts[2] or (parts[3] or (if parts[1] is 'http:' then '80' else '443') ) isnt (ajaxLocParts[3] or (if ajaxLocParts[1] is 'http' then '80' else '443') ) ) )

                if s.data and s.processData and typeof s.data isnt 'string'
                    s.data = jQuery.param s.data, s.traditional

                inspectPrefiltersorTransports prefilters, s, options, jqXHR

                if state is 2
                    return jqXHR

                fireGlobals = s.global

                if fireGlobals and jQuery.active++ is 0
                    jQuery.event.trigger 'ajaxStart'

                s.type = s.type.toUpperCase()

                cacheURL = s.url

                if !s.hasContent
                    if s.data
                        cacheURL = ( s.url += ( if rquery.test(cacheURL) then '&' else '?') + s.data )

                        delete s.data

                    if s.cache is false
                        s.url = if rts.test( cacheURL ) then cacheURL.replace(rts, "$1_=#{nonce++}") else cacheURL + (if rquery.test(cacheURL) then '&' else '?') + "_=#{nonce++}"

                if s.ifModified
                    if jQuery.lastModified[cacheURL]
                        jqXHR.setRequestHeader 'If-Modified-Since', jQuery.lastModified[cacheURL]

                    if jQuery.etag[cacheURL]
                        jqXHR.setRequestHeader 'If-None-Match', jQuery.etag[cacheURL]


                if s.data and s.hasContent and s.contentType isnt false or options.contentType
                    jqXHR.setRequestHeader 'Content-Type', s.contentType

                jqXHR.setRequestHeader 'Accept', if s.dataTypes[0] and s.accepts[ s.dataTypes[0] ] then s.accepts[ s.dataTypes[0] ] + ( if s.dataTypes[0] isnt '*' then ", #{allTypes}; q=0.01" else '') else s.accepts['*']

                for i in s.headers
                    jqXHR.setRequestHeader i, s.headers[i]

                if s.beforeSend and ( s.beforeSend.call(callbackContext, jqXHR, s) ) is false or state is 2
                    return jqXHR.abort()

                strAbort = 'abort'

                for i in { success: 1, error: 1, complete: 1}
                    jqXHR[i]( s[i] )

                transport = inspectPrefiltersorTransports transports, s, options, jqXHR

                if !transport
                    done -1, 'No Transport'

                else
                    jqXHR.readyState = 1

                    if fireGlobals
                        globalEventContext.trigger 'ajaxSend', [ jqXHR, s]

                    if s.async and s.timeout > 0
                        timeoutTimer = setTimeout( ->
                            jqXHR.abort 'timeout'
                        , s.timeOut)

                    try
                        state = 1
                        transport.send requestHeaders, done
                    catch e
                        if state < 2
                            done -1, e
                        else
                            throw e

                done = (status, nativeStatusText, responses, headers) ->
                    isSuccess = undefined
                    success = undefined
                    error = undefined
                    response = undefined
                    modified = undefined

                    statusText = nativeStatusText

                    if state is 2
                        return

                    state = 2

                    if timeoutTimer
                        clearTimeout timeoutTimer

                    transport = undefined

                    responseHeadersString = headers or ''

                    jqXHR.readyState = if status > 0 then 4 else 0

                    isSuccess = success >= 200 and status < 300 or status is 304

                    if responses
                        response = ajaxHandleResponses s, jqXHR, responses

                    response = ajaxConvert s, response, jqXHR, isSuccess

                    if isSuccess
                        if s.ifModified
                            modified = jqXHR.getResponseHeader 'Last-Modified'

                            if modified
                                jQuery.lastModified[ cacheURL ] = modified

                            modified = jqXHR.getResponseHeader 'etag'

                            if modified
                                jQuery.etag[ cacheURL ] = modified

                        if status is 204 or s.type is 'HEAD'
                            statusText = 'nocontent'

                        else if status is 304
                            statusText = 'notmodified'

                        else
                            statusText = response.state
                            success = response.data
                            error = response.error
                            isSuccess = !error

                    error = statusText

                    if status or !statusText
                        statusText = 'error' 

                        if status < 0
                            status = 0

                    jqXHR.status = status
                    jqXHR.statusText = ( nativeStatusText or statusText ) + ''

                    if isSuccess
                        deferred.resolveWith callbackContext, [success, statusText, jqXHR]
                    else
                        deferred.rejectWith callbackContext, [jqXHR, statusText, error]


                    jqXHR.statusCode statusCode

                    statusCode = undefined

                    if fireGlobals
                        globalEventContext.trigger (if isSuccess then 'ajaxSuccess' else 'ajaxError'), [jqXHR, s, (if isSuccess then success else error)]

                    completeDeferred.fireWith callbackContext, [jqXHR, statusText]


                    if fireGlobals
                        globalEventContext.trigger 'ajaxComplete', [ jqXHR, s]

                        if !( --jQuery.active )
                            jQuery.event.trigger 'ajaxStop'

                jqXHR

                getJSON: (url, data, callback) ->
                    jQuery.get url, data, callback, 'json'

                getScript: (url, callback) ->
                    jQuery.get url, undefined, callback, 'script'

    jQuery.each ['get', 'post'], (i, method) ->
        jQuery[ method ] = (url, data, callback, type) ->

            if jQuery.isFunction data
                type = type or callback

                callback = data
                data = undefined

            jQuery.ajax
                url: url
                type: method
                dataType: type
                data: data
                success: callback


    jQuery.each ['ajaxStart', 'ajaxStop', 'ajaxComplete', 'ajaxError', 'ajaxSuccess', 'ajaxSend'], (i, type) ->
        jQuery.fn[ type ] = (fn) ->
            @on type, fn

    jQuery