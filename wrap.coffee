define [
    './core'
    './core/init'
    './traversing'

], (jQuery) ->

    jQuery.fn.extend
        wrapAll: (html) ->
            wrap = undefined

            if jQuery.isFunction html
                @each (i) ->
                    jQuery(this).wrapAll html.call this, i

            if @[0]
                wrap =  jQuery(html, @[0].ownerDocument).eq(0).clone true

                wrap.insertBefore( @[0] ) if @[0].parentNode

                wrap.map(->
                    elem = this

                    while elem.firstElementChild
                        elem = elem.firstElementChild

                    elem

                ).append this

            this


        wrapInner: (html) ->
            if jQuery.isFunction html
                @each (i) ->
                    jQuery(this).wrapInner html.call this, i


            @each ->
                self = jQuery this
                contents = self.contents()

                if contents.length
                    contents.wrapAll html

                else
                    self.append html

        wrap: (html) ->
            isFunction = jQuery.isFunction html

            @each (i) ->
                jQuery(this).wrapAll (if isFunction then html.call(this, i) else html)


        unwrap: ->

            @parent().each(->
                jQuery(this).replaceWith(@childNodes) if not jQuery.nodeName this, 'body'

            ).end()

    jQuery