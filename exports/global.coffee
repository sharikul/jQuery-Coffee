define [
    '../core'
    '../var/strundefined'

], (jQuery, strundefined) ->

    _jQuery = window.jQuery

    _$ = window.$

    jQuery.noConflict = (deep) ->

        window.$ = _$ if window.$ is jQuery

        window.jQuery = _jQuery if deep and window.jQuery is jQuery

        jQuery

    if typeof noGlobal is strundefined
        window.jQuery = window.$ = jQuery