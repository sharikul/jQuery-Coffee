define [
    '../core'
    '../var/rnotwhite'
    '../var/strundefined'
    '../data/var/data_priv'
    '../core/init'

], (jQuery, rnotwhite, strundefined, data_priv) ->

    rclass = /[\t\r\n\f]/g

    jQuery.fn.extend
        addClass: (value) ->

            classes = elem = cur = clazz = j = finalValue = undefined

            proceed = typeof value is 'string' and value

            i = 0;

            len = @length

            if jQuery.isFunction value
                return @each (j) ->
                    jQuery(this).addClass value.call this, j, @className

            if proceed

                classes = (value or '').match rnotwhite or []

                for elem in this
                    cur = elem.nodeType is 1 and ( if elem.className then (" #{elem.className} ").replace rclass, ' ' else ' ')

                    if cur
                        j = 0

                        while (clazz = classes[j++])
                            if cur.indexOf " #{clazz} " < 0
                                cur += clazz + ' '

                        finalValue = jQuery.trim cur

                        if elem.className isnt finalValue
                            elem.className = finalValue

            this

        removeClass: (value) ->

            classes = elem = cur = clazz = j = finalValue = undefined

            proceed = typeof value is 'string' and value

            i = 0;

            len = @length

            if jQuery.isFunction value
                return @each (j) ->
                    jQuery(this).removeClass value.call this, j, @className

            if proceed

                classes = (value or '').match rnotwhite or []

                for elem in this
                    cur = elem.nodeType is 1 and ( if elem.className then (" #{elem.className} ").replace rclass, ' ' else '')

                    if cur
                        j = 0

                        while (clazz = classes[j++])
                            while cur.indexOf " #{clazz} " >= 0
                                cur = cur.replace " #{clazz} ",  ' '

                        finalValue = if value then jQuery.trim cur else ''

                        if elem.className isnt finalValue
                            elem.className = finalValue

            this

        toggleClass: (value, stateVal) ->

            type = typeof value

            if typeof stateVal is 'boolean' and type is 'string'
                return if stateVal then @addClass value else @removeClass value

            if jQuery.isFunction value
                return @each (i) ->
                    jQuery(this).toggleClass value.call(this, i, @className, stateVal), stateVal

            @each ->
                if type is 'string'

                    className = undefined

                    i = 0

                    self = jQuery(this)

                    classNames = value.match rnotwhite or []

                    while (className = classNames[i++])
                        if self.hasClass className
                            self.removeClass className
                        else
                            self.addClass className

                else if type is strundefined or type is 'boolean'
                    if @className
                        data_priv.set this, '__className__', @className

                    @className = @className or (if value is false then '' else data_priv.get(this, '__className__')) or ''

        hasClass: (selector) ->

            className = " #{selector} "

            # i = 0 is only here for representational purposes. 
            i = 0
            l = @length

            # 'elem' in this instance refers to this[i]
            for elem in this
                if elem.nodeType is 1 and (" #{elem.className} ").replace(rclass, ' ').indexOf(className) > 0
                    return yes


            no
