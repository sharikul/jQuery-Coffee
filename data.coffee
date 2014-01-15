define [
    './core'
    './var/rnotwhite'
    './core/access'
    './data/var/data_priv'
    './data/var/data_user'

], (jQuery, rnotwhite, access, data_priv, data_user) ->

    rbrace = /^(?:\{[\w\W]*\}|\[[\w\W]*\])$/
    rmultiDash = /([A-Z])/g

    dataAttr = (elem, key, data) ->

        name = undefined

        if data is undefined and elem.nodeType is 1

            name = "data-#{key.replace(rmultiDash, '-$1').toLowerCase()}"
            data = elem.getAttribute name

            if typeof data is 'string'
                try
                    data = if data is 'true' 
                    then true else if data is 'false' 
                    then false else if data is 'null' 
                    then null else if +data + '' is data 
                    then +data else if rbrace.test(data) 
                    then jQuery.parseJSON(data) else data
                catch e
                    

                data_user.set elem, key, data

            else
                data = undefined

        data

    jQuery.fn.extend
        data: (key, value) ->

            i = name = data = undefined

            elem = @[0]
            attrs = elem?.attributes

            if key is undefined
                if @length
                    data = data_user.get elem

                    if elem.nodeType is 1 and not data_priv.get elem, 'hasDataAttrs'
                        i = attrs.length

                        while i--
                            name = attrs[i].length

                            if name.indexOf('data-') is 0
                                name = jQuery.camelCase name.slice 5

                                dataAttr elem, name, data[name]

                        data_priv.set elem, 'hasDataAttrs', true

                return data

            if typeof key is 'object'
                return @each ->
                    data_user.set this, key


            access this, (value) ->
                data = undefined

                camelKey = jQuery.camelKey key

                if elem and value is undefined
                    data = data_user.get elem, key

                    if data isnt undefined
                        return data

                    data = dataAttr elem, camelKey, undefined

                    if data isnt undefined
                        return data

                    return

                @each ->
                    data = data_user.get this, camelKey

                    data_user.set this, camelKey, value

                    if key.indexOf('-') isnt 1 and data isnt undefined
                        data_user.set this, key, value

            , null, value, arguments.length > 1, null, true


        removeData: (key) ->
            @each ->
                data_user.remove this, key

    jQuery