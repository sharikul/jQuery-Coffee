define [
    '../core'
    '../core/parseHTML'
    '../ajax'
    '../traversing'
    '../manipulation'
    '../selector'
    '../event/alias'

], (jQuery) ->

    _load = jQuery.fn.load

    jQuery.fn.load = (url, params, callback) ->

        if typeof url isnt 'string' and _load
            _load.apply this, arguments

        selector = type = response = undefined

        # self = this is only being written here as it's written like this in the jQuery source. CoffeeScript's @ notation will be used to denote 'this' elsewhere in this script
        self = this

        # off is a reserved term in CoffeeScript which compiles into 'false', which will lead to errors, thus placing an underscore before it solves errors.
        _off = url.indexOf ' '

        if _off >= 0
            selector = url.slice off
            url = url.slice 0, off

        if jQuery.isFunction params
            callback = params
            params = undefined

        else if params and typeof params is 'object'
            type = 'POST'

        if @length > 0
            jQuery.ajax(

                url: url
                type: type
                dataType: 'html'
                data: params

            ).done((responseText) ->

                response = arguments

                @html(if selector then jQuery('<div>').append(jQuery.parseHTML responseText).find selector else responseText)

            ).complete( callback and (jqXHR, status) ->
                @each callback, response or [ jqXHR.responseText, status, jqXHR ]
            )

        this
    

