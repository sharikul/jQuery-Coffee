
#!
# * Sizzle CSS Selector Engine v1.10.15
# * http://sizzlejs.com/
# *
# * Copyright 2013 jQuery Foundation, Inc. and other contributors
# * Released under the MIT license
# * http://jquery.org/license
# *
# * Date: 2013-12-20
# *
# 
((window) ->
  
  # Local document vars
  
  # Instance-specific data
  
  # General-purpose constants
  
  # Instance methods
  
  # Use a stripped-down indexOf if we can't use a native one
  
  # Regular expressions
  
  # Whitespace characters http://www.w3.org/TR/css3-selectors/#whitespace
  
  # http://www.w3.org/TR/css3-syntax/#characters
  
  # Loosely modeled on CSS identifier characters
  # An unquoted value should be a CSS identifier http://www.w3.org/TR/css3-selectors/#attribute-selectors
  # Proper syntax: http://www.w3.org/TR/CSS21/syndata.html#value-def-identifier
  
  # Acceptable operators http://www.w3.org/TR/selectors/#attribute-selectors
  
  # Prefer arguments quoted,
  #   then not containing pseudos/brackets,
  #   then attribute selectors/non-parenthetical expressions,
  #   then anything else
  # These preferences are here to reduce the number of selectors
  #   needing tokenize in the PSEUDO preFilter
  
  # Leading and non-escaped trailing whitespace, capturing some non-whitespace characters preceding the latter
  
  # For use in libraries implementing .is()
  # We use this for POS matching in `select`
  
  # Easily-parseable/retrievable ID or TAG or CLASS selectors
  
  # CSS escapes http://www.w3.org/TR/CSS21/syndata.html#escaped-characters
  
  # NaN means non-codepoint
  # Support: Firefox
  # Workaround erroneous numeric interpretation of +"0x"
  
  # BMP codepoint
  
  # Supplemental Plane codepoint (surrogate pair)
  
  # Optimize for push.apply( _, NodeList )
  
  # Support: Android<4.0
  # Detect silently failing push.apply
  
  # Leverage slice if possible
  
  # Support: IE<9
  # Otherwise append directly
  
  # Can't trust NodeList.length
  Sizzle = (selector, context, results, seed) ->
    match = undefined
    elem = undefined
    m = undefined
    nodeType = undefined
    i = undefined
    groups = undefined
    old = undefined
    nid = undefined
    newContext = undefined
    newSelector = undefined
    
    # QSA vars
    setDocument context  if ((if context then context.ownerDocument or context else preferredDoc)) isnt document
    context = context or document
    results = results or []
    return results  if not selector or typeof selector isnt "string"
    return []  if (nodeType = context.nodeType) isnt 1 and nodeType isnt 9
    if documentIsHTML and not seed
      
      # Shortcuts
      if match = rquickExpr.exec(selector)
        
        # Speed-up: Sizzle("#ID")
        if m = match[1]
          if nodeType is 9
            elem = context.getElementById(m)
            
            # Check parentNode to catch when Blackberry 4.6 returns
            # nodes that are no longer in the document (jQuery #6963)
            if elem and elem.parentNode
              
              # Handle the case where IE, Opera, and Webkit return items
              # by name instead of ID
              if elem.id is m
                results.push elem
                return results
            else
              return results
          else
            
            # Context is not a document
            if context.ownerDocument and (elem = context.ownerDocument.getElementById(m)) and contains(context, elem) and elem.id is m
              results.push elem
              return results
        
        # Speed-up: Sizzle("TAG")
        else if match[2]
          push.apply results, context.getElementsByTagName(selector)
          return results
        
        # Speed-up: Sizzle(".CLASS")
        else if (m = match[3]) and support.getElementsByClassName and context.getElementsByClassName
          push.apply results, context.getElementsByClassName(m)
          return results
      
      # QSA path
      if support.qsa and (not rbuggyQSA or not rbuggyQSA.test(selector))
        nid = old = expando
        newContext = context
        newSelector = nodeType is 9 and selector
        
        # qSA works strangely on Element-rooted queries
        # We can work around this by specifying an extra ID on the root
        # and working up from there (Thanks to Andrew Dupont for the technique)
        # IE 8 doesn't work on object elements
        if nodeType is 1 and context.nodeName.toLowerCase() isnt "object"
          groups = tokenize(selector)
          if old = context.getAttribute("id")
            nid = old.replace(rescape, "\\$&")
          else
            context.setAttribute "id", nid
          nid = "[id='" + nid + "'] "
          i = groups.length
          groups[i] = nid + toSelector(groups[i])  while i--
          newContext = rsibling.test(selector) and testContext(context.parentNode) or context
          newSelector = groups.join(",")
        if newSelector
          try
            push.apply results, newContext.querySelectorAll(newSelector)
            return results
          finally
            context.removeAttribute "id"  unless old
    
    # All others
    select selector.replace(rtrim, "$1"), context, results, seed
  
  ###
  Create key-value caches of limited size
  @returns {Function(string, Object)} Returns the Object data after storing it on itself with
  property name the (space-suffixed) string and (if the cache is larger than Expr.cacheLength)
  deleting the oldest entry
  ###
  createCache = ->
    cache = (key, value) ->
      
      # Use (key + " ") to avoid collision with native prototype properties (see Issue #157)
      
      # Only keep the most recent entries
      delete cache[keys.shift()]  if keys.push(key + " ") > Expr.cacheLength
      cache[key + " "] = value
    keys = []
    cache
  
  ###
  Mark a function for special use by Sizzle
  @param {Function} fn The function to mark
  ###
  markFunction = (fn) ->
    fn[expando] = true
    fn
  
  ###
  Support testing using an element
  @param {Function} fn Passed the created div and expects a boolean result
  ###
  assert = (fn) ->
    div = document.createElement("div")
    try
      return !!fn(div)
    catch e
      return false
    finally
      
      # Remove from its parent by default
      div.parentNode.removeChild div  if div.parentNode
      
      # release memory in IE
      div = null
  
  ###
  Adds the same handler for all of the specified attrs
  @param {String} attrs Pipe-separated list of attributes
  @param {Function} handler The method that will be applied
  ###
  addHandle = (attrs, handler) ->
    arr = attrs.split("|")
    i = attrs.length
    Expr.attrHandle[arr[i]] = handler  while i--
  
  ###
  Checks document order of two siblings
  @param {Element} a
  @param {Element} b
  @returns {Number} Returns less than 0 if a precedes b, greater than 0 if a follows b
  ###
  siblingCheck = (a, b) ->
    cur = b and a
    diff = cur and a.nodeType is 1 and b.nodeType is 1 and (~b.sourceIndex or MAX_NEGATIVE) - (~a.sourceIndex or MAX_NEGATIVE)
    
    # Use IE sourceIndex if available on both nodes
    return diff  if diff
    
    # Check if b follows a
    return -1  if cur is b  while (cur = cur.nextSibling)  if cur
    (if a then 1 else -1)
  
  ###
  Returns a function to use in pseudos for input types
  @param {String} type
  ###
  createInputPseudo = (type) ->
    (elem) ->
      name = elem.nodeName.toLowerCase()
      name is "input" and elem.type is type
  
  ###
  Returns a function to use in pseudos for buttons
  @param {String} type
  ###
  createButtonPseudo = (type) ->
    (elem) ->
      name = elem.nodeName.toLowerCase()
      (name is "input" or name is "button") and elem.type is type
  
  ###
  Returns a function to use in pseudos for positionals
  @param {Function} fn
  ###
  createPositionalPseudo = (fn) ->
    markFunction (argument) ->
      argument = +argument
      markFunction (seed, matches) ->
        j = undefined
        matchIndexes = fn([], seed.length, argument)
        i = matchIndexes.length
        
        # Match elements found at the specified indexes
        seed[j] = not (matches[j] = seed[j])  if seed[(j = matchIndexes[i])]  while i--


  
  ###
  Checks a node for validity as a Sizzle context
  @param {Element|Object=} context
  @returns {Element|Object|Boolean} The input node if acceptable, otherwise a falsy value
  ###
  testContext = (context) ->
    context and typeof context.getElementsByTagName isnt strundefined and context
  
  # Expose support vars for convenience
  
  ###
  Detects XML nodes
  @param {Element|Object} elem An element or a document
  @returns {Boolean} True iff elem is a non-HTML XML node
  ###
  
  # documentElement is verified for cases where it doesn't yet exist
  # (such as loading iframes in IE - #4833)
  
  ###
  Sets document-related variables once based on the current document
  @param {Element|Object} [doc] An element or document object to use to set the document
  @returns {Object} Returns the current document
  ###
  
  # If no document and documentElement is available, return
  
  # Set our document
  
  # Support tests
  
  # Support: IE>8
  # If iframe document is assigned to "document" variable and if iframe has been reloaded,
  # IE will throw "permission denied" error when accessing "document" variable, see jQuery #13936
  # IE6-8 do not support the defaultView property so parent will be undefined
  
  # IE11 does not have attachEvent, so all must suffer
  
  # Attributes
  # ---------------------------------------------------------------------- 
  
  # Support: IE<8
  # Verify that getAttribute really returns attributes and not properties (excepting IE8 booleans)
  
  # getElement(s)By*
  # ---------------------------------------------------------------------- 
  
  # Check if getElementsByTagName("*") returns only elements
  
  # Check if getElementsByClassName can be trusted
  
  # Support: Safari<4
  # Catch class over-caching
  
  # Support: Opera<10
  # Catch gEBCN failure to find non-leading classes
  
  # Support: IE<10
  # Check if getElementById returns elements by name
  # The broken getElementById methods don't pick up programatically-set names,
  # so use a roundabout getElementsByName test
  
  # ID find and filter
  
  # Check parentNode to catch when Blackberry 4.6 returns
  # nodes that are no longer in the document #6963
  
  # Support: IE6/7
  # getElementById is not reliable as a find shortcut
  
  # Tag
  
  # Filter out possible comments
  
  # Class
  
  # QSA/matchesSelector
  # ---------------------------------------------------------------------- 
  
  # QSA and matchesSelector support
  
  # matchesSelector(:active) reports false when true (IE9/Opera 11.5)
  
  # qSa(:focus) reports false when true (Chrome 21)
  # We allow this because of a bug in IE8/9 that throws an error
  # whenever `document.activeElement` is accessed on an iframe
  # So, we allow :focus to pass through QSA all the time to avoid the IE error
  # See http://bugs.jquery.com/ticket/13378
  
  # Build QSA regex
  # Regex strategy adopted from Diego Perini
  
  # Select is set to empty string on purpose
  # This is to test IE's treatment of not explicitly
  # setting a boolean content attribute,
  # since its presence should be enough
  # http://bugs.jquery.com/ticket/12359
  
  # Support: IE8, Opera 10-12
  # Nothing should be selected when empty strings follow ^= or $= or *=
  
  # Support: IE8
  # Boolean attributes and "value" are not treated correctly
  
  # Webkit/Opera - :checked should return selected option elements
  # http://www.w3.org/TR/2011/REC-css3-selectors-20110929/#checked
  # IE8 throws error here and will not see later tests
  
  # Support: Windows 8 Native Apps
  # The type and name attributes are restricted during .innerHTML assignment
  
  # Support: IE8
  # Enforce case-sensitivity of name attribute
  
  # FF 3.5 - :enabled/:disabled and hidden elements (hidden elements are still enabled)
  # IE8 throws error here and will not see later tests
  
  # Opera 10-11 does not throw on post-comma invalid pseudos
  
  # Check to see if it's possible to do matchesSelector
  # on a disconnected node (IE 9)
  
  # This should fail with an exception
  # Gecko does not error, returns false instead
  
  # Contains
  # ---------------------------------------------------------------------- 
  
  # Element contains another
  # Purposefully does not implement inclusive descendent
  # As in, an element does not contain itself
  
  # Sorting
  # ---------------------------------------------------------------------- 
  
  # Document order sorting
  
  # Flag for duplicate removal
  
  # Sort on method existence if only one input has compareDocumentPosition
  
  # Calculate position if both inputs belong to the same document
  
  # Otherwise we know they are disconnected
  
  # Disconnected nodes
  
  # Choose the first element that is related to our preferred document
  
  # Maintain original order
  
  # Exit early if the nodes are identical
  
  # Parentless nodes are either documents or disconnected
  
  # If the nodes are siblings, we can do a quick check
  
  # Otherwise we need full lists of their ancestors for comparison
  
  # Walk down the tree looking for a discrepancy
  
  # Do a sibling check if the nodes have a common ancestor
  
  # Otherwise nodes in our document sort first
  
  # Set document vars if needed
  
  # Make sure that attribute selectors are quoted
  
  # IE 9's matchesSelector returns false on disconnected nodes
  
  # As well, disconnected nodes are said to be in a document
  # fragment in IE 9
  
  # Set document vars if needed
  
  # Set document vars if needed
  
  # Don't get fooled by Object.prototype properties (jQuery #13807)
  
  ###
  Document sorting and removing duplicates
  @param {ArrayLike} results
  ###
  
  # Unless we *know* we can detect duplicates, assume their presence
  
  # Clear input after sorting to release objects
  # See https://github.com/jquery/sizzle/pull/225
  
  ###
  Utility function for retrieving the text value of an array of DOM nodes
  @param {Array|Element} elem
  ###
  
  # If no nodeType, this is expected to be an array
  
  # Do not traverse comment nodes
  
  # Use textContent for elements
  # innerText usage removed for consistency of new lines (jQuery #11153)
  
  # Traverse its children
  
  # Do not include comment or processing instruction nodes
  
  # Can be adjusted by the user
  
  # Move the given value to match[3] whether quoted or unquoted
  
  # matches from matchExpr["CHILD"]
  #             1 type (only|nth|...)
  #             2 what (child|of-type)
  #             3 argument (even|odd|\d*|\d*n([+-]\d+)?|...)
  #             4 xn-component of xn+y argument ([+-]?\d*n|)
  #             5 sign of xn-component
  #             6 x of xn-component
  #             7 sign of y-component
  #             8 y of y-component
  #         
  
  # nth-* requires argument
  
  # numeric x and y parameters for Expr.filter.CHILD
  # remember that false/true cast respectively to 0/1
  
  # other types prohibit arguments
  
  # Accept quoted arguments as-is
  
  # Strip excess characters from unquoted arguments
  
  # Get excess from tokenize (recursively)
  
  # advance to the next closing parenthesis
  
  # excess is a negative index
  
  # Return only captures needed by the pseudo filter method (type and argument)
  
  # Shortcut for :nth-*(n)
  
  # :(first|last|only)-(child|of-type)
  
  # Reverse direction for :only-* (if we haven't yet done so)
  
  # non-xml :nth-child(...) stores cache data on `parent`
  
  # Seek `elem` from a previously-cached index
  
  # Fallback to seeking `elem` from the start
  
  # When found, cache indexes on `parent` and break
  
  # Use previously-cached element index if available
  
  # xml :nth-child(...) or :nth-last-child(...) or :nth(-last)?-of-type(...)
  
  # Use the same loop as above to seek `elem` from the start
  
  # Cache the index of each encountered element
  
  # Incorporate the offset, then check against cycle size
  
  # pseudo-class names are case-insensitive
  # http://www.w3.org/TR/selectors/#pseudo-classes
  # Prioritize by case sensitivity in case custom pseudos are added with uppercase letters
  # Remember that setFilters inherits from pseudos
  
  # The user may use createPseudo to indicate that
  # arguments are needed to create the filter function
  # just as Sizzle does
  
  # But maintain support for old signatures
  
  # Potentially complex pseudos
  
  # Trim the selector passed to compile
  # to avoid treating leading and trailing
  # spaces as combinators
  
  # Match elements unmatched by `matcher`
  
  # "Whether an element is represented by a :lang() selector
  # is based solely on the element's language value
  # being equal to the identifier C,
  # or beginning with the identifier C immediately followed by "-".
  # The matching of C against the element's language value is performed case-insensitively.
  # The identifier C does not have to be a valid language name."
  # http://www.w3.org/TR/selectors/#lang-pseudo
  
  # lang value must be a valid identifier
  
  # Miscellaneous
  
  # Boolean properties
  
  # In CSS3, :checked should return both checked and selected elements
  # http://www.w3.org/TR/2011/REC-css3-selectors-20110929/#checked
  
  # Accessing this property makes selected-by-default
  # options in Safari work properly
  
  # Contents
  
  # http://www.w3.org/TR/selectors/#empty-pseudo
  # :empty is negated by element (1) or content nodes (text: 3; cdata: 4; entity ref: 5),
  #   but not by others (comment: 8; processing instruction: 7; etc.)
  # nodeType < 6 works because attributes (2) do not appear as children
  
  # Element/input types
  
  # Support: IE<8
  # New HTML5 attribute values (e.g., "search") appear with elem.type === "text"
  
  # Position-in-collection
  
  # Add button/input type pseudos
  
  # Easy API for creating new setFilters
  setFilters = ->
  tokenize = (selector, parseOnly) ->
    matched = undefined
    match = undefined
    tokens = undefined
    type = undefined
    soFar = undefined
    groups = undefined
    preFilters = undefined
    cached = tokenCache[selector + " "]
    return (if parseOnly then 0 else cached.slice(0))  if cached
    soFar = selector
    groups = []
    preFilters = Expr.preFilter
    while soFar
      
      # Comma and first run
      if not matched or (match = rcomma.exec(soFar))
        
        # Don't consume trailing commas as valid
        soFar = soFar.slice(match[0].length) or soFar  if match
        groups.push (tokens = [])
      matched = false
      
      # Combinators
      if match = rcombinators.exec(soFar)
        matched = match.shift()
        tokens.push
          value: matched
          
          # Cast descendant combinators to space
          type: match[0].replace(rtrim, " ")

        soFar = soFar.slice(matched.length)
      
      # Filters
      for type of Expr.filter
        if (match = matchExpr[type].exec(soFar)) and (not preFilters[type] or (match = preFilters[type](match)))
          matched = match.shift()
          tokens.push
            value: matched
            type: type
            matches: match

          soFar = soFar.slice(matched.length)
      break  unless matched
    
    # Return the length of the invalid excess
    # if we're just parsing
    # Otherwise, throw an error or return tokens
    
    # Cache the tokens
    (if parseOnly then soFar.length else (if soFar then Sizzle.error(selector) else tokenCache(selector, groups).slice(0)))
  toSelector = (tokens) ->
    i = 0
    len = tokens.length
    selector = ""
    while i < len
      selector += tokens[i].value
      i++
    selector
  addCombinator = (matcher, combinator, base) ->
    dir = combinator.dir
    checkNonElements = base and dir is "parentNode"
    doneName = done++
    
    # Check against closest ancestor/preceding element
    (if combinator.first then (elem, context, xml) ->
      return matcher(elem, context, xml)  if elem.nodeType is 1 or checkNonElements  while (elem = elem[dir])
     
     # Check against all ancestor/preceding elements
     else (elem, context, xml) ->
      data = undefined
      cache = undefined
      outerCache = undefined
      dirkey = dirruns + " " + doneName
      
      # We can't set arbitrary data on XML nodes, so they don't benefit from dir caching
      if xml
        return true  if matcher(elem, context, xml)  if elem.nodeType is 1 or checkNonElements  while (elem = elem[dir])
      else
        while (elem = elem[dir])
          if elem.nodeType is 1 or checkNonElements
            outerCache = elem[expando] or (elem[expando] = {})
            if (cache = outerCache[dir]) and cache[0] is dirkey
              return data is true  if (data = cache[1]) is true or data is cachedruns
            else
              cache = outerCache[dir] = [dirkey]
              cache[1] = matcher(elem, context, xml) or cachedruns
              return true  if cache[1] is true
    )
  elementMatcher = (matchers) ->
    (if matchers.length > 1 then (elem, context, xml) ->
      i = matchers.length
      return false  unless matchers[i](elem, context, xml)  while i--
      true
     else matchers[0])
  condense = (unmatched, map, filter, context, xml) ->
    elem = undefined
    newUnmatched = []
    i = 0
    len = unmatched.length
    mapped = map?
    while i < len
      if elem = unmatched[i]
        if not filter or filter(elem, context, xml)
          newUnmatched.push elem
          map.push i  if mapped
      i++
    newUnmatched
  setMatcher = (preFilter, selector, matcher, postFilter, postFinder, postSelector) ->
    postFilter = setMatcher(postFilter)  if postFilter and not postFilter[expando]
    postFinder = setMatcher(postFinder, postSelector)  if postFinder and not postFinder[expando]
    markFunction (seed, results, context, xml) ->
      temp = undefined
      i = undefined
      elem = undefined
      preMap = []
      postMap = []
      preexisting = results.length
      
      # Get initial elements from seed or context
      elems = seed or multipleContexts(selector or "*", (if context.nodeType then [context] else context), [])
      
      # Prefilter to get matcher input, preserving a map for seed-results synchronization
      matcherIn = (if preFilter and (seed or not selector) then condense(elems, preMap, preFilter, context, xml) else elems)
      
      # If we have a postFinder, or filtered seed, or non-seed postFilter or preexisting results,
      
      # ...intermediate processing is necessary
      
      # ...otherwise use results directly
      matcherOut = (if matcher then (if postFinder or ((if seed then preFilter else preexisting or postFilter)) then [] else results) else matcherIn)
      
      # Find primary matches
      matcher matcherIn, matcherOut, context, xml  if matcher
      
      # Apply postFilter
      if postFilter
        temp = condense(matcherOut, postMap)
        postFilter temp, [], context, xml
        
        # Un-match failing elements by moving them back to matcherIn
        i = temp.length
        matcherOut[postMap[i]] = not (matcherIn[postMap[i]] = elem)  if elem = temp[i]  while i--
      if seed
        if postFinder or preFilter
          if postFinder
            
            # Get the final matcherOut by condensing this intermediate into postFinder contexts
            temp = []
            i = matcherOut.length
            
            # Restore matcherIn since elem is not yet a final match
            temp.push (matcherIn[i] = elem)  if elem = matcherOut[i]  while i--
            postFinder null, (matcherOut = []), temp, xml
          
          # Move matched elements from seed to results to keep them synchronized
          i = matcherOut.length
          seed[temp] = not (results[temp] = elem)  if (elem = matcherOut[i]) and (temp = (if postFinder then indexOf.call(seed, elem) else preMap[i])) > -1  while i--
      
      # Add elements to results, through postFinder if defined
      else
        matcherOut = condense((if matcherOut is results then matcherOut.splice(preexisting, matcherOut.length) else matcherOut))
        if postFinder
          postFinder null, results, matcherOut, xml
        else
          push.apply results, matcherOut

  matcherFromTokens = (tokens) ->
    checkContext = undefined
    matcher = undefined
    j = undefined
    len = tokens.length
    leadingRelative = Expr.relative[tokens[0].type]
    implicitRelative = leadingRelative or Expr.relative[" "]
    i = (if leadingRelative then 1 else 0)
    
    # The foundational matcher ensures that elements are reachable from top-level context(s)
    matchContext = addCombinator((elem) ->
      elem is checkContext
    , implicitRelative, true)
    matchAnyContext = addCombinator((elem) ->
      indexOf.call(checkContext, elem) > -1
    , implicitRelative, true)
    matchers = [(elem, context, xml) ->
      (not leadingRelative and (xml or context isnt outermostContext)) or ((if (checkContext = context).nodeType then matchContext(elem, context, xml) else matchAnyContext(elem, context, xml)))
    ]
    while i < len
      if matcher = Expr.relative[tokens[i].type]
        matchers = [addCombinator(elementMatcher(matchers), matcher)]
      else
        matcher = Expr.filter[tokens[i].type].apply(null, tokens[i].matches)
        
        # Return special upon seeing a positional matcher
        if matcher[expando]
          
          # Find the next relative operator (if any) for proper handling
          j = ++i
          while j < len
            break  if Expr.relative[tokens[j].type]
            j++
          
          # If the preceding token was a descendant combinator, insert an implicit any-element `*`
          return setMatcher(i > 1 and elementMatcher(matchers), i > 1 and toSelector(tokens.slice(0, i - 1).concat(value: (if tokens[i - 2].type is " " then "*" else ""))).replace(rtrim, "$1"), matcher, i < j and matcherFromTokens(tokens.slice(i, j)), j < len and matcherFromTokens((tokens = tokens.slice(j))), j < len and toSelector(tokens))
        matchers.push matcher
      i++
    elementMatcher matchers
  matcherFromGroupMatchers = (elementMatchers, setMatchers) ->
    
    # A counter to specify which element is currently being matched
    matcherCachedRuns = 0
    bySet = setMatchers.length > 0
    byElement = elementMatchers.length > 0
    superMatcher = (seed, context, xml, results, outermost) ->
      elem = undefined
      j = undefined
      matcher = undefined
      matchedCount = 0
      i = "0"
      unmatched = seed and []
      setMatched = []
      contextBackup = outermostContext
      
      # We must always have either seed elements or outermost context
      elems = seed or byElement and Expr.find["TAG"]("*", outermost)
      
      # Use integer dirruns iff this is the outermost matcher
      dirrunsUnique = (dirruns += (if not contextBackup? then 1 else Math.random() or 0.1))
      len = elems.length
      if outermost
        outermostContext = context isnt document and context
        cachedruns = matcherCachedRuns
      
      # Add elements passing elementMatchers directly to results
      # Keep `i` a string if there are no elements so `matchedCount` will be "00" below
      # Support: IE<9, Safari
      # Tolerate NodeList properties (IE: "length"; Safari: <number>) matching elements by id
      while i isnt len and (elem = elems[i])?
        if byElement and elem
          j = 0
          while (matcher = elementMatchers[j++])
            if matcher(elem, context, xml)
              results.push elem
              break
          if outermost
            dirruns = dirrunsUnique
            cachedruns = ++matcherCachedRuns
        
        # Track unmatched elements for set filters
        if bySet
          
          # They will have gone through all possible matchers
          matchedCount--  if elem = not matcher and elem
          
          # Lengthen the array for every element, matched or not
          unmatched.push elem  if seed
        i++
      
      # Apply set filters to unmatched elements
      matchedCount += i
      if bySet and i isnt matchedCount
        j = 0
        matcher unmatched, setMatched, context, xml  while (matcher = setMatchers[j++])
        if seed
          
          # Reintegrate element matches to eliminate the need for sorting
          setMatched[i] = pop.call(results)  unless unmatched[i] or setMatched[i]  while i--  if matchedCount > 0
          
          # Discard index placeholder values to get only actual matches
          setMatched = condense(setMatched)
        
        # Add matches to results
        push.apply results, setMatched
        
        # Seedless set matches succeeding multiple successful matchers stipulate sorting
        Sizzle.uniqueSort results  if outermost and not seed and setMatched.length > 0 and (matchedCount + setMatchers.length) > 1
      
      # Override manipulation of globals by nested matchers
      if outermost
        dirruns = dirrunsUnique
        outermostContext = contextBackup
      unmatched

    (if bySet then markFunction(superMatcher) else superMatcher)
  # Internal Use Only 
  
  # Generate a function of recursive functions that can be used to check each element
  
  # Cache the compiled function
  multipleContexts = (selector, contexts, results) ->
    i = 0
    len = contexts.length
    while i < len
      Sizzle selector, contexts[i], results
      i++
    results
  select = (selector, context, results, seed) ->
    i = undefined
    tokens = undefined
    token = undefined
    type = undefined
    find = undefined
    match = tokenize(selector)
    unless seed
      
      # Try to minimize operations if there is only one group
      if match.length is 1
        
        # Take a shortcut and set the context if the root selector is an ID
        tokens = match[0] = match[0].slice(0)
        if tokens.length > 2 and (token = tokens[0]).type is "ID" and support.getById and context.nodeType is 9 and documentIsHTML and Expr.relative[tokens[1].type]
          context = (Expr.find["ID"](token.matches[0].replace(runescape, funescape), context) or [])[0]
          return results  unless context
          selector = selector.slice(tokens.shift().value.length)
        
        # Fetch a seed set for right-to-left matching
        i = (if matchExpr["needsContext"].test(selector) then 0 else tokens.length)
        while i--
          token = tokens[i]
          
          # Abort if we hit a combinator
          break  if Expr.relative[(type = token.type)]
          if find = Expr.find[type]
            
            # Search, expanding context for leading sibling combinators
            if seed = find(token.matches[0].replace(runescape, funescape), rsibling.test(tokens[0].type) and testContext(context.parentNode) or context)
              
              # If seed is empty or no tokens remain, we can return early
              tokens.splice i, 1
              selector = seed.length and toSelector(tokens)
              unless selector
                push.apply results, seed
                return results
              break
    
    # Compile and execute a filtering function
    # Provide `match` to avoid retokenization if we modified the selector above
    compile(selector, match) seed, context, not documentIsHTML, results, rsibling.test(selector) and testContext(context.parentNode) or context
    results
  i = undefined
  support = undefined
  cachedruns = undefined
  Expr = undefined
  getText = undefined
  isXML = undefined
  compile = undefined
  outermostContext = undefined
  sortInput = undefined
  hasDuplicate = undefined
  setDocument = undefined
  document = undefined
  docElem = undefined
  documentIsHTML = undefined
  rbuggyQSA = undefined
  rbuggyMatches = undefined
  matches = undefined
  contains = undefined
  expando = "sizzle" + -(new Date())
  preferredDoc = window.document
  dirruns = 0
  done = 0
  classCache = createCache()
  tokenCache = createCache()
  compilerCache = createCache()
  sortOrder = (a, b) ->
    hasDuplicate = true  if a is b
    0

  strundefined = typeof `undefined`
  MAX_NEGATIVE = 1 << 31
  hasOwn = ({}).hasOwnProperty
  arr = []
  pop = arr.pop
  push_native = arr.push
  push = arr.push
  slice = arr.slice
  indexOf = arr.indexOf or (elem) ->
    i = 0
    len = @length
    while i < len
      return i  if this[i] is elem
      i++
    -1

  booleans = "checked|selected|async|autofocus|autoplay|controls|defer|disabled|hidden|ismap|loop|multiple|open|readonly|required|scoped"
  whitespace = "[\\x20\\t\\r\\n\\f]"
  characterEncoding = "(?:\\\\.|[\\w-]|[^\\x00-\\xa0])+"
  identifier = characterEncoding.replace("w", "w#")
  attributes = "\\[" + whitespace + "*(" + characterEncoding + ")" + whitespace + "*(?:([*^$|!~]?=)" + whitespace + "*(?:(['\"])((?:\\\\.|[^\\\\])*?)\\3|(" + identifier + ")|)|)" + whitespace + "*\\]"
  pseudos = ":(" + characterEncoding + ")(?:\\(((['\"])((?:\\\\.|[^\\\\])*?)\\3|((?:\\\\.|[^\\\\()[\\]]|" + attributes.replace(3, 8) + ")*)|.*)\\)|)"
  rtrim = new RegExp("^" + whitespace + "+|((?:^|[^\\\\])(?:\\\\.)*)" + whitespace + "+$", "g")
  rcomma = new RegExp("^" + whitespace + "*," + whitespace + "*")
  rcombinators = new RegExp("^" + whitespace + "*([>+~]|" + whitespace + ")" + whitespace + "*")
  rattributeQuotes = new RegExp("=" + whitespace + "*([^\\]'\"]*?)" + whitespace + "*\\]", "g")
  rpseudo = new RegExp(pseudos)
  ridentifier = new RegExp("^" + identifier + "$")
  matchExpr =
    ID: new RegExp("^#(" + characterEncoding + ")")
    CLASS: new RegExp("^\\.(" + characterEncoding + ")")
    TAG: new RegExp("^(" + characterEncoding.replace("w", "w*") + ")")
    ATTR: new RegExp("^" + attributes)
    PSEUDO: new RegExp("^" + pseudos)
    CHILD: new RegExp("^:(only|first|last|nth|nth-last)-(child|of-type)(?:\\(" + whitespace + "*(even|odd|(([+-]|)(\\d*)n|)" + whitespace + "*(?:([+-]|)" + whitespace + "*(\\d+)|))" + whitespace + "*\\)|)", "i")
    bool: new RegExp("^(?:" + booleans + ")$", "i")
    needsContext: new RegExp("^" + whitespace + "*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\(" + whitespace + "*((?:-\\d)?\\d*)" + whitespace + "*\\)|)(?=[^-]|$)", "i")

  rinputs = /^(?:input|select|textarea|button)$/i
  rheader = /^h\d$/i
  rnative = /^[^{]+\{\s*\[native \w/
  rquickExpr = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/
  rsibling = /[+~]/
  rescape = /'|\\\\\/g
  runescape = new RegExp("\\\\([\\da-f]{1,6}" + whitespace + "?|(" + whitespace + ")|.)", "ig")
  funescape = (_, escaped, escapedWhitespace) ->
    high = "0x" + escaped - 0x10000
    (if high isnt high or escapedWhitespace then escaped else (if high < 0 then String.fromCharCode(high + 0x10000) else String.fromCharCode(high >> 10 | 0xD800, high & 0x3FF | 0xDC00)))

  try
    push.apply (arr = slice.call(preferredDoc.childNodes)), preferredDoc.childNodes
    arr[preferredDoc.childNodes.length].nodeType
  catch e
    push = apply: (if arr.length then (target, els) ->
      push_native.apply target, slice.call(els)
     else (target, els) ->
      j = target.length
      i = 0
      continue  while (target[j++] = els[i++])
      target.length = j - 1
    )
  support = Sizzle.support = {}
  isXML = Sizzle.isXML = (elem) ->
    documentElement = elem and (elem.ownerDocument or elem).documentElement
    (if documentElement then documentElement.nodeName isnt "HTML" else false)

  setDocument = Sizzle.setDocument = (node) ->
    hasCompare = undefined
    doc = (if node then node.ownerDocument or node else preferredDoc)
    parent = doc.defaultView
    return document  if doc is document or doc.nodeType isnt 9 or not doc.documentElement
    document = doc
    docElem = doc.documentElement
    documentIsHTML = not isXML(doc)
    if parent and parent isnt parent.top
      if parent.addEventListener
        parent.addEventListener "unload", (->
          setDocument()
        ), false
      else if parent.attachEvent
        parent.attachEvent "onunload", ->
          setDocument()

    support.attributes = assert((div) ->
      div.className = "i"
      not div.getAttribute("className")
    )
    support.getElementsByTagName = assert((div) ->
      div.appendChild doc.createComment("")
      not div.getElementsByTagName("*").length
    )
    support.getElementsByClassName = rnative.test(doc.getElementsByClassName) and assert((div) ->
      div.innerHTML = "<div class='a'></div><div class='a i'></div>"
      div.firstChild.className = "i"
      div.getElementsByClassName("i").length is 2
    )
    support.getById = assert((div) ->
      docElem.appendChild(div).id = expando
      not doc.getElementsByName or not doc.getElementsByName(expando).length
    )
    if support.getById
      Expr.find["ID"] = (id, context) ->
        if typeof context.getElementById isnt strundefined and documentIsHTML
          m = context.getElementById(id)
          (if m and m.parentNode then [m] else [])

      Expr.filter["ID"] = (id) ->
        attrId = id.replace(runescape, funescape)
        (elem) ->
          elem.getAttribute("id") is attrId
    else
      delete Expr.find["ID"]

      Expr.filter["ID"] = (id) ->
        attrId = id.replace(runescape, funescape)
        (elem) ->
          node = typeof elem.getAttributeNode isnt strundefined and elem.getAttributeNode("id")
          node and node.value is attrId
    Expr.find["TAG"] = (if support.getElementsByTagName then (tag, context) ->
      context.getElementsByTagName tag  if typeof context.getElementsByTagName isnt strundefined
     else (tag, context) ->
      elem = undefined
      tmp = []
      i = 0
      results = context.getElementsByTagName(tag)
      if tag is "*"
        tmp.push elem  if elem.nodeType is 1  while (elem = results[i++])
        return tmp
      results
    )
    Expr.find["CLASS"] = support.getElementsByClassName and (className, context) ->
      context.getElementsByClassName className  if typeof context.getElementsByClassName isnt strundefined and documentIsHTML

    rbuggyMatches = []
    rbuggyQSA = []
    if support.qsa = rnative.test(doc.querySelectorAll)
      assert (div) ->
        div.innerHTML = "<select t=''><option selected=''></option></select>"
        rbuggyQSA.push "[*^$]=" + whitespace + "*(?:''|\"\")"  if div.querySelectorAll("[t^='']").length
        rbuggyQSA.push "\\[" + whitespace + "*(?:value|" + booleans + ")"  unless div.querySelectorAll("[selected]").length
        rbuggyQSA.push ":checked"  unless div.querySelectorAll(":checked").length

      assert (div) ->
        input = doc.createElement("input")
        input.setAttribute "type", "hidden"
        div.appendChild(input).setAttribute "name", "D"
        rbuggyQSA.push "name" + whitespace + "*[*^$|!~]?="  if div.querySelectorAll("[name=d]").length
        rbuggyQSA.push ":enabled", ":disabled"  unless div.querySelectorAll(":enabled").length
        div.querySelectorAll "*,:x"
        rbuggyQSA.push ",.*:"

    if support.matchesSelector = rnative.test((matches = docElem.webkitMatchesSelector or docElem.mozMatchesSelector or docElem.oMatchesSelector or docElem.msMatchesSelector))
      assert (div) ->
        support.disconnectedMatch = matches.call(div, "div")
        matches.call div, "[s!='']:x"
        rbuggyMatches.push "!=", pseudos

    rbuggyQSA = rbuggyQSA.length and new RegExp(rbuggyQSA.join("|"))
    rbuggyMatches = rbuggyMatches.length and new RegExp(rbuggyMatches.join("|"))
    hasCompare = rnative.test(docElem.compareDocumentPosition)
    contains = (if hasCompare or rnative.test(docElem.contains) then (a, b) ->
      adown = (if a.nodeType is 9 then a.documentElement else a)
      bup = b and b.parentNode
      a is bup or !!(bup and bup.nodeType is 1 and ((if adown.contains then adown.contains(bup) else a.compareDocumentPosition and a.compareDocumentPosition(bup) & 16)))
     else (a, b) ->
      return true  if b is a  while (b = b.parentNode)  if b
      false
    )
    sortOrder = (if hasCompare then (a, b) ->
      if a is b
        hasDuplicate = true
        return 0
      compare = not a.compareDocumentPosition - not b.compareDocumentPosition
      return compare  if compare
      compare = (if (a.ownerDocument or a) is (b.ownerDocument or b) then a.compareDocumentPosition(b) else 1)
      if compare & 1 or (not support.sortDetached and b.compareDocumentPosition(a) is compare)
        return -1  if a is doc or a.ownerDocument is preferredDoc and contains(preferredDoc, a)
        return 1  if b is doc or b.ownerDocument is preferredDoc and contains(preferredDoc, b)
        return (if sortInput then (indexOf.call(sortInput, a) - indexOf.call(sortInput, b)) else 0)
      (if compare & 4 then -1 else 1)
     else (a, b) ->
      if a is b
        hasDuplicate = true
        return 0
      cur = undefined
      i = 0
      aup = a.parentNode
      bup = b.parentNode
      ap = [a]
      bp = [b]
      if not aup or not bup
        return (if a is doc then -1 else (if b is doc then 1 else (if aup then -1 else (if bup then 1 else (if sortInput then (indexOf.call(sortInput, a) - indexOf.call(sortInput, b)) else 0)))))
      else return siblingCheck(a, b)  if aup is bup
      cur = a
      ap.unshift cur  while (cur = cur.parentNode)
      cur = b
      bp.unshift cur  while (cur = cur.parentNode)
      i++  while ap[i] is bp[i]
      (if i then siblingCheck(ap[i], bp[i]) else (if ap[i] is preferredDoc then -1 else (if bp[i] is preferredDoc then 1 else 0)))
    )
    doc

  Sizzle.matches = (expr, elements) ->
    Sizzle expr, null, null, elements

  Sizzle.matchesSelector = (elem, expr) ->
    setDocument elem  if (elem.ownerDocument or elem) isnt document
    expr = expr.replace(rattributeQuotes, "='$1']")
    if support.matchesSelector and documentIsHTML and (not rbuggyMatches or not rbuggyMatches.test(expr)) and (not rbuggyQSA or not rbuggyQSA.test(expr))
      try
        ret = matches.call(elem, expr)
        return ret  if ret or support.disconnectedMatch or elem.document and elem.document.nodeType isnt 11
    Sizzle(expr, document, null, [elem]).length > 0

  Sizzle.contains = (context, elem) ->
    setDocument context  if (context.ownerDocument or context) isnt document
    contains context, elem

  Sizzle.attr = (elem, name) ->
    setDocument elem  if (elem.ownerDocument or elem) isnt document
    fn = Expr.attrHandle[name.toLowerCase()]
    val = (if fn and hasOwn.call(Expr.attrHandle, name.toLowerCase()) then fn(elem, name, not documentIsHTML) else `undefined`)
    (if val isnt `undefined` then val else (if support.attributes or not documentIsHTML then elem.getAttribute(name) else (if (val = elem.getAttributeNode(name)) and val.specified then val.value else null)))

  Sizzle.error = (msg) ->
    throw new Error("Syntax error, unrecognized expression: " + msg)

  Sizzle.uniqueSort = (results) ->
    elem = undefined
    duplicates = []
    j = 0
    i = 0
    hasDuplicate = not support.detectDuplicates
    sortInput = not support.sortStable and results.slice(0)
    results.sort sortOrder
    if hasDuplicate
      j = duplicates.push(i)  if elem is results[i]  while (elem = results[i++])
      results.splice duplicates[j], 1  while j--
    sortInput = null
    results

  getText = Sizzle.getText = (elem) ->
    node = undefined
    ret = ""
    i = 0
    nodeType = elem.nodeType
    unless nodeType
      ret += getText(node)  while (node = elem[i++])
    else if nodeType is 1 or nodeType is 9 or nodeType is 11
      if typeof elem.textContent is "string"
        return elem.textContent
      else
        elem = elem.firstChild
        while elem
          ret += getText(elem)
          elem = elem.nextSibling
    else return elem.nodeValue  if nodeType is 3 or nodeType is 4
    ret

  Expr = Sizzle.selectors =
    cacheLength: 50
    createPseudo: markFunction
    match: matchExpr
    attrHandle: {}
    find: {}
    relative:
      ">":
        dir: "parentNode"
        first: true

      " ":
        dir: "parentNode"

      "+":
        dir: "previousSibling"
        first: true

      "~":
        dir: "previousSibling"

    preFilter:
      ATTR: (match) ->
        match[1] = match[1].replace(runescape, funescape)
        match[3] = (match[4] or match[5] or "").replace(runescape, funescape)
        match[3] = " " + match[3] + " "  if match[2] is "~="
        match.slice 0, 4

      CHILD: (match) ->
        match[1] = match[1].toLowerCase()
        if match[1].slice(0, 3) is "nth"
          Sizzle.error match[0]  unless match[3]
          match[4] = +((if match[4] then match[5] + (match[6] or 1) else 2 * (match[3] is "even" or match[3] is "odd")))
          match[5] = +((match[7] + match[8]) or match[3] is "odd")
        else Sizzle.error match[0]  if match[3]
        match

      PSEUDO: (match) ->
        excess = undefined
        unquoted = not match[5] and match[2]
        return null  if matchExpr["CHILD"].test(match[0])
        if match[3] and match[4] isnt `undefined`
          match[2] = match[4]
        else if unquoted and rpseudo.test(unquoted) and (excess = tokenize(unquoted, true)) and (excess = unquoted.indexOf(")", unquoted.length - excess) - unquoted.length)
          match[0] = match[0].slice(0, excess)
          match[2] = unquoted.slice(0, excess)
        match.slice 0, 3

    filter:
      TAG: (nodeNameSelector) ->
        nodeName = nodeNameSelector.replace(runescape, funescape).toLowerCase()
        (if nodeNameSelector is "*" then ->
          true
         else (elem) ->
          elem.nodeName and elem.nodeName.toLowerCase() is nodeName
        )

      CLASS: (className) ->
        pattern = classCache[className + " "]
        pattern or (pattern = new RegExp("(^|" + whitespace + ")" + className + "(" + whitespace + "|$)")) and classCache(className, (elem) ->
          pattern.test typeof elem.className is "string" and elem.className or typeof elem.getAttribute isnt strundefined and elem.getAttribute("class") or ""
        )

      ATTR: (name, operator, check) ->
        (elem) ->
          result = Sizzle.attr(elem, name)
          return operator is "!="  unless result?
          return true  unless operator
          result += ""
          (if operator is "=" then result is check else (if operator is "!=" then result isnt check else (if operator is "^=" then check and result.indexOf(check) is 0 else (if operator is "*=" then check and result.indexOf(check) > -1 else (if operator is "$=" then check and result.slice(-check.length) is check else (if operator is "~=" then (" " + result + " ").indexOf(check) > -1 else (if operator is "|=" then result is check or result.slice(0, check.length + 1) is check + "-" else false)))))))

      CHILD: (type, what, argument, first, last) ->
        simple = type.slice(0, 3) isnt "nth"
        forward = type.slice(-4) isnt "last"
        ofType = what is "of-type"
        (if first is 1 and last is 0 then (elem) ->
          !!elem.parentNode
         else (elem, context, xml) ->
          cache = undefined
          outerCache = undefined
          node = undefined
          diff = undefined
          nodeIndex = undefined
          start = undefined
          dir = (if simple isnt forward then "nextSibling" else "previousSibling")
          parent = elem.parentNode
          name = ofType and elem.nodeName.toLowerCase()
          useCache = not xml and not ofType
          if parent
            if simple
              while dir
                node = elem
                return false  if (if ofType then node.nodeName.toLowerCase() is name else node.nodeType is 1)  while (node = node[dir])
                start = dir = type is "only" and not start and "nextSibling"
              return true
            start = [(if forward then parent.firstChild else parent.lastChild)]
            if forward and useCache
              outerCache = parent[expando] or (parent[expando] = {})
              cache = outerCache[type] or []
              nodeIndex = cache[0] is dirruns and cache[1]
              diff = cache[0] is dirruns and cache[2]
              node = nodeIndex and parent.childNodes[nodeIndex]
              while (node = ++nodeIndex and node and node[dir] or (diff = nodeIndex = 0) or start.pop())
                if node.nodeType is 1 and ++diff and node is elem
                  outerCache[type] = [dirruns, nodeIndex, diff]
                  break
            else if useCache and (cache = (elem[expando] or (elem[expando] = {}))[type]) and cache[0] is dirruns
              diff = cache[1]
            else
              while (node = ++nodeIndex and node and node[dir] or (diff = nodeIndex = 0) or start.pop())
                if ((if ofType then node.nodeName.toLowerCase() is name else node.nodeType is 1)) and ++diff
                  (node[expando] or (node[expando] = {}))[type] = [dirruns, diff]  if useCache
                  break  if node is elem
            diff -= last
            diff is first or (diff % first is 0 and diff / first >= 0)
        )

      PSEUDO: (pseudo, argument) ->
        args = undefined
        fn = Expr.pseudos[pseudo] or Expr.setFilters[pseudo.toLowerCase()] or Sizzle.error("unsupported pseudo: " + pseudo)
        return fn(argument)  if fn[expando]
        if fn.length > 1
          args = [pseudo, pseudo, "", argument]
          return (if Expr.setFilters.hasOwnProperty(pseudo.toLowerCase()) then markFunction((seed, matches) ->
            idx = undefined
            matched = fn(seed, argument)
            i = matched.length
            while i--
              idx = indexOf.call(seed, matched[i])
              seed[idx] = not (matches[idx] = matched[i])
          ) else (elem) ->
            fn elem, 0, args
          )
        fn

    pseudos:
      not: markFunction((selector) ->
        input = []
        results = []
        matcher = compile(selector.replace(rtrim, "$1"))
        (if matcher[expando] then markFunction((seed, matches, context, xml) ->
          elem = undefined
          unmatched = matcher(seed, null, xml, [])
          i = seed.length
          seed[i] = not (matches[i] = elem)  if elem = unmatched[i]  while i--
        ) else (elem, context, xml) ->
          input[0] = elem
          matcher input, null, xml, results
          not results.pop()
        )
      )
      has: markFunction((selector) ->
        (elem) ->
          Sizzle(selector, elem).length > 0
      )
      contains: markFunction((text) ->
        (elem) ->
          (elem.textContent or elem.innerText or getText(elem)).indexOf(text) > -1
      )
      lang: markFunction((lang) ->
        Sizzle.error "unsupported lang: " + lang  unless ridentifier.test(lang or "")
        lang = lang.replace(runescape, funescape).toLowerCase()
        (elem) ->
          elemLang = undefined
          loop
            if elemLang = (if documentIsHTML then elem.lang else elem.getAttribute("xml:lang") or elem.getAttribute("lang"))
              elemLang = elemLang.toLowerCase()
              return elemLang is lang or elemLang.indexOf(lang + "-") is 0
            break unless (elem = elem.parentNode) and elem.nodeType is 1
          false
      )
      target: (elem) ->
        hash = window.location and window.location.hash
        hash and hash.slice(1) is elem.id

      root: (elem) ->
        elem is docElem

      focus: (elem) ->
        elem is document.activeElement and (not document.hasFocus or document.hasFocus()) and !!(elem.type or elem.href or ~elem.tabIndex)

      enabled: (elem) ->
        elem.disabled is false

      disabled: (elem) ->
        elem.disabled is true

      checked: (elem) ->
        nodeName = elem.nodeName.toLowerCase()
        (nodeName is "input" and !!elem.checked) or (nodeName is "option" and !!elem.selected)

      selected: (elem) ->
        elem.parentNode.selectedIndex  if elem.parentNode
        elem.selected is true

      empty: (elem) ->
        elem = elem.firstChild
        while elem
          return false  if elem.nodeType < 6
          elem = elem.nextSibling
        true

      parent: (elem) ->
        not Expr.pseudos["empty"](elem)

      header: (elem) ->
        rheader.test elem.nodeName

      input: (elem) ->
        rinputs.test elem.nodeName

      button: (elem) ->
        name = elem.nodeName.toLowerCase()
        name is "input" and elem.type is "button" or name is "button"

      text: (elem) ->
        attr = undefined
        elem.nodeName.toLowerCase() is "input" and elem.type is "text" and (not (attr = elem.getAttribute("type"))? or attr.toLowerCase() is "text")

      first: createPositionalPseudo(->
        [0]
      )
      last: createPositionalPseudo((matchIndexes, length) ->
        [length - 1]
      )
      eq: createPositionalPseudo((matchIndexes, length, argument) ->
        [(if argument < 0 then argument + length else argument)]
      )
      even: createPositionalPseudo((matchIndexes, length) ->
        i = 0
        while i < length
          matchIndexes.push i
          i += 2
        matchIndexes
      )
      odd: createPositionalPseudo((matchIndexes, length) ->
        i = 1
        while i < length
          matchIndexes.push i
          i += 2
        matchIndexes
      )
      lt: createPositionalPseudo((matchIndexes, length, argument) ->
        i = (if argument < 0 then argument + length else argument)
        while --i >= 0
          matchIndexes.push i
        matchIndexes
      )
      gt: createPositionalPseudo((matchIndexes, length, argument) ->
        i = (if argument < 0 then argument + length else argument)
        while ++i < length
          matchIndexes.push i
        matchIndexes
      )

  Expr.pseudos["nth"] = Expr.pseudos["eq"]
  for i of
    radio: true
    checkbox: true
    file: true
    password: true
    image: true
    Expr.pseudos[i] = createInputPseudo(i)
  for i of
    submit: true
    reset: true
    Expr.pseudos[i] = createButtonPseudo(i)
  setFilters:: = Expr.filters = Expr.pseudos
  Expr.setFilters = new setFilters()
  compile = Sizzle.compile = (selector, group) ->
    i = undefined
    setMatchers = []
    elementMatchers = []
    cached = compilerCache[selector + " "]
    unless cached
      group = tokenize(selector)  unless group
      i = group.length
      while i--
        cached = matcherFromTokens(group[i])
        if cached[expando]
          setMatchers.push cached
        else
          elementMatchers.push cached
      cached = compilerCache(selector, matcherFromGroupMatchers(elementMatchers, setMatchers))
    cached

  
  # One-time assignments
  
  # Sort stability
  support.sortStable = expando.split("").sort(sortOrder).join("") is expando
  
  # Support: Chrome<14
  # Always assume duplicates if they aren't passed to the comparison function
  support.detectDuplicates = !!hasDuplicate
  
  # Initialize against the default document
  setDocument()
  
  # Support: Webkit<537.32 - Safari 6.0.3/Chrome 25 (fixed in Chrome 27)
  # Detached nodes confoundingly follow *each other*
  support.sortDetached = assert((div1) ->
    
    # Should return 1, but returns 4 (following)
    div1.compareDocumentPosition(document.createElement("div")) & 1
  )
  
  # Support: IE<8
  # Prevent attribute/property "interpolation"
  # http://msdn.microsoft.com/en-us/library/ms536429%28VS.85%29.aspx
  unless assert((div) ->
    div.innerHTML = "<a href='#'></a>"
    div.firstChild.getAttribute("href") is "#"
  )
    addHandle "type|href|height|width", (elem, name, isXML) ->
      elem.getAttribute name, (if name.toLowerCase() is "type" then 1 else 2)  unless isXML

  
  # Support: IE<9
  # Use defaultValue in place of getAttribute("value")
  if not support.attributes or not assert((div) ->
    div.innerHTML = "<input/>"
    div.firstChild.setAttribute "value", ""
    div.firstChild.getAttribute("value") is ""
  )
    addHandle "value", (elem, name, isXML) ->
      elem.defaultValue  if not isXML and elem.nodeName.toLowerCase() is "input"

  
  # Support: IE<9
  # Use getAttributeNode to fetch booleans when getAttribute lies
  unless assert((div) ->
    not div.getAttribute("disabled")?
  )
    addHandle booleans, (elem, name, isXML) ->
      val = undefined
      (if elem[name] is true then name.toLowerCase() else (if (val = elem.getAttributeNode(name)) and val.specified then val.value else null))  unless isXML

  
  # EXPOSE
  if typeof define is "function" and define.amd
    define ->
      Sizzle

  
  # Sizzle requires that there be a global window in Common-JS like environments
  else if typeof module isnt "undefined" and module.exports
    module.exports = Sizzle
  else
    window.Sizzle = Sizzle

# EXPOSE
) window