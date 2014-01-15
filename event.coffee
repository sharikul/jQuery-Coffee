define [
    './core'
    './var/strundefined'
    './var/rnotwhite'
    './var/hasOwn'
    './var/slice'
    './event/support'
    './data/var/data_priv'

    './core/init'
    './data/accepts'
    './selector'

], (jQuery, strundefined, rnotwhite, hasOwn, slice, support, data_priv) ->

    # event.js

    rkeyEvent = /^key/
    rmouseEvent = /^(?:mouse|contextmenu)|click/
    rfocusMorph = /^(?:focusinfocus|focusoutblur)$/
    rtypenamespace = /^([^.]*)(?:\.(.+)|)$/

    returnTrue = -> yes

    returnFalse = -> no

    safeActiveElement = ->
        try
            return document.activeElement
        catch e
            

    jQuery.event

        global: {}

        add: (elem, types, handler, data, selector) ->

            handleObjIn = eventHandle = tmp = events = t = handleObj = special = handlers = type = namespaces = origType = undefined

            elemData = data_priv.get elem

            return no if not elemData

            if handler.handler
                handleObjIn = handler
                handler = handleObjIn.handler
                selector = handleObjIn.selector


            handler.guid = jQuery.guid++ if not handler.guid

            if not (events = elemData.events)
                events = elemData.events = {}

            if not (eventHandle = elemData.handle)
                eventHandle = elemData.handle = (e) ->
                    if typeof jQuery isnt strundefined and jQuery.event.triggered isnt e.type 
                    then jQuery.event.dispatch.apply(elem, arguments) else undefined


            types = (types or '').match(rnotwhite) or ['']

            t = types.length

            while t--
                tmp = rtypenamespace.exec( types[t] ) or []
                type = origType = tmp[1]
                namespaces = ( tmp[2] or '' ).split('.').sort()

                continue if not type

                special = jQuery.event.special[type] or {}

                handleObj = jQuery.extend

                    type: type
                    origType: origType
                    data: data
                    handler: handler
                    guid: handler.guid
                    selector: selector
                    needsContext: selector and jQuery.expr.match.needsContext.test selector
                    namespace: namespaces.join('.')

                , handleObj   

                if not (handlers = events[type])
                    handlers = events[type] = []
                    handlers.delegateCount = 0

                    if not special.setup or special.setup.call(elem, data, namespaces, eventHandle) is false

                        if elem.addEventListener
                            elem.addEventListener type, eventHandle, false

                if special.add
                    special.add.call elem, handleObj

                    handleObj.handler.guid = handler.guid if not handleObj.handler.guid

                    if selector
                        handlers.splice handlers.delegateCount++, 0, handleObj

                    else
                        handlers.push handleObj

                    jQuery.event.global[type] = true

        remove: (elem, types, handler, selector, mappedTypes) ->

            j = origCount = tmp = events = t = handleObj = special = handlers = type = namespaces = origType = undefined

            elemData = data_priv.hasData(elem) and data_priv.get elem

            return no if not elemData or not (events = elemData.events)

            types = (types or '').match(rnotwhite) or ['']

            t = types.length

            while t--
                tmp = rtypenamespace.exec( types[t] ) or []
                type = origType = tmp[1]
                namespaces = (tmp[2] or '').split('.').sort()

                if not type
                    for type of events
                        jQuery.event.remove elem, type + types[t], handler, selector, true

                    continue

                special = jQuery.event.special[type] or {}
                type = (if selector then special.delegateType else special.bindType) or type

                handlers = events[type] or []
                tmp = tmp[2] and new RegExp "(^|\\.)#{namespaces.join '\\.(?:.*\\.|)'}(\\.|$)"

                origCount = j = handlers.length

                while j--
                    handleObj = handlers[j]

                    if (mappedTypes or origType is handleObj.origType) and 
                        (not handler or handler.guid is handleObj.guid) and 
                        (not tmp or tmp.test handleObj.namespace) and 
                        (not selector or selector is handleObj.selector or selector is '**' and handleObj.selector)

                            handlers.splice j, 1

                            handlers.delegateCount-- if handleObj.selector

                            special.remove.call(elem, handleObj) if special.remove

                if origCount and not handlers.length

                    if not special.teardown or
                    special.teardown.call(elem, namespaces, elemData.handle) is false

                        jQuery.removeEvent elem, type, elemData.handler

                    delete events[type]

            if jQuery.isEmptyObject events
                delete elemData.handle
                data_priv.remove elem, 'events'


        trigger: (event, data, elem, onlyHandlers) ->

            i = cur = tmp = bubbleType = ontype = handle = special = undefined

            eventPath = [elem or document]

            type = if hasOwn.call(event, 'type') then event.type else event

            cur = tmp = elem = elem or document

            return no if elem.nodeType is 3 or elem.nodeType is 8

            return no if rfocusMorph.test type + jQuery.event.triggered

            if type.indexOf('.') >= 0
                namespaces = type.split '.'
                type = namespaces.shift()
                namespaces.sort()

            ontype = type.indexOf(':') < 0 and "on#{type}"

            event = if event[jQuery.expando] then event else new jQuery.Event type, typeof event is 'object' and event


            event.isTrigger = if onlyHandlers then 2 else 3
            event.namespace = namespaces.join '.'
            event.namespace_re = if event.namespace then new RegExp "(^|\\.)#{namespaces.join '\\.(?:.*\\.|)'}(\\.|$)" else null

            event.result = undefined
            event.target = elem if not event.target

            data = if not data? then [event] else jQuery.makeArray data, [event]

            special = jQuery.event.special[type] or {}

            if not onlyHandlers and special.trigger?.apply(elem, data) is false
                return no

            if not onlyHandlers and not special.noBubble and not jQuery.isWindow elem

                bubbleType = special.delegateType or type

                if not rfocusMorph.test bubbleType + type
                    cur = cur.parentNode

                ###

                Please help me translate:

                for ( ; cur; cur = cur.parentNode ) {
                    eventPath.push( cur );
                    tmp = cur;
                }

                ###

                for cur in cur.parentNode
                    eventPath.push cur
                    tmp = cur

                if tmp is (elem.ownerDocument or document)
                    eventPath.push tmp.defaultView or tmp.parentWindow or window

            i = 0

            while (cur = eventPath[i++]) and not event.isPropagationStopped()

                event.type = if i > 1 then bubbleType else special.bindType or type

                handle = (data_priv.get(cur, 'events') or {})[event.type] and data_priv.get cur, 'handle'

                handle.apply(cur, data) if handle

                handle = ontype and cur[ontype]

                if handle?.apply and jQuery.acceptData cur
                    event.result = handle.apply cur, data

                    event.preventDefault() if event.result is false


            event.type = type

            if (not special._default or special._default.apply( eventPath.pop(), data) is false) and jQuery.acceptData elem

                if ontype and jQuery.isFunction( elem[type] ) and not jQuery.isWindow elem

                    tmp = elem[ontype]

                    elem[ontype] = null if tmp

                    jQuery.event.triggered = type

                    elem[type]()

                    jQuery.event.triggered = undefined

                    elem[ontype] = tmp if tmp

            event.result

        dispatch: (event) ->

            event = jQuery.event.fix event

            i = j = ret = matched = handleObj = undefined

            handlerQueue = []
            args = slice.call arguments
            handlers = (data_priv.get(this, 'events') or {})[ event.type ] or []
            special = jQuery.event.special[ event.type ] or {}

            args[0] = event
            event.delegateTarget = this


            return no if special.preDispatch?.call(this, event) is false

            handlerQueue = jQuery.event.handlers.call this, event, handlers

            i = 0

            while (matched = handlerQueue[i++] and not event.isPropagationStopped())

                event.currentTarget = matched.elem

                j = 0

                while (handleObj = matched.handlers[j++] and not event.isImmediatePropagationStopped())

                    if not event.namespace_re or event.namespace_re.test handleObj.namespace

                        event.handleObj = handleObj
                        event.data = handleObj.data

                        ret = ( (jQuery.event.special[handleObj.origType] or {}).handle or handleObj.handler).apply matched.elem, args

                        if ret isnt undefined
                            if (event.result = ret) is false
                                event.preventDefault()
                                event.stopPropagation()


            special.postDispatch.call(this, event) if special.postDispatch

            event.result


        handlers: (event, handlers) ->

            i = matches = sel = handleObj = undefined

            handlerQueue = []
            delegateCount = handlers.delegateCount
            cur = event.target

            if delegateCount and cur.nodeType and (not event.button or event.type isnt 'click')

                ###

                Please help me translate:

                for ( ; cur !== this; cur = cur.parentNode || this ) 

                ###

                while cur isnt this and cur = (cur.parentNode or this)

                    if cur.disabled isnt true or event.type isnt 'click'

                        matches = []

                        while i < delegateCount
                            handleObj = handlers[i]

                            sel = handleObj.selector + ''

                            if matches[sel] is undefined

                                matches[sel] = if handleObj.needsContext then jQuery(sel, this).index(cur) >= 0 else jQuery.find(sel, this, null, [cur]).length

                                matches.push(handleObj) if matches[sel]

                            i++

                        if matches.length
                            handlerQueue.push
                                elem: cur
                                handlers: matches

                if delegateCount < handlers.length
                    handlerQueue.push
                        elem: this
                        handlers: handlers.slice delegateCount

                handlerQueue

        props: 'altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which'.split ' '

        fixHooks: {}

        keyHooks:
            props: 'char charCode key keyCode'.split ' '

            filter: (event, original) ->

                if not event.which?
                    event.which = if original.charCode? then original.charCode else original.keyCode

                event

        mouseHooks: 
            props: 'button buttons clientX clientY offsetX offsetY pageX pageY screenX screenY toElement'.split ' '

            filter: (event, original) ->

                eventDoc = doc = body = undefined

                button = original.button

                if not event.pageX? and original.clientX?
                    eventDoc = event.target.ownerDocument or document
                    doc = eventDoc.documentElement
                    body = eventDoc.body

                    event.pageX = original.clientX + (doc?.scrollLeft or body?.scrollLeft or 0) - (doc?.clientLeft or body?.clientLeft or 0)
                    event.pageY = original.clientY = (doc?.scrollTop or body?.scrollTop or 0) - (doc?.clientTop or body?.clientTop or 0)

                    if not event.which and button isnt undefined
                        event.which = (if button and 1 then 1 else if button and 2 then 3 else if button and 4 then 2 else 0)

                    event

        fix: (event) ->

            return event if event[jQuery.expando]

            i = prop = copy

            type = event.type
            originalEvent = event
            fixHook = @fixHooks[type]

            if not fixHook
                @fixHooks[type] = fixHook = if rmouseEvent.test(type) then @mouseHooks else if rkeyEvent.test(type) then @keyHooks else {}

            
            copy = if fixHooks.prop then @props.concat(fixHooks.props) else @props

            event = new jQuery.Event originalEvent

            i = copy.length

            while i--
                prop = copy[i]
                event[prop] = originalEvent[prop]

            event.target = document if not event.target

            event.target = event.target.parentNode if event.target.nodeType is 3

            if fixHook.filter then fixHook.filter(event, originalEvent) else event


        special:
            load:
                noBubble: true

            focus: 
                trigger: ->
                    if this isnt safeActiveElement() and @focus
                        @focus()
                        no

                delegateType: 'focusin'

            blur:
                trigger: ->
                    if this is safeActiveElement() and @blur
                        @blur()
                        no
                delegateType: 'focusout'

            click: 
                trigger: ->
                    if @type is 'checkbox' and @click and jQuery.nodeName this, 'input'
                        @click()
                        no

                    _default: (event) ->
                        jQuery.nodeName event.target, 'a'

            beforeunload: 
                postDispatch: (event) ->
                    if event.result isnt undefined
                        event.originalEvent.returnValue = event.result


        simulate: (type, elem, event, bubble) ->
            e = jQuery.extend( new jQuery.event(), event, 
                type: type
                isSimulated: true
                originalEvent: {}
            )

            if bubble
                jQuery.event.trigger(e, null, elem)

            else
                jQuery.event.dispatch.call elem, e

            if e.isDefaultPrevented()
                event.preventDefault()


    jQuery.removeEvent = (elem, type, handle) ->
        elem.removeEventListener(type, handle, false) if elem.removeEventListener


    jQuery.Event = (src, props) ->

        if not (this instanceof jQuery.Event)
            return new jQuery.Event src, props

        if src?.type
            @originalEvent = src
            @type = src.type

            @isDefaultPrevented = if src.defaultPrevented or src.defaultPrevented is undefined and src.getPreventDefault and src.getPreventDefault() then returnTrue else returnFalse

        else
            @type = src

        jQuery.extend(this, props) if props

        @timeStamp = src?.timeStamp or jQuery.now()

        @[jQuery.expando] = true

    jQuery.Event:: = 
        isDefaultPrevented: returnFalse
        isPropagationStopped: returnFalse
        isImmediatePropagationStopped: returnFalse

        preventDefault: ->
            e = @originalEvent

            @isDefaultPrevented = returnTrue

            e.preventDefault() if e?.preventDefault


        stopPropagation: ->
            e = @originalEvent

            @isPropagationStopped = returnTrue

            e.stopPropagation() if e?.stopPropagation()

        stopImmediatePropagation: ->
            @isImmediatePropagationStopped = returnTrue
            @stopPropagation()


    jQuery.each
        mouseenter: 'mouseover'
        mouseleave: 'mouseout'

    , (orig, fix) ->

        jQuery.event.special[orig] = 
            delegateType: fix
            bindType: fix

            handle: (event) ->
                ret = undefined

                target = this

                if not related or (related isnt target and not jQuery.contains target, related)
                    event.type = handleObj.origType
                    ret = handleObj.handler.apply this, arguments
                    event.type = fix

                ret

    if not support.focusinBubbles
        jQuery.each
            focus: 'focusin'
            blur: 'focusout'

        , (orig, fix) ->

            handler = (event) ->
                jQuery.event.simulate fix, event.target, jQuery.event.fix(event), true

            jQuery.event.special[fix] = 
                setup: ->
                    doc = @ownerDocument or this
                    attaches = data_priv.access doc, fix

                    doc.addEventListener(orig, handler, true) if not attaches

                    data_priv.access doc, fix, (attaches or 0) + 1

                teardown: ->
                    doc = @ownerDocument
                    attaches = data_priv.access(doc, fix) - 1

                    if not attaches
                        doc.removeEventListener orig, handler, true
                        data_priv.remove doc, fix

                    else
                        data_priv.access doc, fix, attaches


    jQuery.fn.extend

        on: (types, selector, data, fn, one) ->

            if typeof types is 'object'
                if typeof selector isnt 'string'
                    data = data or selector
                    selector = undefined

                for type of types
                    @on type, selector, data, types[type], one

                return this

            if not data? and not fn?
                fn = selector
                data = undefined

            else if not fn?
                if typeof selector is 'string'
                    fn = data
                    data = undefined

                else
                    fn = data
                    data = selector
                    selector = undefined

            if fn is false
                fn = returnFalse

            else if not fn
                return this


            if one is 1
                origFn = fn

                fn = (event) ->
                    jQuery().off event
                    return origFn.apply this, arguments

                fn.guid = origFn.guid or (origFn.guid = jQuery.guid++)

            @each ->
                jQuery.event.add this, types, fn, data, selector

        one: (types, selector, data, fn) ->
            @on types, selector, data, fn, 1

        off: (types, selector, fn) ->

            if types and types.preventDefault() and types.handleObj
                handleObj = types.handleObj

                jQuery(types.delegateTarget).off (if handleObj.namespace then "#{handleObj.origType}.#{handleObj.namespace}" else handleObj.origType), handleObj.selector, handleObj.handler

                return this

            if typeof types is 'object'
                for type of types
                    @off type, selector, types[type]

                return this

            if selector is false or typeof selector is 'function'
                fn = selector
                selector = undefined

            if fn is false
                fn = returnFalse

            @each ->
                jQuery.event.remove type, data, elem, true

        trigger: (type, data) ->
            @each ->
                jQuery.event.trigger type, data, this

        triggerHandler: (type, data) ->
            elem = @[0]

            jQuery.event.trigger(type, data, elem, true) if elem

    
    jQuery