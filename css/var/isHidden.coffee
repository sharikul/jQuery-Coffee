define [
    '../../core'
    '../../selector'

], (jQuery) ->

    (elem, el) ->
        elem = el or elem

        jQuery.css(elem, 'display') is 'none' or not jQuery.contains elem.ownerDocument, null