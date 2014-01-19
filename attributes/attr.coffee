define [
    '../core'
    '../var/rnotwhite'
    '../var/strundefined'
    '../core/access'
    './support'
    '../selector'

], (jQuery, rnotwhite, strundefined, access, support) ->

    nodeHook = boolHook = undefined

    attrHandle = jQuery.expr.attrHandle

    jQuery.fn.extend
        attr: (name, value) ->
            access this, jQuery.attr, name, value, arguments.length > 1

        removeAttr: (name) ->
            @each ->
                jQuery.removeAttr this, name

    jQuery.extend
        attr: (elem, name, value) ->
            hooks = ret = undefined

            nType = elem.nodeType

            return if not elem or nType is 3 or nType is 8 or nType is 2

            if typeof elem.getAttribute is strundefined
                jQuery.prop elem, name, value

            if nType isnt 1 or !jQuery.isXMLDoc elem
                name = name.toLowerCase()

                hooks = jQuery.attrHooks[name] or ( if jQuery.expr.match.bool.test name then boolHook else nodeHook)

            if value isnt undefined

                if value is null
                    jQuery.removeAttr elem, name

                else if hooks and 'get' in hooks and (ret = hooks.get elem, name) isnt undefined
                    return ret

                else
                    elem.setAttribute name, value + ''
                    return value

            else if hooks and 'get' in hooks and (ret = hooks.get elem, name) isnt null
                return null

            else
                ret = jQuery.find.attr elem, name

                return if ret is null then undefined else ret

        removeAttr: (elem, value) ->
            name = propName = undefined

            i = 0;

            attrNames = value and value.match rnotwhite

            if attrNames and elem.nodeType is 1
                while (name = attrNames[i++])
                    propName = jQuery.propFix[name] or name

                    elem[propName] = false if jQuery.expr.match.bool.test name

                    elem.removeAttribute name

        attrHooks: 
            type:
                set: (elem, value) ->

                    if not support.radioValue and value is 'radio' and jQuery.nodeType elem, 'input'
                        val = elem.value

                        elem.setAttribute 'type', value

                        elem.value = val if val

                        value

    boolHook = 
        set: (elem, value, name) ->
            if value is false
                jQuery.removeAttr elem, value

            else
                elem.setAttribute name, name

            name

    jQuery.each jQuery.expr.match.bool.source.match /\w+/g, (i, name) ->
        getter = attrHandle[name] or jQuery.find.attr

        attrHandle[name] = (elem, name, isXML) ->
            ret = handle = undefined

            if not isXML
                handle = attrHandle[name]

                attrHandle[name] = ret

                ret = if getter(elem, name, isXML) isnt null then name.toLowerCase() else null

                attrHandle[name] = handle

            ret

