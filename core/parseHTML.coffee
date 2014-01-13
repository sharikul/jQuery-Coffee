define [
    '../core'
    './var/rsingleTag'
    '../manipulation'

], (jQuery, rsingleTag) ->

    jQuery.parseHTML = (data, context, keepScripts) ->

        if not data or typeof data isnt 'string'
            return null

        if typeof context is 'boolean'
            keepScripts = context
            context = false

        context = context or document

        parsed = rsingleTag.exec data
        scripts = !keepScripts and []

        if parsed
            return [context.createElement parsed[1] ]

        parsed = jQuery.buildFragment [data], context, scripts

        if scripts and scripts.length
            jQuery(scripts).remove()

        jQuery.merge [], parsed.childNodes

    jQuery.parseHTML