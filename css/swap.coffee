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
        
        elem.style[name] = old[name] for name of options

        ret

    jQuery.swap
