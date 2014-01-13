define [
    '../core'

], (jQuery) ->

    jQuery.acceptData = (owner) ->

        owner.nodeType is 1 or owner.nodeType is 9 or not( +owner.nodeType )

    jQuery.acceptData