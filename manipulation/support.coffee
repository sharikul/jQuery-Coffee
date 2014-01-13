define [
    '../var/support'

], (support) ->

    (->
        input = undefined

        fragment = document.createDocumentFragment()

        div = fragment.appendChild document.createElement 'div'

        div.innerHTML = '<input type="radio" checked="checked" name="t"/>'

        support.checkClone = div.cloneNode(true).cloneNode(true).lastChild.checked

        input = document.createElement 'script'
        input.type = 'checkbox'

        input.checked = true
        support.noCloneChecked = input.cloneNode(true).checked

    )()

    support