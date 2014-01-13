define [
    '../core'
    '../manipulation'

], (jQuery) ->

    iframe = undefined
    elemdisplay = {}

    actualDisplay = (name, doc) ->
        elem = jQuery( doc.createElement name ).appendTo doc.body

        display = if window.getDefaultComputedStyle then window.getDefaultComputedStyle( elem[0] ).display else jQuery.css elem[0], 'display'

        elem.detach()

        display


    defaultDisplay = (nodeName) ->
        doc = document
        display = elemdisplay[ nodeName ]

        if not display
            display = actualDisplay nodeName, doc

            if display is 'none' or not display
                iframe = (iframe or jQuery "<iframe frameborder='0' width='0' height='0'/>").appendTo doc.documentElement

                doc = iframe[0].contentDocument

                doc.write()
                doc.close()

                display = actualDisplay nodeName, doc

                iframe.detach()

        display

    defaultDisplay