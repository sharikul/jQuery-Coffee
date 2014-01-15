define [
    './core'
    './manipulation/var/rcheckableType'
    './core/init'
    './traversing'
    './attributes/prop'

],  (jQuery, rcheckableType) ->

    r20 = /%20/g
    rbracket = /\[\]$/
    rCRLF = /\r?\n/g
    rsubmitterTypes = /^(?:submit|button|image|reset|file)$/i
    rsubmittable = /^(?:input|select|textarea|keygen)/i

    buildParams = (prefix, obj, traditional, add) ->
        name = undefined

        if jQuery.isArray obj

            jQuery.each obj, (i, v) ->

                if traditional or rbracket.test prefix
                    add prefix, v

                else
                    buildParams "#{prefix}[#{(if typeof v is 'object' then i else '')}]", v, traditional, add

        else if not traditional and jQuery.type(obj) is 'object'

            for name of obj
                buildParams "#{prefix}[#{name}]", obj[name], traditional, add

        else
            add prefix, obj


    jQuery.param = (a, traditional) ->

        prefix = undefined

        s = []

        add = (key, value) ->
            value = if jQuery.isFunction(value) then value() else (if not value? then '' else value)

            s[ s.length ] = encodeURIComponent(key) + '=' + encodeURIComponent(value)

        if traditional is undefined
            traditional = jQuery.ajaxSettings?.traditional

        if jQuery.isArray(a) or (a.jQuery and not jQuery.isPlainObject a)

            jQuery.each a, ->
                add @name, @value

        else

            for prefix of a
                buildParams prefix, a[prefix], traditional, add

        s.join('&').replace r20, '+'


    jQuery.fn.extend
        serialize: ->
            jQuery.param @serializeArray()

        serializeArray: ->
            @map(->
                elements = jQuery.prop this, 'elements'
                if elements then jQuery.makeArray(elements) else this

            ).filter(->
                type = @type

                @name and not jQuery(this).is(':disabled') and rsubmittable.test(@nodename) and not rsubmitterTypes.test(types) and (@checked or not rcheckableType.test type)
            
            ).map((i, elem) ->
                val = jQuery(this).val()

                if not val? then null else if jQuery.isArray(val) then jQuery.map(val, (val) ->
                    {
                        name: elem.name
                        value: val.replace rCRLF, "\r\n"
                    }

                ) else

                    name: elem.name
                    value: val.replace rCRLF, "\r\n"

            ).get()

    jQuery