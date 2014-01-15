define [
    './core'
    './var/slice'
    './callbacks'

], (jQuery, slice) ->

    jQuery.extend

        Deferred: (func) ->

            tuples = [

                [
                    'resolve'
                    'done'
                    jQuery.Callbacks 'once memory'
                    'resolved'
                ]

                [
                    'reject'
                    'fail'
                    jQuery.Callbacks 'once memory'
                    'rejected'
                ]

                [
                    'notify'
                    'progress'
                    jQuery.Callbacks 'memory'
                ]

            ]

            state = 'pending'

            promise = 
                state: ->
                    state

                always: ->
                    deferred.done(arguments).fail arguments
                    this

                then: ->
                    fns = arguments

                    jQuery.Deferred((newDefer) ->

                        jQuery.each tuples, (i, tuple) ->

                            fn = jQuery.isFunction( fns[i] ) and fns[i]

                            deferred[ tuple[1] ] ->
                                returned = fn?.apply this, arguments

                                if returned and jQuery.isFunction returned.promise
                                    returned.promise()
                                        .done(newDefer.resolve)
                                        .fail(newDefer.reject)
                                        .progress(newDefer.notify)

                                else
                                    newDefer["#{tuple[0]}With"]( (if this is promise then newDefer.promise() else this), if fn then [returned] else arguments ) 

                        fns = null

                    ).promise()

                promise: (obj) ->
                    if obj? then jQuery.extend(obj, promise) else promise


            deferred = {}

            promise.pipe = promise.then

            jQuery.each tuples, (i, tuple) ->

                list = tuple[2]
                stateString = tuple[3]

                promise[ tuple[1] ] = list.add

                if stateString
                    list.add ->
                        state = stateString

                    , tuples[ i ^ 1 ][2].disable, tuples[2][2].lock

            promise.promise deferred

            func.call(deferred, deferred) if func

            deferred


        when: (subordinate) ->

            i = 0

            resolveValues = slice.call arguments
            length = resolveValues.length

            remaining = length isnt 1 or if jQuery.isFunction( subordinate?.promise ) then length 0

            deferred = if remaining is 1 then subordinate else jQuery.Deferred()

            updateFunc = (i, context, values) ->
                (value) ->
                    contexts[i] = this

                    values[i] = if arguments.length > 1 then slice.call(arguments) else value

                    if values = progressValues
                        deferred.notifyWith contexts, values

                    else if not (--remaining)
                        deferred.resolveWith contexts, values

            progressValues = progressContexts = resolveContexts = undefined


            if length > 1
                progressValues = new Array length
                progressContexts = new Array length
                resolveContexts = new Array length

                while i < length
                    if jQuery.isFunction resolveValues[i]?.promise
                        resolveValues[i].promise()
                            .done( updateFunc i, resolveContexts, resolveValues )
                            .progress updateFunc i, progressContexts, progressValues

                    else
                        --remaining

            if not remaining
                deferred.resolveWith resolveContexts, resolveValues


            deferred.promise()

    jQuery
