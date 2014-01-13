define [
    './core'
    './var/pnum'
    './core/access'
    './css/var/rmargin'
    './css/var/rnumnonpx'
    './css/var/cssExpand'
    './css/var/isHidden'
    './css/var/getStyles'
    './css/curCSS'
    './css/defaultDisplay'
    './css/addGetHookIf'
    './css/support'
    './data/var/data_priv'

    './core/init'
    './css/swap'
    './core/ready'
    './selector'

], (jQuery, pnum, access, rmargin, rnumnonpx, cssExpand, isHidden,
        getStyles, curCSS, defaultDisplay, addGetHookIf, support, data_priv) ->

    rdisplayswap = /^(none|table(?!-c[ea]).+)/
    rnumsplit = new RegExp "^(#{pnum})(.*)$", 'i'
    rrelNum = new RegExp "^([+-])=(#{pnum})", 'i'

    cssShow = 
        position: 'absolute'
        visibility: 'hidden'
        display: 'block'

    cssNormalTransform =
        letterSpacing: 0
        fontWeight: 400

    cssPrefixes = [
        'Webkit'
        'O'
        'Moz'
        'ms'
    ]

    vendorPropName = (style, name) ->

        if name in style
            return name

        capName = name[0].toUpperCase() + name.slice 1

        origName = name

        i = cssPrefixes.length

        while i--
            name = cssPrefixes[i] + capName

            if name in style
                return name

        origName

    setPositiveNumber = (elem, value, subtract) ->
        matches = rnumsplit.exec value

        if matches then Math.max(0, matches[1] - (subtract or 0)) + (matches[2] or 'px') else value

    augmentWidthOrHeight = (elem, name, extra, isBorderBox, styles) ->
        i = if extra is (if isBorderBox then 'border' else 'content') then 4 else if name is 'width' then 1 else 0

        val = 0

        while i < 4
            if extra is 'margin'
                val += jQuery.css elem, extra + cssExpand[i], true, styles

            if isBorderBox
                if extra is 'current'
                    val -= jQuery.css elem, "padding#{cssExpand[i]}", true, styles


                if extra isnt 'margin'
                    val -= jQuery.css elem, "border#{cssExpand[i]}Width", true, styles

            else
                val += jQuery.css elem, "padding#{cssExpand[i]}", true, styles

                if extra isnt 'padding'
                    val += jQuery.css elem, "border#{cssExpand[i]}Width", true, styles

            i++

        val

    getWidthOrHeight = (elem, name, extra) ->

        valueIsBorderBox = true
        
        val = if name is 'width' then elem.offsetWidth else elem.offsetHeight
        
        styles = getStyles elem

        isBorderBox = jQuery.css(elem, 'boxSizing', false, styles) is 'border-box'

        if val <= 0 or not val?
            val = curCSS elem, name, style

            if val < 0 or not val?
                val = elem.style[name]

            if rnumnonpx.test val
                return val

            valueIsBorderBox = isBorderBox and (support.isBoxSizingReliable() or val is elem.style[name] )

            val = parseFloat(val) or 0


        ( val + augmentWidthOrHeight(elem, name, extra or (if isBorderBox then 'border' else 'current'), valueIsBorderBox, styles) ) + 'px'


    showHide = (elements, show) ->
        display = elem = hidden = undefined

        values = []

        index = 0

        length = elements.length

        while index < length
            elem = elements[index]

            if not elems.style
                continue

            values[index] = data_priv.get elem, 'olddisplay'

            display = elems.style.display

            if show
                if not values[index] and display is 'none'
                    elem.style.display = ''

                if elem.style.display is '' and isHidden elem
                    values[index] = data_priv.access elem, 'olddisplay', defaultDisplay elem.nodeName

            else
                if not values[index]
                    hidden = isHidden elem

                    if display? isnt 'none' or not display
                        data_priv.set elem, 'olddisplay', (if hidden then display else jQuery.css elem, 'display')

            index++


        # 'elem' in this instance refers to elements[index]
        for elem in elements
            if not elem.style
                continue

            if not show or elem.style.display is 'none' or elem.style.display is ''
                elem.style.display = (if show then values[index] or '' else 'none')

        elements

    jQuery.extend
        cssHooks:
            opacity:
                get: (elem, computed) ->
                    if computed
                        ret = curCSS elem, 'opacity'

                        if ret is '' then '1' else ret

        cssNumber: 
            columnCount: true
            fillOpacity: true
            fontWeight: true
            lineHeight: true
            opacity: true
            order: true
            orphans: true
            widows: true
            zIndex: true
            zoom: true


        cssProps: 
            float: 'cssFloat'


        style: (elem, name, value, extra) ->

            if not elem or elem.nodeType is 3 or elem.nodeType is 8 or not elem.style
                return

            ret = type = hooks = undefined

            origName = jQuery.camelCase name
            style = elem.style

            name = jQuery.cssProps[origName] or (jQuery.cssProps[origName] = vendorPropName style, origName)

            hooks = jQuery.cssHooks[name] or jQuery.cssHooks[origName]

            if value isnt undefined
                type = typeof value

                if type is 'string' and (ret = rrelNum.exec value) 
                    value = (ret[1] + 1) * ret[2] + parseFloat jQuery.css elem, name

                    type = 'number'

                if not value? or value isnt value
                    return

                if type is 'number' and not jQuery.cssNumber[origName]
                    value += 'px'

                if not support.clearCloneStyle and value is '' and name.indexOf('background') is 0
                    style[name] = 'inherit'

                if not hooks or not('set' in hooks) or (value = hooks.set elem, value, extra) isnt undefined
                    style[name] = ''
                    style[name] = value


            else
                if 'get' in hooks? and (ret = hooks.get elem, false, extra) isnt undefined
                    return ret

                style[name]

        css: (elem, name, extra, styles) ->
            val = num = hooks = undefined

            origName = jQuery.camelCase name

            name = jQuery.cssProps[origName] or (jQuery.cssProps[origName] = vendorPropName elem.style, origName)

            hooks = jQuery.cssHooks[name] or jQuery.cssHooks[origName]

            if 'get' in hooks?
                val = hooks.get elem, true, extra

            if val is undefined
                val = curCSS elem, name, styles

            if val is 'normal' and name in cssNormalTransform
                val = cssNormalTransform[name]

            if extra is '' or extra
                num = parseFloat val
                return if extra is true or jQuery.isNumeric(num) then num or 0 else val

            val

    jQuery.each ['height', 'width'], (i, name) ->

        jQuery.cssHooks[name] = 

            get: (elem, computed, extra) ->
                if computed
                    if elem.offsetWidth is 0 and rdisplayswap.test( jQuery.css elem, 'display' ) then jQuery.swap(elem, cssShow, ->

                        getWidthOrHeight elem, name, extra

                    ) else getWidthOrHeight elem, name, extra

            set: (elem, value, extra) ->
                styles = extra and getStyles elem

                setPositiveNumber( elem, value, (if extra then augmentWidthOrHeight(elem, name, extra, jQuery.css(elem, 'boxSizing', false, styles) is 'border-box', styles) else 0 ))


    jQuery.cssHooks.marginRight = addGetHookIf support.reliableMarginRight, (elem, computed) ->
        if computed
            jQuery.swap elem, {
                display: 'inline-block'
            }, curCSS, [elem, 'marginRight']


    jQuery.each
        margin: ''
        padding: ''
        border: 'Width'
    , (prefix, suffix) ->
        
        jQuery.cssHooks[prefix + suffix] =
            expand: (value) ->
                i = 0
                expanded = {}

                parts = if typeof value is 'string' then value.split(' ') else [value]

                while i < 4
                    expanded[prefix + cssExpand[i] + suffix] = parts[i] or parts[i - 2] or parts[0]

                    i++

                expanded

        if not rmargin.test prefix
            jQuery.cssHooks[prefix + suffix].set = setPositiveNumber



    jQuery.fn.extend = 
        css: (name, value) ->
            access this, (elem, name, value) ->
                styles = len = undefined

                map = {}
                i = 0

                if jQuery.isArray name
                    styles = getStyles elem
                    len = name.length

                    while i < len
                        map[ name[i] ] = jQuery.css elem, name[i], false, styles

                        i++

                    return map

                if value isnt undefined then jQuery.style(elem, name, value) else jQuery.css elem, name

            , name, value, arguments.length > 1


        show: -> 
            showHide this, true

        hide: ->
            showHide this

        toggle: (state) ->
            if typeof state is 'boolean'
               return if state then @show else @hide

            @each ->
                if isHidden this
                    jQuery(this).show()
                else
                    jQuery(this).hide()

    jQuery