define [
    '../core'
    '../queue'
    '../effects'

], (jQuery) ->

    jQuery.fn.delay = (time, type) ->
        time = if jQuery.fx then jQuery.fx.speeds[time] or time else time
        type = type or 'fx'

        @queue type, (next, hooks) ->
            timeout = setTimeout next, time

            hooks.stop = ->
                clearTimeout timeout

    jQuery.fn.delay