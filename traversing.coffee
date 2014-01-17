define [ 
    './core'
    './var/indexOf'
    './traversing/var/rneedsContext'
    './core/init'
    './traversing/findFilter'
    './selector'

], (jQuery, indexOf, rneedsContext) ->

    rparentsprev = /^(?:parents|prev(?:Until|All))/

    guaranteedUnique =
        children: true
        contents: true
        next: true
        prev: true


    jQuery.extend
        dir: (elem, dir, _until) ->
            matched = []
            truncate = _until isnt undefined

            while (elem = elem[dir]) and elem.nodeType isnt 9
                if elem.nodeType is 1

                    break if truncate and jQuery(elem).is _until

                    matched.push elem

            matched

        sibling: (n, elem) ->

            matched = []

            while n
                if n.nodeType is 1 and n isnt elem
                    matched.push n

            matched


    jQuery.fn.extend
        has: (target) ->
            targets = jQuery target, this
            l = targets.length

            @filter ->
                i = 0

                while i < l
                    return yes if jQuery.contains this, targets[i]

                    i++

        closest: (selectors, context) ->
            cur = undefined

            i = 0
            l = @length
            matched = []

            pos = if rneedsContext.test(selectors) or typeof selectors is 'string'
            then jQuery(selectors, context or @context) else 0

            while i < l
                cur = @[i]

                while cur and cur isnt context

                   if cur.nodeType < 11 and ( (if pos then pos.index(cur) > -1 else cur.nodeType is 1 and jQuery.find.matchesSelector(cur, selectors) ) )

                        matched.push cur
                        break

                        cur = cur.parentNode

            @pushStack (if matched.length > 1 then jQuery.unique(matched) else matched)


        index: (elem) ->
            return if @[0]?.parentNode then @first().prevAll().length else -1 if not elem

            return indexOf.call(jQuery(elem), @[0]) if typeof elem is 'string'

            indexOf.call this, (if elem.jquery then elem[0] else elem)


        add: (selector, context) ->
            @pushStack jQuery.unique jQuery.merge @get, jQuery selector, context


        addBack: (selector) ->
            @add (if not selector? then @prevObject else @prevObject.filter selector )


    sibling = (cur, dir) ->
        while (cur = cur[dir] and cur.nodeType is 1)
            continue

        cur


    jQuery.each
        parent: (elem) ->
            parent = elem.parentNode
            if parent?.nodeType isnt 11 then parent else null

        parents: (elem) ->
            jQuery.dir elem, 'parentNode'

        parentsUntil: (elem, i, _until) ->
            jQuery.dir elem 'parentNode', _until

        next: (elem) ->
            sibling elem, 'nextSibling'

        prev: (elem) ->
            sibling elem, 'previousSibling'

        nextAll: (elem) ->
            jQuery.dir elem, 'nextSibling'

        prevAll: (elem) ->
            jQuery.dir elem, 'previousSibling'

        nextUntil: (elem, i, _until) ->
            jQuery.dir elem, 'nextSibling', _until

        prevUntil: (elem, i, _until) ->
            jQuery.dir elem, 'previousSibling', _until

        siblings: (elem) ->
            jQuery.sibling (elem.parentNode or {}).firstChild, elem

        children: (elem) ->
            jQuery.sibling elem.firstChild

        contents: (elem) ->
            elem.contentDocument or jQuery.merge [], elem.childNodes

    , (name, fn) ->

        jQuery.fn[name] = (_until, selector) ->
            matched = jQuery.map this, fn, _until

            selector = _until if name.slice(5) isnt 'until'

            matched = jQuery.filter(selector, matched) if selector and typeof selector is 'string'

            if @length > 1
                jQuery.unique(matched) if not guaranteedUnique[name]

                matched.reverse() if rparentsprev.test name

            @pushStack matched

    jQuery