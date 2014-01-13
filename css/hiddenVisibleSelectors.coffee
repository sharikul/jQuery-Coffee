define [
    '../core'
    '../selector'

], (jQuery) ->

    jQuery.expr.filters.hidden = (elem) ->
        elem.offsetWidth <= 0 and elem.offsetHeight <= 0

    jQuery.expr.filters.visible = (elem) ->
        not jQuery.expr.filters.hidden elem