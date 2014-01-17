define ->

    addGetHookIf = (conditionFn, hookFn) ->

        {
            get: ->
                delete @get if conditionFn()

        }

        (@get = hookFn).apply this, arguments

    addGetHookIf