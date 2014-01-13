define [
    '../core'
    '../css'

], (jQuery) ->

    Tween = (elem, options, prop, end, easing) ->
        new Tween::init elem, options, prop, end, easing

    jQuery.Tween = Tween

    Tween.prototype = 
        constructor: Tween

        init: (elem, options, prop, end, easing, unit) ->
            @elem = elem
            @prop = prop
            @easing = easing or 'swing'
            @options = options
            @start = @now = @cur()
            @end = end
            @unit = unit or (if jQuery.cssNumber[prop] then '' else 'px')

        cur: ->
            hooks = Tween.propHooks[@prop]

            if hooks and hooks.get then hooks.get(this) else Tween.propHooks._default.get this

        run: (percent) ->
            eased = undefined

            hooks = Tween.propHooks[@prop]

            if @options?.duration?
                @pos = eased = jQuery.easing[@easing] percent, @options.duration * percent, 0, 1, @options.duration

            else
                @pos = eased = percent

            @now = ( @end - @start ) * eased + @start

            if @options?.step?
                @options.step.call @elem, @now, this

            if hooks?.set?
                hooks.set this

            else
                Tween.propHooks._default.set this

            this

    Tween::init:: = Tween::

    Tween.propHooks =
        _default:
            get: (tween) ->
                result = undefined

                if tween.elem[tween.prop]? and (not tween.elem.style or tween.elem.style[tween.prop] is null)
                    tween.elem[tween.prop]

                result = jQuery.css tween.elem, tween.prop, ''

                not result or if result is 'auto' then 0 else result

            set: (tween) ->

                if jQuery.fx.step[tween.prop] 
                    jQuery.fx.step[tween.prop] tween

                else if tween.elem.style and (tween.elem.style[ jQuery.cssProps[tween.prop] ] isnt null or jQuery.cssHooks[tween.prop])

                    jQuery.style tween.elem, tween.prop, tween.now + tween.unit

                else
                    tween.elem[tween.prop] = tween.now


    Tween.propHooks.scrollTop = Tween.propHooks.scrollLeft =
        set: (tween) ->
            if tween.elem.nodeType and tween.elem.parentNode
                tween.elem[tween.prop] = tween.now

    jQuery.easing =
        linear: (p) ->
            p

        swing: (p) ->
            0.5 - Math.cos(p * Math.PI) / 2

    jQuery.fx = Tween::init

    jQuery.fx.step = {}
