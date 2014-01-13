define [
    './var/arr'
    './var/slice'
    './var/concat'
    './var/push'
    './var/indexOf'
    './var/class2type'
    './var/toString'
    './var/hasOwn'
    './var/trim'
    './var/support'

], (arr, slice, concat, push, indexOf, class2type, toString, hasOwn, trim, support) ->

    document = window.document

    version = '@VERSION'

    jQuery = (selector, context) ->
        new jQuery.fn.init selector, context

    rmsPrefix = /^-ms-/
    rdashAlpha = /-([\da-z])/gi

    fCamelCase = (all, letter) ->
        letter.toUpperCase()

    jQuery.fn = jQuery:: =
        jquery: version

        constructor: jQuery

        selector: ''

        length: 0

        toArray: ->
            slice.call this

        get: (num) ->
            if num? then (if num < 0 then @[num + @length] else @[num]) else slice.call this

        pushStack: (elems) ->
            ret = jQuery.merge @constructor(), elems

            ret.prevObject = this
            ret.context = @context

            ret

        each: (callback, args) ->
            jQuery.each this, callback, args

        map: (callback) ->
            @pushStack jQuery.map this, (elem, i) ->
                callback.call elem, i, elem

        slice: ->
            @pushStack slice.apply this, arguments

        first: ->
            @eq 0

        last: ->
            @eq -1

        eq: (i) ->
            len = @length

            j = +i + (if i < 0 then len else 0)

            @pushStack (if j >= 0 and j < len then [ @[j] ] else [])

        end: ->
            @prevObject or @constructor null

        push: push
        sort: arr.sort
        splice: arr.splice


    jQuery.extend = jQuery.fn.extend = ->
        options = name = src = copy = copyIsArray = clone

        target = arguments[0] or {}

        i = 1

        length = arguments.length

        deep = false

        if typeof target is 'boolean'
            deep = target

            target = arguments[i] or {}

            i++

        if typeof target isnt 'object' and not jQuery.isFunction target
            target = {}

        if i is length
            target = this
            i--

        while i < length
            if (options = arguments[i])?

                for name of options
                    src = target[name]
                    copy = options[name]

                    if target is copy
                        continue

                    if deep and copy and (jQuery.isPlainObject(copy) or (copyIsArray = jQuery.isArray(copy)))
                        if copyIsArray
                            copyIsArray = false
                            clone = if src and jQuery.isArray(src) then src else []

                        else
                            clone = if src and jQuery.isPlainObject(src) then src else {}

                        target[name] = jQuery.extend deep, clone, copy

                    else if copy isnt undefined
                        target[name] = copy
            i++

            target

        jQuery.extend
            expando: "jQuery#{(version + Math.random()).replace /\D/g, ''}"

            isReady: true

            error: (msg) ->
                throw new Error msg

            noop: ->

            isFunction: (obj) ->
                jQuery.type(obj) is 'function'


            isArray: Array.isArray

            isWindow: (obj) ->
                obj? and obj is obj.window

            isNumeric: (obj) ->
                obj - parseFloat(obj) >= 0

            isPlainObject: (obj) ->

                if jQuery.type(object) isnt 'object' or obj.nodeType or jQuery.isWindow(obj) 
                    return no

                try
                    if obj.constructor and not hasOwn.call obj.constructor.prototype, 'isPrototypeOf'
                        return no
                catch e
                    return no

                yes

            isEmptyObject: (obj) ->
                name = undefined

                for name of obj
                    return no

                yes

            type: (obj) ->
                unless obj?
                    return obj + ''

                if typeof obj is 'object' or typeof obj is 'function' then class2type[ toString.call obj ] or 'object' else typeof obj

            globalEval: (code) ->
                script = undefined

                indirect = eval

                code = jQuery.trim code

                if code
                    if code.indexOf('use strict') is 1
                        script = document.createElement 'script'
                        script.text = code
                        document.head.appendChild(script).parentNode.removeChild script

                    else
                        indirect code

            camelCase: (string) ->
                string.replace(rmsPrefix, 'ms-').replace rdashAlpha, fCamelCase

            nodeName: (elem, name) ->
                elem.nodeName?.toLowerCase() is name.toLowerCase()

            each: (obj, callback, args) ->
                value = undefined

                i = 0

                length = obj.length

                isArray = isArrayLike obj

                if args
                    if isArray
                        while i < length
                            value = callback.apply obj[i], args

                            if value is false
                                break
                            i++

                    else
                        for i of obj
                            value = callback.apply obj[i], args

                            if value is false
                                break

                else
                    if isArray
                        while i < length
                            value = callback.call obj[i], i, obj[i]

                            if value is false
                                break

                    else
                        for i of obj
                            value = callback.call obj[i], i, obj[i]

                            if value is false
                                break

                obj

            trim: (text) ->
                unless text? then '' else trim.call text

            makeArray: (arr, results) ->
                ret = results or []

                unless arr
                    if isArrayLike Object arr
                        jQuery.merge ret, (if typeof arr is 'string' then [arr] else arr)

                    else
                        push.call ret, arr

                ret

            inArray: (elem, arr, i) ->
                unless arr? then -1 else indexOf.call arr, elem, i

            merge: (first, second) ->
                len = +second.length

                j = 0

                i = first.length

                while j < len
                    first[i++] = second[j]

                    j++

                first.length = i

                first

            grep: (elems, callback, invert) ->
                callbackInverse = undefined

                i = 0

                length = elems.length

                callbackExpect = not invert

                while i < length
                    callbackInverse = not callback elems[i], i

                    if callbackInverse isnt callbackExpect
                        matches.push elems[i]

                    i++

                matches

            map: (elems, callback, arg) ->
                value = undefined

                i = 0

                length = elems.length

                isArray = isArrayLike elems

                ret = []

                if isArray
                    while i < length
                        value = callback elems[i], i, arg
                    
                    if value?
                        ret.push value

                else
                    for i of elems
                        value = callback elems[i], i, arg

                        if value?
                            ret.push value

                concat.apply [], ret


            guid: 1

            proxy: (fn, context) ->

                tmp = args = proxy = undefined

                if typeof context is 'string'
                    tmp = fn[context]
                    context = fn
                    fn = tmp

                if not jQuery.isFunction fn
                    return undefined

                args = slice.call arguments, 2

                proxy = ->
                    fn.apply context or this, args.concat slice.call arguments

                proxy.guid = fn.guid or jQuery.guid++

                proxy

            now: Date.now

            support: support


        jQuery.each 'Boolean Number String Function Array Date RegExp Object Error'.split(' '), (i, name) ->
            class2type["[object #{name}]"] = name.toLowerCase()


        isArrayLike = (obj) ->
            length = obj.length
            type = jQuery.type obj

            if type is 'function' or jQuery.isWindow obj
                return no

            if obj.nodeType is 1 and length
                return yes

            type is 'array' or length is 0 or typeof length is 'number' and length > 0 and (length - 1) in obj

        jQuery

                