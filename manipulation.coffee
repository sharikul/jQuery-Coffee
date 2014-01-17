define [
    './core'
    './var/concat'
    './var/push'
    './core/access'
    './manipulation/var/rcheckableType'
    './manipulation/support'
    './data/var/data_priv'
    './data/var/data_user'

    './core/init'
    './data/accepts'
    './traversing'
    './selector'
    './event'

], (jQuery, concat, push, access, rcheckableType, support, data_priv, data_user) ->

    rxhtmlTag = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi
    rtagName = /<([\w:]+)/
    rhtml = /<|&#?\w+;/
    rnoInnerhtml = /<(?:script|style|link)/i
    rchecked = /checked\s*(?:[^=]|=\s*.checked.)/i
    rscriptType = /^$|\/(?:java|ecma)script/i
    rscriptTypeMasked = /^true\/(.*)/
    rcleanScript = /^\s*<!(?:\[CDATA\[|--)|(?:\]\]|--)>\s*$/g

    wrapMap = 

        option: [1, '<select multiple="multiple">', '</select>']

        thead: [1, '<table>', '</table>']

        col: [2, '<table><colgroup>', '</colgroup></table>']

        tr: [2, '<table><tbody>', '</tbody></table>']

        td: [3, '<table><tbody><tr>', '</tr></tbody></table>']

        _default: [0, '', '']

    wrapMap.optGroup = wrapMap.option

    wrapMap.tbody = wrapMap.tfoot = wrapMap.colgroup = wrapMap.caption = wrapMap.thead
    wrapMap.th = wrapMap.td


    manipulationTarget = (elem, content) ->

        if jQuery.nodeName(elem, 'table') and jQuery.nodeName( (if content.nodeType isnt 11 then content else content.firstChild), 'tr' ) 
        then elem.getElementsByTagName('tbody')[0] or elem.appendChild( elem.ownerDocument.createElement 'tbody' ) else elem


    disableScript = (elem) ->
        elem.type = "#{elem.getAttribute('type') isnt null}/#{elem.type}"

        elem

    restoreScript = (elem) ->
        match = rscriptTypeMasked.exec elem.type

        if match
            elem.type = match[1]
        else
            elem.removeAttribute 'type'

        elem

    setGlobalEval = (elems, refElements) ->
        i = 0
        l = elems.length

        while i < l
            data_priv.set elems[i], 'globalEval', not refElements or data_priv.get refElements[i], 'globalEval'

            i++

    cloneCopyEvent = (src, dest) ->
        i = l = type = pdataOld = pdataCur = udataOld = udataCur = events = undefined

        return no if dest.nodeType isnt 1

        if data_priv.hasData src
            pdataOld = data_priv.access src
            pdataCur = data_priv.set dest, pdataOld
            events = pdataOld.events

            if events
                delete pdataCur.handle
                pdataCur.events = {}

                for type of events
                    for i in events[type]
                        jQuery.event.add dest, type, i


        if data_user.hasData src
            udataOld = data_user.access src
            udataCur = jQuery.extend {}, udataOld

            data_user.set dest, udataCur


    getAll = (context, tag) ->

        ret = if context.getElementsByTagName 
        then context.getElementsByTagName(tag or '*') else if context.querySelectorAll 
        then context.querySelectorAll(tag or '*') else []

        if tag is undefined or tag and jQuery.nodeName(context, tag)
        then jQuery.merge([context], ret) else ret


    fixInput = (src, dest) ->
        nodeName = dest.nodeName.toLowerCase()

        if nodeName is 'input' and rcheckableType.test src.type
            dest.checked = src.checked

        else if nodeName is 'input' or nodeName is 'textarea'
            dest.defaultValue = src.defaultValue


    jQuery.extend

        clone: (elem, dataAndEvents, deepDataAndEvents) ->

            i = l = srcElements = destElements = undefined

            clone = elem.cloneNode true
            inPage = jQuery.contains elem.ownerDocument, elem

            if not support.noCloneChecked and (elem.nodeType is 1 or elem.nodeType is 11) and not jQuery.isXMLDoc elem

                destElements = getAll clone
                srcElements = getAll elem

                l = srcElements.length

                while i < l
                    fixInput srcElements[i], destElements[i]

                    i++

            if dataAndEvents
                if deepDataAndEvents
                    srcElements = srcElements or getAll elem
                    destElements = destElements or getAll clone

                    l = srcElements.length

                    while i < l
                        cloneCopyEvent srcElements[i], destElements[i]

                        i++
                else
                    cloneCopyEvent elem, clone

            destElements = getAll clone, 'script'

            if destElements.length > 0
                setGlobalEval destElements, not inPage and getAll elem, 'script'

            clone

        buildFragment: (elems, context, scripts, selection) ->

            elem = tmp = tag = wrap = contains = j = undefined

            fragment = context.createDocumentFragment()
            nodes = []

            # These vars are only being defined here for representational purposes. They're not going to be used later on
            i = 0
            l = elems.length

            for elem in elems

                if elem or elem is 0

                    if jQuery.type(elem) is 'object'
                        jQuery.merge nodes, (if elem.nodeType then [elem] else elem)

                    else if not rhtml.test elem
                        nodes.push context.createTextNode elem

                    else
                        tmp = tmp or fragment.appendChild context.createElement 'div'

                        tag = (rtagName.exec(elem) or ['', ''])[1].toLowerCase()
                        wrap = wrapMap[tag] or wrapMap._default
                        tmp.innerHTML = wrap[1] + elem.replace(rxhtmlTag, '<$1></$2>') + wrap[2]

                        j = wrap[0]

                        while j--
                            tmp = tmp.lastChild

                        jQuery.merge nodes, tmp.childNodes

                        tmp = fragment.firstChild
                        tmp.textContent = ''


            fragment.textContent = ''
            i = 0

            while (elem = nodes[i++])
                continue if selection and jQuery.inArray(elem, selection) isnt -1

                contains = jQuery.contains elem.ownerDocument, elem

                tmp = getAll fragment.appendChild(elem), 'script'

                setGlobalEval(tmp) if contains

                if scripts
                    j = 0

                    while (elem = tmp[i++])
                        scripts.push(elem) if rscriptType.test elem.type or ''

            fragment


        cleanData: (elems) ->

            data = elem = events = type = key = j = undefined
            special = jQuery.event.special

            i = 0

            while (elem = elems[i] isnt undefined)
                if jQuery.acceptData elem
                    key = elem[data_priv.expando]

                    if key and (data = data_priv.cache[key])
                        events = Object.keys data.events or {}

                        if events.length
                            j = 0

                            while (type = events[j]) isnt undefined
                                if special[type]
                                    jQuery.event.remove elem, type

                                else
                                    jQuery.removeEvent elem, type, data.handle

                        if data_priv.cache[key]
                            delete data_priv.cache[key]

                delete data_user.cache[ elem[data_user.expando] ]

                i++


    jQuery.fn.extend
        text: (value) ->

            access this, (value) ->
                if value is undefined
                then jQuery.text(this) else @empty().each ->
                    if @nodeType is 1 or @nodeType is 11 or @nodeType is 9
                        @textContent = value

            , null, value, arguments.length

        append: ->
            @domManip arguments, (elem) ->

                if @nodeType is 1 or @nodeType is 11 or @nodeType is 9
                    target = manipulationTarget this, elem
                    target.appendChild elem

        prepend: ->
            @domManip arguments, (elem) ->
                if @nodeType is 1 or @nodeType is 11 or @nodeType is 9
                    target = manipulationTarget this, elem
                    target.insertBefore elem, target.firstChild

        before: ->
            @domManip arguments, (elem) ->
                @parentNode.insertBefore(elem, this) if @parentNode

        after: ->
            @domManip arguments, (elem) ->
                @parentNode.insertBefore(elem, this.nextSibling) if @parentNode

        remove: (selector, keepData) ->
            elem = undefined

            elems = if selector then jQuery.filter(selector, this) else this
            i = 0

            while (elem = elems[i])?
                if not keepData and elem.nodeType is 1
                    jQuery.cleanData getAll elem

                if elem.parentNode
                    if keepData and jQuery.contains elem.ownerDocument, elem
                        setGlobalEval getAll elem, 'script'

                    elem.parentNode.removeChild elem

                i++

            this

        empty: ->
            elem = undefined
            i = 0

            while (elem = @[i])?
                if elem.nodeType is 1
                    jQuery.cleanData getAll elem, false

                    elem.textContent = ''

                i++

            this

        clone: (dataAndEvents, deepDataAndEvents) ->
            dataAndEvents = if not dataAndEvents? then false else dataAndEvents

            deepDataAndEvents = if not deepDataAndEvents then dataAndEvents else deepDataAndEvents

            @map ->
                jQuery.clone this, dataAndEvents, deepDataAndEvents


        html: (value) ->

            access this, (value) ->
                elem = @[0] or {}
                i = 0
                l = @length

                if value is undefined and elem.nodeType is 1
                    return elem.innerHTML

                if typeof value is 'string' and not rnoInnerhtml.test(value) and not wrapMap[ (rtagName.exec(value) or ['', ''])[1].toLowerCase() ]

                    value = value.replace rxhtmlTag, '<$1></$2>'

                    try
                        while i < l
                            elem = @[i] or {}

                            if elem.nodeType is 1
                                jQuery.cleanData getAll elem, false
                                elem.innerHTML = value

                            i++

                        elem = 0

                    catch e

                @empty.append(value) if elem

            , null, value, arguments.length
