define ->

    addGetHookIf = (conditionFn, hookFn) ->

        return {
            get: ->
                delete @get if conditionFn()

                return

                (@get = hookFn).apply this, arguments
        }

    addGetHookIf