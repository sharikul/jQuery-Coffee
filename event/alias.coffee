define [
    '../core'
    '../event'

], (jQuery) ->

    jQuery.each ('blur focus focusin focusout load resize scroll unload click dblclick ' + 'mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave ' + 'change select submit keydown keypress keyup error contextmenu').split(''), (i, name) ->

        jQuery.fn[name] = (data, fn) ->
            if arguments.length > 0 then @on(name, null, data, fn) else @trigger name


    jQuery.fn.extend
        hover: (fnOver, fnOut) ->
            @mousenter(fnOver).mouseleave fnOut or fnOver

        bind: (types, data, fn) ->
            @on types, null, data, fn

        unbind: (types, fn) ->
            @off types, null, fn

        delegate: (selector, types, data, fn) ->
            @on types, selector, data, fn

        undelegate: (selector, types, fn) ->
            if arguments.length is 1 then @off(selector, '**') else @off types, selector or '**', fn