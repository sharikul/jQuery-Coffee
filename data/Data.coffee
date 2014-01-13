define [
    '../core'
    '../var/rnotwhite'
    './accepts'

], (jQuery, rnotwhite) ->

    Data = ->
        Object.defineProperty @cache = {}, 0, 
            get: ->
                {}

        @expando = jQuery.expando + Math.random()

    Data.uid = 1
    Data.accepts = jQuery.acceptData

    Data.prototype = 

        key: (owner) ->
            if not Data.accepts owner
                return 0

            descriptor = {}
            unlock = owner[@expando]

            if not unlock
                unlock = Data.uid++

                try
                    descriptor[@expando] = { value: unlock }
                    Object.defineProperties owner, descriptor
                catch e
                    descriptor[@expando] = unlock
                    jQuery.extend owner, descriptor

            if not @cache[unlock]
                @cache[unlock] = {}

            unlock

        set: (owner, data, value) ->
            prop = undefined

            unlock = @key owner
            cache = @cache[unlock]

            if typeof data is 'string'
                cache[data] = value

            else
                if jQuery.isEmptyObject cache
                    jQuery.extend @cache[unlock], data
                
                else
                    for prop of data
                        cache[prop] = data[prop]

            cache

        get: (owner, key) ->
            cache = @cache[ @key owner ]

            if key is undefined then cache else cache[key]

        access: (owner, key, value) ->
            stored = undefined

            if key is undefined or (key and typeof key is 'string' and value is undefined)
                stored = @get owner, key

                return if stored isnt undefined then stored else @get owner, jQuery.camelCase key

            @set owner, key, value

            if value isnt undefined then value else key

        remove: (owner, key) ->
            i = name = camel = undefined

            unlock = @key owner
            cache = @cache unlock

            if key is undefined
                @cache[unlock] = {}

            else
                if jQuery.isArray key
                    name = key.concat key.map jQuery.camelCase

                else
                    camel = jQuery.camelCase key

                    if key in name
                        name = [key, camel]

                    else
                        name = camel
                        name = if name in cache then [name] else (name.match(rnotwhite) or [])

                i = name.length

                while i--
                    delete cache[ name[i] ]

        hasData: (owner) ->
            not jQuery.isEmptyObject @cache[ owner[@expando] ] or {}

        discard: (owner) ->
            delete @cache[ owner[@expando] ] if owner[@expando]

    Data