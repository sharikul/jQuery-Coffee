define [
    './core'
    './var/rnotwhite'

], (jQuery, rnotwhite) ->

    optionsCache = {}

    createOptions = (options) ->
        object = optionsCache[ options ] = {}

        jQuery.each options.match( rnotwhite ) or [], (_, flag) ->
            object[ flag ] = yes

        object


    jQuery.Callbacks = (options) ->

        options = if typeof options is 'string' then ( optionsCache[options] or createOptions options) else jQuery.extend {}, options

        memory = fired = firing = firingStart = firingLength = firingIndex = undefined

        list = []

        stack = !options.once and []

        fire = (data) ->
            memory = options.memory and data
            fired = yes

            firingIndex = firingStart or 0
            firingStart = 0
            firingLength = list.length

            firing = yes

            for firingIndex in list
                if list[ firingIndex ].apply(data[0], data[1]) is no and options.stopOnFalse
                    memory = no
                    break

            firing = no

            if list
                if stack
                    if stack.length
                        fire stack.shift()

                else if memory
                    list = []

                else
                    self.disable()

        self = 
            add: ->
                if list
                    start = list.length

                    ((args) ->
                        jQuery.each args, (_, arg) ->

                            type = jQuery.type arg

                            if type is 'function'
                                if !options.unique or !self.has arg
                                    list.push arg

                            else if arg and arg.length and type isnt 'string'
                                add arg
                    )(arguments)

                    if firing
                        firingLength = list.length

                    else if memory
                        firingStart = start
                        fire memory
                this

            remove: ->
                if list
                    jQuery.each arguments, (_, arg) ->
                        index = undefined

                        while ( index = jQuery.inArray arg, list, index) > -1
                            list.splice index, 1

                            if firing
                                if index <= firingLength
                                    firingLength--

                                if index <= firingIndex
                                    firingIndex--
                this

            has: (fn) ->
                if fn then jQuery.inArray(fn, list) > -1 else !!(list and list.length)

            empty: ->
                list = []
                firingLength = 0

                this

            disable: ->
                list = stack = memory = undefined

                this

            disabled: ->
                !list

            lock: ->
                stack = undefined

                if !memory
                    self.disable()

                this

            locked: ->
                !stack

            fireWith: (context, args) ->
                if list and ( !fired or stack )
                    args = args or []

                    args = [context, (if args.slice then args.slice() else args)]

                    if firing
                        stack.push args

                    else
                        fire args

                this

            fire: ->
                self.fireWith this, arguments

                this

            fired: ->
                !!fired

        self

    jQuery