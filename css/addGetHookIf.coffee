define ->

    addGetHookIf = (conditionFn, hookFn) ->

        return {
            get: ->
                if conditionFn()
                    delete this.get

                    return

                (this.get = hookFn).apply this, arguments
        }

    addGetHookIf