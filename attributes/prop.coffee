define [
    '../core'
    '../core/access'
    './support'

], (jQuery, access, support) ->

    rfocusable = /^(?:input|select|textarea|button)$/i

    jQuery.fn.extend
        prop: (name, value) ->
            access this, jQuery.prop, name, value, arguments.length > 1

        removeProp: (name) ->
            @each ->
                delete @[ jQuery.propFix[name] or name ]


    jQuery.extend
        propFix:
            for: 'htmlFor'
            class: 'className'

        prop: (elem, name, value) ->
            ret = hooks = notxml = undefined

            nType = elem.nodeType

            return no if not elem or nType is 3 or nType is 8 or nType is 2

            notxml = nType isnt 1 or !jQuery.isXMLDoc elem

            if notxml
                name = jQuery.propFix[name] or name
                hooks = jQuery.propHooks[name]

            if value isnt undefined
                return hooks and 'set' in hooks and if (ret = hooks.set elem, value, name) isnt undefined then ret else (elem[name] = value)

            else
                return hooks and 'get' in hooks and if (ret = hooks.get elem, value) isnt null then ret else elem[name]

        propHooks: 
            tabIndex: 
                get: (elem) ->
                    if elem.hasAttribute('tabIndex') or rfocusable.test(elem.nodeName) or elem.href then elem.tabIndex else -1

    if not support.optSelected
        jQuery.propHooks.selected = 
            get: (elem) ->
                parent = elem.parentNode

                parent.parentNode.selectedIndex if parent?.parentNode?

                null

    jQuery.each [
        'tabIndex'
        'readOnly'
        'maxLength'
        'cellSpacing'
        'cellPadding'
        'rowSpan'
        'colSpan'
        'useMap'
        'frameBorder'
        'contentEditable'

    ], ->
        jQuery.propFix[ @toLowerCase() ] = this
