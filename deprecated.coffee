define [
    './core'
    './traversing'

], (jQuery) ->

    jQuery.fn.size = ->
        @length

    jQuery.fn.andSelf = jQuery.fn.addBack