define [
    '../core'

], (jQuery) ->

    access = jQuery.access = (elems, fn, key, value, chainable, emptyGet, raw) ->

        i = 0
        len = elems.length
        bulk = key is null

        if jQuery.type(key) is 'object'

            chainable = true

            for i of key
                jQuery.access elems, fn, i, key[i], true, emptyGet, raw

        else if value isnt undefined
            chainable = true

            if not jQuery.isFunction value
                raw = true

            if bulk
                if raw
                    fn.call elems, value
                    fn = null

                else
                    bulk = fn

                    fn = (elem, key, value) ->
                        bulk.call jQuery(elem), value

            if fn
                for i of elems
                    fn elems[i], key, (if raw then value else value.call(elems[i], i, fn(elems[i], key)))

            return if chainable then elems else if bulk then fn.call(elems) else if len then fn(elems[0], key) else emptyGet
            
    access
