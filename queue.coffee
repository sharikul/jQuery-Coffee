define [
  './core'
  '/data/var/data_priv'
  './deferred'
  './callbacks'
  
], (jQuery, data_priv) ->

  jQuery.extend
  
    queue: (elem, type, data) ->
      
      queue = undefined
      
      if elem
        type = (type or 'fx') + 'queue'
        queue = data_priv.get elem, type
        
        if data
          if not queue or jQuery.isArray data
            queue = data_priv.access elem, type, jQuery.makeArray data
          
          else
            queue.push data
        
        queue or []
    
    dequeue: (elem, type) ->
    
      type = type or 'fx'
      
      queue = jQuery.queue elem, type
      startLength = queue.length
      fn = queue.shift()
      hooks = jQuery._queueHooks elem, type
      
      next = ->
        jQuery.dequeue elem, type
      
      if fn is 'inprogress'
        fn = queue.shift()
        startLength--
      
      if fn
        if type is 'fx'
          queue.unshift 'inprogress'
        
        delete hooks.stop
        fn.call elem, next, hooks
        
      
      if not startLength and hooks
        hooks.empty.fire()
    
    _queueHooks: (elem, type) ->
      
      key = "#{type}queueHooks"
      
      data_priv.get(elem, key) or data_priv.access elem, key
        empty: jQuery.Callbacks('once memory').add ->
          data_priv.remove elem, ["#{type}queue", key]
  
  
  jQuery.fn.extend
  
    queue: (type, data) ->
    
      setter = 2
      
      if typeof type isnt 'string'
        data = type
        type = 'fx'
        setter--
        
      if arguments.length < setter
        return jQuery.queue @[0], type
      
      if data is undefined 
      then this else @each ->
        queue = jQuery.queue this, type, data
        
        jQuery._queueHooks this, type
        
        if type is 'fx' and queue[0] isnt 'inprogress'
          jQuery.dequeue this, type
      
    dequeue: (type) ->
      @each ->
        jQuery.dequeue this, type
    
    clearQueue: (type) ->
      @queue type or 'fx', []
    
    promise: (type, obj) ->
      
      tmp = undefined
      count = 1
      defer = jQuery.Deferred()
      
      elements = this
      i = @length

      resolve = ->
        if not (--count)
          defer.resolveWith elements, [elements]
        
     
      if typeof type isnt 'string'
        obj = type
        type = undefined
    
      type = type or 'fx'
     
      while i--
        tmp = data_priv.get elements[i], "#{type}queueHooks"
      
        if tmp?.empty
          count++
          tmp.empty.add resolve
        
      resolve()
     
      defer.promise obj
  
  jQuery
      
