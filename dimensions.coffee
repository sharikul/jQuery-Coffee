define [
    './core'
    './core/access'
    './css'

], (jQuery, access) ->

    jQuery.each
        Height: 'height'
        Width: 'width'

    , (name, type) ->

        jQuery.each
            padding: "inner#{name}"
            content: type
            '': "outer#{name}"

        , (defaultExtra, funcName) ->

            jQuery.fn[funcName] = (margin, value) ->

                chainable = arguments.length and ( defaultExtra or typeof margin isnt 'boolean' )
                extra = defaultExtra or ( if margin is true or value is true then 'margin' else 'border' )


                access this, (elem, type, value) ->

                    doc = undefined

                    if jQuery.isWindow elem
                        return elem.document.documentElement["client#{name}"]

                    if elem.nodeType is 9
                        doc = elem.documentElement

                        return Math.max(
                            elem.body["scroll#{name}"], doc["scroll#{name}"]
                            elem.body["offset#{name}"], doc["offset#{name}"]
                            doc["client#{name}"]
                        )

                    if value is undefined 
                    then jQuery.css(elem, type, extra) else jQuery.style(elem, type, value, extra)

                , type, (if chainable then margin else undefined), chainable, null

    jQuery


