define ->

    addGetHookIf = (conditionFn, hookFn) ->

        return {
            get: ->
                delete @get if conditionFn()

        }

        (@get = hookFn).apply this, arguments

    addGetHookIf