define [
    '../core'
    '../core/init'
    '../deferred'

], (jQuery) ->

    readyList = undefined

    jQuery.fn.ready = (fn) ->
        jQuery.ready.promise().done fn

        this

    jQuery.extend
        isReady: false

        readyWait: 1

        holdReady: (hold) ->
            if hold
                jQuery.readyWait++
            else
                jQuery.ready true

        ready: (wait) ->
            if ( if wait is true then --jQuery.readyWait else jQuery.isReady )
                return

            jQuery.isReady = true

            if wait isnt true and --jQuery.readyWait > 0
                return

            readyList.resolveWith document, [jQuery]

            if jQuery.fn.trigger
                jQuery(document).trigger('ready').off('ready')

    completed = ->
        document.removeEventListener 'DOMContentLoaded', completed, false
        window.removeEventListener 'load', completed, false

        jQuery.ready()

    jQuery.ready.promise = (obj) ->
        if !readyList
            readyList = jQuery.Deferred()

            if document.readyState is 'complete'
                setTimeout jQuery.ready

            else
                document.addEventListener 'DOMContentLoaded', completed, false

                window.addEventListener 'load', completed, false

        readyList.promise obj

    jQuery.ready.promise()