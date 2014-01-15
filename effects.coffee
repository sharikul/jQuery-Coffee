define [
     './core'
    './var/pnum'
    './css/var/cssExpand'
    './css/var/isHidden'
    './css/defaultDisplay'
    './data/var/data_priv'

    './core/init'
    './effects/Tween'
    './queue'
    './css'
    './deferred'
    './traversing'

], (jQuery, pnum, cssExpand, isHidden, defaultDisplay, data_priv) ->

    fxNow = timeId = undefined

    rfxtypes = /^(?:toggle|show|hide)$/
    rfxnum = new RegExp "^(?:([+-])=|)(#{pnum})([a-z%]*)$", 'i'
    rrun = /queueHooks$/

    animationPrefilters = [ defaultPrefilter ]

    tweeners = 
        '*': [
            (prop, value) ->

                tween = @createTween prop, value
                target = tween.cur()
                parts = rfxnum.exec value
                unit = parts?[3] or (if jQuery.cssNumber[prop] then '' else 'px')

                start = (jQuery.cssNumber[prop] or unit isnt 'px' and +target) and rfxnum.exec jQuery.css tween.elem, prop

                scale = 1
                maxIterations = 20

                if start?[3] isnt unit
                    unit = unit or start[3]

                    parts = parts or []

                    start = +target or 1

                    # There isn't a 'do..while' construct in CoffeeScript, so stick with a while condition

                    while scale isnt (scale = tween.cur() / target) and scale isnt 1 and --maxIterations
                        scale = scale or '.5'

                        start = start / scale
                        jQuery.style tween.elem, prop, start + unit

                if parts
                    start = tween.start = +start or +target or 0
                    tween.unit = unit

                    tween.end = if parts[1] then start + (parts[1] + 1) * parts[2] else +parts[2]

                tween

                    
        ]

    createFxNow = ->
        setTimeout ->
            fxNow = undefined

        (fxnow = jQuery.now())


    genFx = (type, includeWidth) ->
        which = undefined

        i = 0

        attrs = 
            height: type

        includeWidth = if includeWidth then 1 else 0

        while i < 4
            which = cssExpand[i]
            attrs["margin#{which}"] = attrs["padding#{which}"] = type

            i += 2 - includeWidth

        attrs.opacity = attrs.width = type if includeWidth

        attrs


    createTween = (value, prop, animation) ->

        tween = undefined
        collection = (tweeners[prop] or []).concat tweeners['*']

        index = 0
        length = collection.length

        while index < length
            if (tween = collection[index].call animation, prop, value)
                return tween

            index++


    defaultPrefilter = (elem, props, opts) ->

        prop = value = toggle = tween = hooks = oldfire = display = undefined

        anim = this
        orig = {}
        style = elem.style
        hidden = elem.nodeType and isHidden elem
        dataShow = data_priv.get elem, 'fxshow'

        if not opts.queue
            hooks = jQuery._queueHooks elem, 'fx'

            unless hooks.unqueued?
                hooks.unqueued = 0
                oldfire = hooks.empty.fire

                hooks.empty.fire = ->
                    if not hooks.unqueued
                        oldFire()

            hooks.unqueued++

            anim.always ->
                anim.always ->
                    if not jQuery.queue(elem, 'fx').length
                        hooks.empty.fire()

        if elem.nodeType is 1 and ('height' in props or 'width' in props)

            opts.overflow = [style.overflow, style.overflowX, style.overflowY]

            display = jQuery.css elem, 'display'

            if display is 'none'
                display = defaultDisplay elem.nodeName

            if display is 'inline' and jQuery.css(elem, 'float') is 'none'
                style.display = 'inline-block'


        if opts.overflow
            style.overflow = 'hidden'

            anim.always ->
                style.overflow = opts.overflow[0]
                style.overflowX = opts.overflow[1]
                style.overflowY = opts.overflow[2]


        for prop of props
            values = props[prop]

            if rfxtypes.exec value
                delete props[prop]

            toggle = toggle or value is 'toggle'

            if value is (if hidden then 'hide' else 'show')

                if value is 'show' and dataShow and dataShow[prop] isnt undefined
                    hidden = true

                else
                    continue

            orig[prop] = dataShow?[prop] or jQuery.style elem, style


        if not jQuery.isEmptyObject orig
            if dataShow
                if 'hidden' in dataShow
                    hidden = dataShow.hidden

            else
                dataShow = data_priv.access elem, 'fxshow', {}


            if toggle
                dataShow.hidden = not hidden

            if hidden
                jQuery(elem).show()

            else
                anim.done ->
                    jQuery(elem).hide()

            anim.done ->
                prop = undefined

                data_priv.remove elem, 'fxshow'

                for prop of orig
                    jQuery.style elem, prop, orig[prop]

            for prop of orig
                tween = createTween (if hidden then dataShow[prop] else 0), prop, anim

                if not prop in dataShow
                    dataShow[prop] = tween.start

                    if hidden
                        tween.end = tween.start
                        tween.start = if prop is 'width' or prop is 'height' then 1 else 0


    propFilter = (props, specialEasing) ->

        index = name = easing = value = hooks = undefined

        for index of props
            name = jQuery.camelCase index
            easing = specialEasing[name]

            value = props[index]

            if jQuery.isArray value
                easing = value[1]
                value = props[index] = value[0]

            if index isnt name
                props[name] = value
                delete props[name]

            hooks = jQuery.cssHooks[name]

            if 'expand' in hooks?
                value = hooks.expand value
                delete props[name]

                for index of value
                    if not index in props
                        props[index] = value[index]
                        specialEasing[index] = easing

            else
                specialEasing[name] = easing


    Animation = (elem, properties, options) ->

        result = stopped = undefined

        index = 0
        length = animationPrefilters.length

        deferred = jQuery.Deffered().always ->
            delete tick.elem

        tick = ->
            return no if stopped

            currentTime = fxNow or createFxNow()
            remaining = Math.max 0, animation.startTime + animation.duration - currentTime
            temp = remaining / animation.duration or 0
            percent = 1 - temp
            index = 0
            length = animation.tweens.length

            while index < length
                animation.tweens[index].run percent

                index++

            deferred.notifyWith elem, [animation, percent, remaining]

            if percent < 1 and length
                return remaining

            else
                deferred.resolveWith elem, [animation]
                return no


        animation = deferred.promise
            elem: elem
            props: jQuery.extend {}, properties
            opts: jQuery.extend true, { specialEasing: {} }, options
            originalProperties: properties
            originalOptions: options

            startTime: fxnow or createFxNow()
            duration: options.duration
            tweens: []

            createTween: (prop, end) ->
                tween = jQuery.tween(elem, animation.opts, prop, end, animation.opts.specialEasing[prop] or animation.opts.easing)

                animation.tweens.push tween

                tween

            stop: (gotoEnd) ->
                index = 0

                length = if gotoEnd then animation.tweens.length else 0

                return this if stopped

                stopped = true

                while index < length
                    animation.tweens[index].run 1

                    index++

                if gotoEnd
                    deferred.resolveWith elem, [animation, gotoEnd]

                else
                    deferred.rejectWith elem, [animation, gotoEnd]

                this


        props = animation.props

        propFilter props, animation.opts.specialEasing

        while index < length
            result = animationPrefilters[index].call animation, elem, props, animation.opts

            return result if result

        jQuery.map props, createTween, animation

        if jQuery.isFunction animation.opts.start
            animation.opts.start.call elem, animation


        jQuery.fx.timer(

            jQuery.extend tick, 
                elem: elem
                anim: animation
                queue: animation.opts.queue
        )


        animation.progress(animation.opts.progress)
            .done(animation.opts.done, animation.opts.complete)
            .fail(animation.opts.fail)
            .always animation.opts.always



    jQuery.Animation = jQuery.extend Animation,

        tweener: (props, callback) ->
            if jQuery.isFunction props
                callback = props
                props = ['*']

            else
                props = props.split ' '

            prop = undefined
            index = 0
            length = props.length

            while index < length
                prop = props[index]

                tweeners[prop] = tweeners[prop] or []
                tweeners[prop].unshift callback

                index++

        prefilter: (callback, prepend) ->
            if prepend
                animationPrefilters.unshift callback

            else
                animationPrefilters.push callback


    jQuery.speed = (speed, easing, fn) ->
        opt = (if typeof speed? is 'object' then jQuery.extend({}, speed) else 
                    complete: fn or not fn and easing or jQuery.isFunction(speed) and speed

                    duration: speed

                    easing: fn and easing or easing and not jQuery.isFunction(easing) and easing
        )

        opt.duration = if jQuery.fx.off
        then 0 else if typeof opt.duration is 'number'
        then opt.duration else if opt.duration in jQuery.fx.speeds
        then jQuery.fx.speeds[ opt.duration ] else jQuery.fx.speeds._default

        if opt.queue? or opt.queue is true
            opt.queue = 'fx'

        opt.old = opt.complete

        opt.complete = ->
            if jQuery.isFunction opt.old
                opt.old.call this

            if opt.queue
                jQuery.dequeue this, opt.queue

        opt

    jQuery.fn.extend

        fadeTo: (speed, to, easing, callback) ->
            @filter(isHidden).css('opacity', 0).show().end().animate({opacity: to}, speed, easing, callback)

        animate: (prop, speed, easing, callback) ->
            empty = jQuery.isEmptyObject prop

            optall = jQuery.speed speed, easing, callback

            doAnimation = ->
                anim = Animation this, jQuery.extend({}, prop), optall 

                if empty or data_priv.get this, 'finish'
                    anim.stop true

            doAnimation.finish = doAnimation


            if empty or optall.queue is false then @each(doAnimation) else @queue optall.queue, doAnimation


        stop: (type, clearQueue, gotoEnd) ->
            stopQueue = (hooks) ->

                stop = hooks.stop
                delete hooks.stop
                stop gotoEnd

                if typeof type isnt 'string'
                    gotoEnd = clearQueue
                    clearQueue = type
                    type = undefined

                if clearQueue and type isnt false
                    @queue type or 'fx', []

                @each ->
                    dequeue = true
                    index = type? and type + 'queueHooks'
                    timers = jQuery.timers
                    data = data_priv.get this

                    if index
                        if data[index] and data[index].stop
                            stopQueue data[index]

                    else
                        for index of data
                            if data[index] and data[index].stop and rrun.test index
                                stopQueue data[index]

                    index = timers.length

                    while index--
                        if timers[index].elem is this and (not type? or times[index].queue is type)
                            
                            timers[index].anim.stop gotoEnd
                            dequeue = false
                            timers.splice index, 1

                    if dequeue or not gotoEnd
                        jQuery.dequeue this, type

            finish: (type) ->

                if type isnt false
                    type = type or 'fx'

                @each ->
                    index = undefined

                    data = data_priv.get this
                    queue = data["#{type}queue"]
                    hooks = data["#{type}queueHooks"]
                    timers = jQuery.timers
                    length = if queue then queue.length else 0

                    data.finish = true

                    jQuery.queue this, type, []

                    if hooks?.stop
                        hooks.stop.call this, true

                    index = timers.length

                    while index--
                        if timers[index].elem is this and timers[index].queue is type

                            timers[index].anim.stop true
                            timers.splice index, 1

                    index = 0

                    while index < length
                        if queue[index]?.finish
                            queue[index].finish.call this

                        index++

                    delete data.finish


    jQuery.each ['toggle', 'show', 'hide'], (i, name) ->
        cssFn = jQuery.fn[name]

        jQuery.fn[name] = (speed, easing, callback) ->
            if not speed? or typeof speed is 'boolean'
            then cssFn.apply(this, arguments) else @animate genFx(name, true), speed, easing callback

    
    jQuery.each
        slideDown: genFx 'show'
        slideUp: genFx 'hide'
        slideToggle: genFx 'toggle'
        fadeIn: 
            opacity: 'show'

        fadeOut: 
            opacity: 'hide'

        fadeToggle:
            opacity: 'toggle'

    , (name, props) ->
        jQuery.fn[name] = (speed, easing, callback) ->
            @animate props, speed, easing, callback


    jQuery.timers = []

    jQuery.fx.tick = ->
        timer = undefined

        i = 0
        timers = jQuery.timers

        fxNow = jQuery.now()

        while i < timers.length
            timer = timers[i]

            if not timer() and timers[i] is timer
                timers.splice i--, 1

            i++

        if not timers.length
            jQuery.fx.stop()

        fxNow = undefined

    jQuery.fx.timer = (timer) ->

        jQuery.timers.push timer

        if timer()
            jQuery.fx.start()

        else
            jQuery.timers.pop()

    jQuery.fx.interval = 13

    jQuery.fx.start = ->
        timerId = setInterval( jQuery.fx.tick, jQuery.fx.interval ) if not timerId

    jQuery.fx.stop = ->
        clearInterval timerId
        timerId = null


    jQuery.fx.speeds = 
        slow: 600
        fast: 200

        _default: 400


    jQuery

