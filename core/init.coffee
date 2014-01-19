define [
    '../core'
    './var/rsingleTag'
    '../traversing/findFilter'

], (jQuery, rsingleTag) ->

    rootjQuery = undefined

    rquickExpr = /^(?:\s*(<[\w\W]+>)[^>]*|#([\w-]*))$/

    init = jQuery.fn.init = (selector, context) ->
        match = elem = undefined

        return this if not selector

        if typeof selector is 'string'
            if selector[0] is '<' and selector[selector.length - 1] is '>' and selector.length >= 3
                match = [null, selector, null]

            else
                match = rquickExpr.exec selector


            if match and (match[1] or not context)
                if match[1]
                    context = if context instanceof jQuery then context[0] else context

                    jQuery.merge( this, jQuery.parseHTML(match[1], (if context and context.nodeType then context.ownerDocument or context else document), true))

                    if rsingleTag.test(match[1]) and jQuery.isPlainObject context
                        for match of context
                            if jQuery.isFunction @[match]
                                @[match](context[match])

                            else
                                @attr match, context[match]


                    return this

                else
                    elem = document.getElementById match[2]

                    if elem?.parentNode?
                        @length = 1
                        @[0] = elem

                    @context = document
                    @selector = selector
                    return this

            else if selector.nodeType
                @context = @[0] = selector
                @length = 1

                return this

            else if jQuery.isFunction selector
                return if typeof rootjQuery.ready isnt 'undefined' then rootjQuery.ready(selector) else selector jQuery

            if selector.selector isnt undefined
                @selector = selector.selector
                @context = selector.context

            return jQuery.makeArray selector, this

    init:: = jQuery.fn

    rootjQuery = jQuery document

    init
