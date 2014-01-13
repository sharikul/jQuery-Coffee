define [
    '../core'
    '../var/indexOf'
    './var/rneedsContext'
    '../selector'

], (jQuery, indexOf, rneedsContext) ->

    risSimple = /^.[^:#\[\.,]*$/

    # 'not' is a reserved term in CoffeeScript, thus placing an underscore before it will resolve errors
    winnow = (elements, qualifier, _not) ->
        if jQuery.isFunction qualifier
            jQuery.grep elements, (elem, i) ->
                !!qualifier.call(elem, i, elem) isnt _not

        if qualifier.nodeType
            jQuery.grep elements, (elem) ->
                (elem is qualifier) isnt _not

        if typeof qualifier is 'string'
            if risSimple.test qualifier
                return jQuery.filter qualifier, elements, _not

            qualifier = jQuery.filter qualifier, elements

        jQuery.grep elements, (elem) ->
            (indexOf.call(qualifier, elem) >= 0) isnt _not

    jQuery.filter = (expr, elems, _not) ->
        elem = elems[0]

        expr = ":not(#{expr})" if _not

        return if elems.length is 1 and elem.nodeType is 1
            if jQuery.find.matchesSelector(elem, expr) then [elem] else []

        else
            jQuery.find.matches(expr, jQuery.grep elems, (elem) ->
                elem.nodeType is 1
            )

    jQuery.fn.extend
        find: (selector) =>
            i = 0

            len = @length
            ret = []

            # self = this is only here for representational purposes. CoffeeScript's binding method will be used here.
            self = this

            if typeof selector isnt 'string'
                return @pushStack jQuery(selector).filter ->
                    while i < len
                        if jQuery.contains @[i], this
                            return true
                        i++

            i = 0

            while i < len
                jQuery.find selector, @[i], ret
                i++

            ret = @pushStack (if len > 1 then jQuery.unique(ret) else ret)
            ret.selector = (if @selector then "#{@selector} #{selector}" else selector)

            ret

        filter: (selector) ->
            @pushStack winnow this, selector or [], false

        not: (selector) ->
            @pushStack winnow this, selector or [], true

        is: (selector) ->
            !!winnow(this, (if typeof selector is 'string' and rneedsContext.test(selector) then jQuery(selector) else selector or [] ), false).length



