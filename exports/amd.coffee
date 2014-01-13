define [
    '../core'

], (jQuery) ->

    if typeof define is 'function' and define.amd
        define 'jquery', [], ->
            jQuery
        