define [
    '../core'

], (jQuery) ->

    jQuery.parseXML = (data) ->

        xml = tmp = undefined

        if not data or typeof data isnt 'string'
            return null

        try
            tmp = new DOMParser()
            xml = tmp.parseFromString data, 'text/xml'
        catch e
            xml = undefined


        if not xml or xml.getElementsByTagName('parsererror').length
            jQuery.error "Invalid XML: #{data}"

        xml

    jQuery.parseXML
        