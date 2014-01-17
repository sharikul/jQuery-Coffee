define [
     './core'
    './var/strundefined'
    './core/access'
    './css/var/rnumnonpx'
    './css/curCSS'
    './css/addGetHookIf'
    './css/support'

    './core/init'
    './css'
    './selector'

], (jQuery, strundefined, access, rnumnonpx, curCSS, addGetHookIf, support) ->

    docElem = window.document.documentElement

    getWindow = (elem) ->
        if jQuery.isWindow(elem) then elem else elem.nodeType is 9 and elem.defaultView


    jQuery.offset = 
        setOffset: (elem, options, i) ->

            curPosition = curLeft = curCSSTop = curOffset = curCSSLeft = calculatePosition = undefined

            position = jQuery.css elem, 'position'
            curElem = jQuery elem
            props = {}

            elem.style.position = 'relative' if position is 'static'

            curOffset = curElem.offset()
            curCSSTop = jQuery.css elem, 'top'
            curCSSLeft = jQuery.css elem, 'left'

            calculatePosition = position is ('absolute' or 'fixed') and (curCSSTop + curCSSLeft).indexOf('auto') > -1

            if calculatePosition
                curPosition = curElem.position()
                curTop = curPosition.top
                curLeft = curPosition.left

            else
                curTop = parseFloat(curCSSTop) or 0
                curLeft = parseFloat(curCSSLeft) or 0

            options = options.call(elem, i, curOffset) if jQuery.isFunction options

            props.top = (options.top - curOffset.top) + curTop if options.top?

            props.left = (options.left - curOffset.left) + curLeft if options.left?
            
            if 'using' in options
                options.using.call elem, props

            else
                curElem.css props


    jQuery.fn.extend
        offset: (options) ->

            if arguments.length
                if options is undefined then this else @each (i) ->
                    jQuery.offset.setOffset this, options, i

            docElem = win = undefined

            elem = @[0]
            box = 
                top: 0
                left: 0

            doc = elem?.ownerDocument

            return no if not doc

            docElem = doc.documentElement

            return box if not jQuery.contains docElem, elem

            box = elem.getBoundingClientRect() if typeof elem.getBoundingClientRect isnt strundefined

            win = getWindow doc

            {
                top: box.top + win.pageYOffset - docElem.clientTop
                left: box.left + win.pageXOffset - docElem.clientLeft
            }


        position: ->
            return no if not @[0]

            offsetParent = offset = undefined

            elem = @[0]

            parentOffset = 
                top: 0
                left: 0

            if jQuery.css(elem, 'position') is 'fixed'
                offset = elem.getBoundingClientRect()

            else
                offsetParent = @offsetParent()

                offset = @offset()

                parentOffset = offsetParent.offset() if not jQuery.nodeName offsetParent[0], 'html'

                parentOffset.top += jQuery.css offsetParent[ 0 ], 'borderTopWidth', true 
                parentOffset.left += jQuery.css offsetParent[ 0 ], 'borderLeftWidth', true

            {
                top: offset.top - parentOffset.top - jQuery.css elem, 'marginTop', true
                left: offset.left - parentOffset.left - jQuery.css elem, 'marginLeft', true
            }


        offsetParent: ->
            @map ->
                offsetParent = @offsetParent or docElem

                while offsetParent and (not jQuery.nodeName(offsetParent, 'html') and jQuery.css(offsetParent, 'position') is 'static')
                    offsetParent = offsetParent.offsetParent

                offsetParent or docElem


    jQuery.each
        scrollLeft: 'pageXOffset'
        scrollTop: 'pageYOffset'

    , (method, prop) ->

        top = if 'pageYOffset' is prop

        jQuery.fn[method] = (val) ->
            access this, (elem, method, val) ->

                win = getWindow elem

                if val is undefined
                    return if win then win[prop] else elem[method]

                if win
                    win.scrollTo(
                        (if not top then val else window.pageXOffset),
                        (if top then val else window.pageYOffset)
                    )

                else
                    elem[method] = val

            , method, val, arguments.length, val


    jQuery.each ['top', 'left'], (i, prop) ->

        jQuery.cssHooks[prop] = addGetHookIf support.pixelPosition, (elem, computed) ->
            if computed
                computed = curCSS elem, prop

                if rnumnonpx.test(computed)
                then jQuery(elem).position()[prop] + 'px' else computed


    jQuery