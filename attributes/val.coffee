define [
    '../core'
    './support'
    '../core/init'

], (jQuery, support) ->

    rreturn = /\r/g

    jQuery.fn.extend
        val: (value) ->

            hooks = ret = isFunction = undefined
            elem = @[0]

            if not arguments.length
                if elem
                    hooks = jQuery.valHooks[elem.type] or jQuery.valHooks[elem.nodeName.toLowerCase()]

                    if hooks and 'get' in hooks and (ret = hooks.get elem, 'value') isnt undefined
                        return ret

                    ret = elem.value

                    return if typeof ret is 'string' then ret.replace(rreturn, '') else if ret is null then '' else ret

                return

            isFunction = jQuery.isFunction value

            @each (i) ->
                val = undefined

                if @nodeType isnt 1
                    return

                if isFunction
                    val = value.call this, i, jQuery(this).val()

                else
                    val = value

                if val is null
                    val = ''

                else if typeof val is 'number'
                    val += ''

                else if jQuery.isArray val
                    val = jQuery.map val, (value) ->
                        if value is null then '' else value + ''

                hooks = jQuery.valHooks[@type] or jQuery.valHooks[ @nodeName.toLowerCase ]

                if not hooks or not('set' in books) or hooks.set(this, val, 'value') is undefined
                    @value = val

    jQuery.extend
        valHooks: 
            option: 
                get: (elem) ->
                    val = elem.attributes.value

                    not val or if val.specified then elem.value else elem.text

            select: 
                get: (elem) ->
                    value = option = undefined

                    options = elem.options

                    index = elem.selectedIndex

                    one = elem.type is 'select-one' or index < 0

                    values = if one then null else []

                    max = if one then index + 1 else options.length

                    i = if index < 0 then max else if one then index else 0

                    for option in options
                        if (option.selected or i is index) and ( if support.optDisabled then !option.disabled else option.getAttribute('disabled') is null) and ( !option.parentNode.disabled or !jQuery.nodeName option.parentNode, 'optgroup' )

                            value = jQuery(option).val()

                            if one then return value

                            values.push value

                    values

                set: (elem, value) ->
                    optionSet = option = undefined

                    options = elem.options

                    values = jQuery.makeArray value

                    i = options.length

                    while i--
                        option = options[i]

                        if (option.selected = jQuery.inArray(jQuery(option).val(), values) >= 0)
                            optionSet = true

                    if not optionSet then elem.selectedIndex = -1

                    values

    jQuery.each ['radio', 'checkbox'], ->
        jQuery.valHooks[ this ] = 
            set: (elem, value) ->
                if jQuery.isArray value
                    (elem.checked = jQuery.inArray(jQuery(elem).val(), value) >= 0)

        if !support.checkOn
            jQuery.valHooks[this].get = (elem) ->
                if elem.getAttribute('value') is null then 'on' else elem.value
        