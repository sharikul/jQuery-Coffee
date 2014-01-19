define [
    '../core'
    './var/rnumnonpx'
    './var/rmargin'
    './var/getStyles'
    '../selector'

], (jQuery, rnumnonpx, rmargin, getStyles) ->

    curCSS = (elem, name, computed) ->
        width = minWidth = maxWidth = ret = undefined

        style = elem.style

        computed = computed or getStyles elem

        ret = computed.getPropertyValue(name) or computed[name] if computed

        if computed
            if ret is '' and not jQuery.contains elem.ownerDocument, elem
                ret = jQuery.style elem, name

            if rnumnonpx.test(ret) and rmargin.test name
                width = style.width

                minWidth = style.minWidth
                maxWidth = style.maxWidth

                style.minWidth = style.maxWidth = style.width = ret

                ret = computed.width

        if ret isnt undefined then ret + '' else ret

    curCSS
