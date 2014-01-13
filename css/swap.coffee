define [
    '../core'

], (jQuery) ->

    jQuery.swap = (elem, options, callback, args) ->
        ret = name = undefined

        old = {}

        for name of options
            old[name] = elem.style[name]

            elem.style[name] = options[name]

        ret = callback.apply elem, args or []

        for name of options
            elem.style[name] = old[name]

        ret

    jQuery.swap