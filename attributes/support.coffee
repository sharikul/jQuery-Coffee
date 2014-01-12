define [
    '../var/support'

], (support) ->

    (->
        input = document.createElement 'input'
        select = document.createElement 'select'

        opt = select.appendChild document.createElement 'option'

        input.type = 'checkbox'

        support.checkOn = input.value isnt ''

        support.optSelected = opt.selected

        select.disabled = true
        support.optDisabled = !opt.disabled

        input = document.createElement 'input'
        input.value = 't'
        input.type = 'radio'
        support.radioValue = input.value is 't'

    )()

    support