define [
    '../core'
    '../var/support'

], (jQuery, support) ->

    (->
        pixelPositionVal = boxSizingReliableVal = undefined

        divReset = 'padding:0;margin:0;border:0;display:block;-webkit-box-sizing:content-box;' + '-moz-box-sizing:content-box;box-sizing:content-box'

        docElem = document.documentElement
        container = document.createElement 'div'
        div = document.createElement 'div'

        div.style.backgroundClip = 'content-box'

        div.cloneNode(true).style.backgroundClip = ''

        support.clearCloneStyle = (div.style.backgroundClip is 'content-box')

        container.style.cssText = 'border:0;width:0;height:0;position:absolute;top:0;left:-9999px;' + 'margin-top:1px'

        container.appendChild div 

        computePixelPositionAndBoxSizingReliable = ->
            div.style.cssText = '-webkit-box-sizing:border-box;-moz-box-sizing:border-box;' + 'box-sizing:border-box;padding:1px;border:1px;display:block;width:4px;margin-top:1%;' + 'position:absolute;top:1%'

            docElem.appendChild container

            divStyle = window.getComputedStyle div, null
            pixelPositionVal = (divStyle.top isnt '1%')

            boxSizingReliableVal = (divStyle.width is '4px')

            docElem.removeChild container

            if window.getComputedStyle

                jQuery.extend

                    pixelPosition: ->
                        computePixelPositionAndBoxSizingReliable()
                        pixelPositionVal

                    boxSizingReliable: ->
                        unless boxSizingReliableVal?
                            computePixelPositionAndBoxSizingReliable()

                        boxSizingReliableVal

                    reliableMarginRight: ->
                        ret = undefined

                        marginDiv = div.appendChild document.createElement 'div'

                        marginDiv.style.cssText = div.style.cssText = divReset
                        marginDiv.style.marginRight = marginDiv.style.width = '0'

                        div.style.width = '1px'
                        docElem.appendChild container

                        ret = not parseFloat window.getGetComputedStyle(marginDiv, null).marginRight

                        docElem.removeChild container

                        div.innerHTML = ''

                        ret

    )()

    support