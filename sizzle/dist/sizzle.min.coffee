not (a) ->
  b = (a, b, c, d) ->
    e = undefined
    f = undefined
    g = undefined
    h = undefined
    i = undefined
    j = undefined
    l = undefined
    o = undefined
    p = undefined
    q = undefined
    return c  if (if b then b.ownerDocument or b else P) isnt H and G(b)
    b = b or H
    c = c or []
    not a or "string" isnt typeof a

    return []  if 1 isnt (h = b.nodeType) and 9 isnt h
    if J and not d
      if e = tb.exec(a)
        if g = e[1]
          if 9 is h
            return c  if f = b.getElementById(g)
            not f or not f.parentNode

            if f.id is g
              return c.push(f)
              c
          else if b.ownerDocument and (f = b.ownerDocument.getElementById(g)) and N(b, f) and f.id is g
            return c.push(f)
            c
        else
          if e[2]
            return ab.apply(c, b.getElementsByTagName(a))
            c
          if (g = e[3]) and x.getElementsByClassName and b.getElementsByClassName
            return ab.apply(c, b.getElementsByClassName(g))
            c
      if x.qsa and (not K or not K.test(a))
        if o = l = O
        p = b
        q = 9 is h and a
        1 is h and "object" isnt b.nodeName.toLowerCase()
          j = m(a)
          (if (l = b.getAttribute("id")) then o = l.replace(vb, "\\$&") else b.setAttribute("id", o))
          o = "[id='" + o + "'] "
          i = j.length

          while i--
            j[i] = o + n(j[i])
          p = ub.test(a) and k(b.parentNode) or b
          q = j.join(",")
        if q
          try
            return ab.apply(c, p.querySelectorAll(q))
            c
          finally
            l or b.removeAttribute("id")
    v a.replace(jb, "$1"), b, c, d
  c = ->
    a = (c, d) ->
      b.push(c + " ") > z.cacheLength and delete a[b.shift()]

      a[c + " "] = d
    b = []
    a
  d = (a) ->
    a[O] = not 0
    a
  e = (a) ->
    b = H.createElement("div")
    try
      return !!a(b)
    catch c
      return not 1
    finally
      b.parentNode and b.parentNode.removeChild(b)
      b = null
  f = (a, b) ->
    c = a.split("|")
    d = a.length

    while d--
      z.attrHandle[c[d]] = b
  g = (a, b) ->
    c = b and a
    d = c and 1 is a.nodeType and 1 is b.nodeType and (~b.sourceIndex or X) - (~a.sourceIndex or X)
    return d  if d
    if c
      while c = c.nextSibling
        return -1  if c is b
    (if a then 1 else -1)
  h = (a) ->
    (b) ->
      c = b.nodeName.toLowerCase()
      "input" is c and b.type is a
  i = (a) ->
    (b) ->
      c = b.nodeName.toLowerCase()
      ("input" is c or "button" is c) and b.type is a
  j = (a) ->
    d (b) ->
      b = +b
      d((c, d) ->
        e = undefined
        f = a([], c.length, b)
        g = f.length

        while g--
          c[e = f[g]] and (c[e] = not (d[e] = c[e]))
      )
  k = (a) ->
    a and typeof a.getElementsByTagName isnt W and a
  l = ->
  m = (a, c) ->
    d = undefined
    e = undefined
    f = undefined
    g = undefined
    h = undefined
    i = undefined
    j = undefined
    k = T[a + " "]
    return (if c then 0 else k.slice(0))  if k
    h = a
    i = []
    j = z.preFilter

    while h
      (not d or (e = kb.exec(h))) and (e and (h = h.slice(e[0].length) or h)
      i.push(f = [])
      )
      d = not 1
      (e = lb.exec(h)) and (d = e.shift()
      f.push(
        value: d
        type: e[0].replace(jb, " ")
      )
      h = h.slice(d.length)
      )

      for g of z.filter
        not (e = pb[g].exec(h)) or j[g] and not (e = j[g](e)) or (d = e.shift()
        f.push(
          value: d
          type: g
          matches: e
        )
        h = h.slice(d.length)
        )
      break  unless d
    (if c then h.length else (if h then b.error(a) else T(a, i).slice(0)))
  n = (a) ->
    b = 0
    c = a.length
    d = ""

    while c > b
      d += a[b].value
      b++
    d
  o = (a, b, c) ->
    d = b.dir
    e = c and "parentNode" is d
    f = R++
    (if b.first then (b, c, f) ->
      while b = b[d]
        return a(b, c, f)  if 1 is b.nodeType or e
     else (b, c, g) ->
      h = undefined
      i = undefined
      j = undefined
      k = Q + " " + f
      if g
        while b = b[d]
          return not 0  if (1 is b.nodeType or e) and a(b, c, g)
      else
        while b = b[d]
          if 1 is b.nodeType or e
            if j = b[O] or (b[O] = {})
            (i = j[d]) and i[0] is k
              return h is not 0  if (h = i[1]) is not 0 or h is y
            else return not 0  if i = j[d] = [ k ]
            i[1] = a(b, c, g) or y
            i[1] is not 0
    )
  p = (a) ->
    (if a.length > 1 then (b, c, d) ->
      e = a.length

      while e--
        return not 1  unless a[e](b, c, d)
      not 0
     else a[0])
  q = (a, b, c, d, e) ->
    f = undefined
    g = []
    h = 0
    i = a.length
    j = null isnt b

    while i > h
      (f = a[h]) and (not c or c(f, d, e)) and (g.push(f)
      j and b.push(h)
      )
      h++
    g
  r = (a, b, c, e, f, g) ->
    e and not e[O] and (e = r(e))
    f and not f[O] and (f = r(f, g))
    d((d, g, h, i) ->
      j = undefined
      k = undefined
      l = undefined
      m = []
      n = []
      o = g.length
      p = d or u(b or "*", (if h.nodeType then [ h ] else h), [])
      r = (if not a or not d and b then p else q(p, m, a, h, i))
      s = (if c then (if f or (if d then a else o or e) then [] else g) else r)
      if c and c(r, s, h, i)
      e
        j = q(s, n)
        e(j, [], h, i)
        k = j.length

        while k--
          (l = j[k]) and (s[n[k]] = not (r[n[k]] = l))
      if d
        if f or a
          if f
            j = []
            k = s.length

            while k--
              (l = s[k]) and j.push(r[k] = l)
            f null, s = [], j, i
          k = s.length
          while k--
            (l = s[k]) and (j = (if f then cb.call(d, l) else m[k])) > -1 and (d[j] = not (g[j] = l))
      else
        s = q((if s is g then s.splice(o, s.length) else s))
        (if f then f(null, g, s, i) else ab.apply(g, s))
    )
  s = (a) ->
    b = undefined
    c = undefined
    d = undefined
    e = a.length
    f = z.relative[a[0].type]
    g = f or z.relative[" "]
    h = (if f then 1 else 0)
    i = o((a) ->
      a is b
    , g, not 0)
    j = o((a) ->
      cb.call(b, a) > -1
    , g, not 0)
    k = [ (a, c, d) ->
      not f and (d or c isnt D) or (if (b = c).nodeType then i(a, c, d) else j(a, c, d))
     ]

    while e > h
      unless c = z.relative[a[h].type]
        if c = z.filter[a[h].type].apply(null, a[h].matches)
        c[O]
          d = ++h
          while e > d and not z.relative[a[d].type]
            d++
          return r(h > 1 and p(k), h > 1 and n(a.slice(0, h - 1).concat(value: (if " " is a[h - 2].type then "*" else ""))).replace(jb, "$1"), c, d > h and s(a.slice(h, d)), e > d and s(a = a.slice(d)), e > d and n(a))
        k.push c
      h++
    p k
  t = (a, c) ->
    e = 0
    f = c.length > 0
    g = a.length > 0
    h = (d, h, i, j, k) ->
      l = undefined
      m = undefined
      n = undefined
      o = 0
      p = "0"
      r = d and []
      s = []
      t = D
      u = d or g and z.find.TAG("*", k)
      v = Q += (if null is t then 1 else Math.random() or .1)
      w = u.length
      k and (D = h isnt H and h
      y = e
      )
      while p isnt w and null isnt (l = u[p])
        if g and l
          m = 0
          while n = a[m++]
            if n(l, h, i)
              j.push l
              break
          k and (Q = v
          y = ++e
          )
        f and ((l = not n and l) and o--
        d and r.push(l)
        )
        p++
      if o += p
      f and p isnt o
        m = 0
        while n = c[m++]
          n r, s, h, i
        if d
          if o > 0
            while p--
              r[p] or s[p] or (s[p] = $.call(j))
          s = q(s)
        ab.apply(j, s)
        k and not d and s.length > 0 and o + c.length > 1 and b.uniqueSort(j)
      k and (Q = v
      D = t
      )
      r

    (if f then d(h) else h)
  u = (a, c, d) ->
    e = 0
    f = c.length

    while f > e
      b a, c[e], d
      e++
    d
  v = (a, b, c, d) ->
    e = undefined
    f = undefined
    g = undefined
    h = undefined
    i = undefined
    j = m(a)
    if not d and 1 is j.length
      if f = j[0] = j[0].slice(0)
      f.length > 2 and "ID" is (g = f[0]).type and x.getById and 9 is b.nodeType and J and z.relative[f[1].type]
        return c  if b = (z.find.ID(g.matches[0].replace(wb, xb), b) or [])[0]
        not b

        a = a.slice(f.shift().value.length)
      e = (if pb.needsContext.test(a) then 0 else f.length)
      while e-- and (g = f[e]
      not z.relative[h = g.type]
      )
        if (i = z.find[h]) and (d = i(g.matches[0].replace(wb, xb), ub.test(f[0].type) and k(b.parentNode) or b))
          if f.splice(e, 1)
          a = d.length and n(f)
          not a
            return ab.apply(c, d)
            c
          break
    C(a, j)(d, b, not J, c, ub.test(a) and k(b.parentNode) or b)
    c
  w = undefined
  x = undefined
  y = undefined
  z = undefined
  A = undefined
  B = undefined
  C = undefined
  D = undefined
  E = undefined
  F = undefined
  G = undefined
  H = undefined
  I = undefined
  J = undefined
  K = undefined
  L = undefined
  M = undefined
  N = undefined
  O = "sizzle" + -new Date
  P = a.document
  Q = 0
  R = 0
  S = c()
  T = c()
  U = c()
  V = (a, b) ->
    a is b and (F = not 0)
    0

  W = typeof undefined
  X = 1 << 31
  Y = {}.hasOwnProperty
  Z = []
  $ = Z.pop
  _ = Z.push
  ab = Z.push
  bb = Z.slice
  cb = Z.indexOf or (a) ->
    b = 0
    c = @length

    while c > b
      return b  if this[b] is a
      b++
    -1

  db = "checked|selected|async|autofocus|autoplay|controls|defer|disabled|hidden|ismap|loop|multiple|open|readonly|required|scoped"
  eb = "[\\x20\\t\\r\\n\\f]"
  fb = "(?:\\\\.|[\\w-]|[^\\x00-\\xa0])+"
  gb = fb.replace("w", "w#")
  hb = "\\[" + eb + "*(" + fb + ")" + eb + "*(?:([*^$|!~]?=)" + eb + "*(?:(['\"])((?:\\\\.|[^\\\\])*?)\\3|(" + gb + ")|)|)" + eb + "*\\]"
  ib = ":(" + fb + ")(?:\\(((['\"])((?:\\\\.|[^\\\\])*?)\\3|((?:\\\\.|[^\\\\()[\\]]|" + hb.replace(3, 8) + ")*)|.*)\\)|)"
  jb = new RegExp("^" + eb + "+|((?:^|[^\\\\])(?:\\\\.)*)" + eb + "+$", "g")
  kb = new RegExp("^" + eb + "*," + eb + "*")
  lb = new RegExp("^" + eb + "*([>+~]|" + eb + ")" + eb + "*")
  mb = new RegExp("=" + eb + "*([^\\]'\"]*?)" + eb + "*\\]", "g")
  nb = new RegExp(ib)
  ob = new RegExp("^" + gb + "$")
  pb =
    ID: new RegExp("^#(" + fb + ")")
    CLASS: new RegExp("^\\.(" + fb + ")")
    TAG: new RegExp("^(" + fb.replace("w", "w*") + ")")
    ATTR: new RegExp("^" + hb)
    PSEUDO: new RegExp("^" + ib)
    CHILD: new RegExp("^:(only|first|last|nth|nth-last)-(child|of-type)(?:\\(" + eb + "*(even|odd|(([+-]|)(\\d*)n|)" + eb + "*(?:([+-]|)" + eb + "*(\\d+)|))" + eb + "*\\)|)", "i")
    bool: new RegExp("^(?:" + db + ")$", "i")
    needsContext: new RegExp("^" + eb + "*[>+~]|:(even|odd|eq|gt|lt|nth|first|last)(?:\\(" + eb + "*((?:-\\d)?\\d*)" + eb + "*\\)|)(?=[^-]|$)", "i")

  qb = /^(?:input|select|textarea|button)$/i
  rb = /^h\d$/i
  sb = /^[^{]+\{\s*\[native \w/
  tb = /^(?:#([\w-]+)|(\w+)|\.([\w-]+))$/
  ub = /[+~]/
  vb = /'|\\/g
  wb = new RegExp("\\\\([\\da-f]{1,6}" + eb + "?|(" + eb + ")|.)", "ig")
  xb = (a, b, c) ->
    d = "0x" + b - 65536
    (if d isnt d or c then b else (if 0 > d then String.fromCharCode(d + 65536) else String.fromCharCode(d >> 10 | 55296, 1023 & d | 56320)))

  try
    ab.apply(Z = bb.call(P.childNodes), P.childNodes)
    Z[P.childNodes.length].nodeType
  catch yb
    ab = apply: (if Z.length then (a, b) ->
      _.apply a, bb.call(b)
     else (a, b) ->
      c = a.length
      d = 0

      while a[c++] = b[d++]

      a.length = c - 1
    )
  x = b.support = {}
  B = b.isXML = (a) ->
    b = a and (a.ownerDocument or a).documentElement
    (if b then "HTML" isnt b.nodeName else not 1)

  G = b.setDocument = (a) ->
    b = undefined
    c = (if a then a.ownerDocument or a else P)
    d = c.defaultView
    (if c isnt H and 9 is c.nodeType and c.documentElement then (H = c
    I = c.documentElement
    J = not B(c)
    d and d isnt d.top and (if d.addEventListener then d.addEventListener("unload", ->
      G()
    , not 1) else d.attachEvent and d.attachEvent("onunload", ->
      G()
    ))
    x.attributes = e((a) ->
      a.className = "i"
      not a.getAttribute("className")
    )
    x.getElementsByTagName = e((a) ->
      a.appendChild(c.createComment(""))
      not a.getElementsByTagName("*").length
    )
    x.getElementsByClassName = sb.test(c.getElementsByClassName) and e((a) ->
      a.innerHTML = "<div class='a'></div><div class='a i'></div>"
      a.firstChild.className = "i"
      2 is a.getElementsByClassName("i").length
    )
    x.getById = e((a) ->
      I.appendChild(a).id = O
      not c.getElementsByName or not c.getElementsByName(O).length
    )
    (if x.getById then (z.find.ID = (a, b) ->
      if typeof b.getElementById isnt W and J
        c = b.getElementById(a)
        (if c and c.parentNode then [ c ] else [])

    z.filter.ID = (a) ->
      b = a.replace(wb, xb)
      (a) ->
        a.getAttribute("id") is b

    ) else (delete z.find.ID

    z.filter.ID = (a) ->
      b = a.replace(wb, xb)
      (a) ->
        c = typeof a.getAttributeNode isnt W and a.getAttributeNode("id")
        c and c.value is b

    ))
    z.find.TAG = (if x.getElementsByTagName then (a, b) ->
      (if typeof b.getElementsByTagName isnt W then b.getElementsByTagName(a) else undefined)
     else (a, b) ->
      c = undefined
      d = []
      e = 0
      f = b.getElementsByTagName(a)
      if "*" is a
        while c = f[e++]
          1 is c.nodeType and d.push(c)
        return d
      f
    )
    z.find.CLASS = x.getElementsByClassName and (a, b) ->
      (if typeof b.getElementsByClassName isnt W and J then b.getElementsByClassName(a) else undefined)

    L = []
    K = []
    (x.qsa = sb.test(c.querySelectorAll)) and (e((a) ->
      a.innerHTML = "<select t=''><option selected=''></option></select>"
      a.querySelectorAll("[t^='']").length and K.push("[*^$]=" + eb + "*(?:''|\"\")")
      a.querySelectorAll("[selected]").length or K.push("\\[" + eb + "*(?:value|" + db + ")")
      a.querySelectorAll(":checked").length or K.push(":checked")
    )
    e((a) ->
      b = c.createElement("input")
      b.setAttribute("type", "hidden")
      a.appendChild(b).setAttribute("name", "D")
      a.querySelectorAll("[name=d]").length and K.push("name" + eb + "*[*^$|!~]?=")
      a.querySelectorAll(":enabled").length or K.push(":enabled", ":disabled")
      a.querySelectorAll("*,:x")
      K.push(",.*:")
    )
    )
    (x.matchesSelector = sb.test(M = I.webkitMatchesSelector or I.mozMatchesSelector or I.oMatchesSelector or I.msMatchesSelector)) and e((a) ->
      x.disconnectedMatch = M.call(a, "div")
      M.call(a, "[s!='']:x")
      L.push("!=", ib)
    )
    K = K.length and new RegExp(K.join("|"))
    L = L.length and new RegExp(L.join("|"))
    b = sb.test(I.compareDocumentPosition)
    N = (if b or sb.test(I.contains) then (a, b) ->
      c = (if 9 is a.nodeType then a.documentElement else a)
      d = b and b.parentNode
      a is d or not (not d or 1 isnt d.nodeType or not (if c.contains then c.contains(d) else a.compareDocumentPosition and 16 & a.compareDocumentPosition(d)))
     else (a, b) ->
      if b
        while b = b.parentNode
          return not 0  if b is a
      not 1
    )
    V = (if b then (a, b) ->
      if a is b
        return F = not 0
        0
      d = not a.compareDocumentPosition - not b.compareDocumentPosition
      (if d then d else (d = (if (a.ownerDocument or a) is (b.ownerDocument or b) then a.compareDocumentPosition(b) else 1)
      (if 1 & d or not x.sortDetached and b.compareDocumentPosition(a) is d then (if a is c or a.ownerDocument is P and N(P, a) then -1 else (if b is c or b.ownerDocument is P and N(P, b) then 1 else (if E then cb.call(E, a) - cb.call(E, b) else 0))) else (if 4 & d then -1 else 1))
      ))
     else (a, b) ->
      if a is b
        return F = not 0
        0
      d = undefined
      e = 0
      f = a.parentNode
      h = b.parentNode
      i = [ a ]
      j = [ b ]
      return (if a is c then -1 else (if b is c then 1 else (if f then -1 else (if h then 1 else (if E then cb.call(E, a) - cb.call(E, b) else 0)))))  if not f or not h
      return g(a, b)  if f is h
      d = a
      while d = d.parentNode
        i.unshift d
      d = b
      while d = d.parentNode
        j.unshift d
      while i[e] is j[e]
        e++
      (if e then g(i[e], j[e]) else (if i[e] is P then -1 else (if j[e] is P then 1 else 0)))
    )
    c
    ) else H)

  b.matches = (a, c) ->
    b a, null, null, c

  b.matchesSelector = (a, c) ->
    if (a.ownerDocument or a) isnt H and G(a)
    c = c.replace(mb, "='$1']")
    not (not x.matchesSelector or not J or L and L.test(c) or K and K.test(c))
      try
        d = M.call(a, c)
        return d  if d or x.disconnectedMatch or a.document and 11 isnt a.document.nodeType
    b(c, H, null, [ a ]).length > 0

  b.contains = (a, b) ->
    (a.ownerDocument or a) isnt H and G(a)
    N(a, b)

  b.attr = (a, b) ->
    (a.ownerDocument or a) isnt H and G(a)
    c = z.attrHandle[b.toLowerCase()]
    d = (if c and Y.call(z.attrHandle, b.toLowerCase()) then c(a, b, not J) else undefined)
    (if undefined isnt d then d else (if x.attributes or not J then a.getAttribute(b) else (if (d = a.getAttributeNode(b)) and d.specified then d.value else null)))

  b.error = (a) ->
    throw new Error("Syntax error, unrecognized expression: " + a)

  b.uniqueSort = (a) ->
    b = undefined
    c = []
    d = 0
    e = 0
    if F = not x.detectDuplicates
    E = not x.sortStable and a.slice(0)
    a.sort(V)
    F
      while b = a[e++]
        b is a[e] and (d = c.push(e))
      while d--
        a.splice c[d], 1
    E = null
    a

  A = b.getText = (a) ->
    b = undefined
    c = ""
    d = 0
    e = a.nodeType
    if e
      if 1 is e or 9 is e or 11 is e
        return a.textContent  if "string" is typeof a.textContent
        a = a.firstChild
        while a
          c += A(a)
          a = a.nextSibling
      else return a.nodeValue  if 3 is e or 4 is e
    else
      while b = a[d++]
        c += A(b)
    c

  z = b.selectors =
    cacheLength: 50
    createPseudo: d
    match: pb
    attrHandle: {}
    find: {}
    relative:
      ">":
        dir: "parentNode"
        first: not 0

      " ":
        dir: "parentNode"

      "+":
        dir: "previousSibling"
        first: not 0

      "~":
        dir: "previousSibling"

    preFilter:
      ATTR: (a) ->
        a[1] = a[1].replace(wb, xb)
        a[3] = (a[4] or a[5] or "").replace(wb, xb)
        "~=" is a[2] and (a[3] = " " + a[3] + " ")
        a.slice(0, 4)

      CHILD: (a) ->
        a[1] = a[1].toLowerCase()
        (if "nth" is a[1].slice(0, 3) then (a[3] or b.error(a[0])
        a[4] = +(if a[4] then a[5] + (a[6] or 1) else 2 * ("even" is a[3] or "odd" is a[3]))
        a[5] = +(a[7] + a[8] or "odd" is a[3])
        ) else a[3] and b.error(a[0]))
        a

      PSEUDO: (a) ->
        b = undefined
        c = not a[5] and a[2]
        (if pb.CHILD.test(a[0]) then null else ((if a[3] and undefined isnt a[4] then a[2] = a[4] else c and nb.test(c) and (b = m(c, not 0)) and (b = c.indexOf(")", c.length - b) - c.length) and (a[0] = a[0].slice(0, b)
        a[2] = c.slice(0, b)
        ))
        a.slice(0, 3)
        ))

    filter:
      TAG: (a) ->
        b = a.replace(wb, xb).toLowerCase()
        (if "*" is a then ->
          not 0
         else (a) ->
          a.nodeName and a.nodeName.toLowerCase() is b
        )

      CLASS: (a) ->
        b = S[a + " "]
        b or (b = new RegExp("(^|" + eb + ")" + a + "(" + eb + "|$)")) and S(a, (a) ->
          b.test "string" is typeof a.className and a.className or typeof a.getAttribute isnt W and a.getAttribute("class") or ""
        )

      ATTR: (a, c, d) ->
        (e) ->
          f = b.attr(e, a)
          (if null is f then "!=" is c else (if c then (f += ""
          (if "=" is c then f is d else (if "!=" is c then f isnt d else (if "^=" is c then d and 0 is f.indexOf(d) else (if "*=" is c then d and f.indexOf(d) > -1 else (if "$=" is c then d and f.slice(-d.length) is d else (if "~=" is c then (" " + f + " ").indexOf(d) > -1 else (if "|=" is c then f is d or f.slice(0, d.length + 1) is d + "-" else not 1)))))))
          ) else not 0))

      CHILD: (a, b, c, d, e) ->
        f = "nth" isnt a.slice(0, 3)
        g = "last" isnt a.slice(-4)
        h = "of-type" is b
        (if 1 is d and 0 is e then (a) ->
          !!a.parentNode
         else (b, c, i) ->
          j = undefined
          k = undefined
          l = undefined
          m = undefined
          n = undefined
          o = undefined
          p = (if f isnt g then "nextSibling" else "previousSibling")
          q = b.parentNode
          r = h and b.nodeName.toLowerCase()
          s = not i and not h
          if q
            if f
              while p
                l = b
                while l = l[p]
                  return not 1  if (if h then l.nodeName.toLowerCase() is r else 1 is l.nodeType)
                o = p = "only" is a and not o and "nextSibling"
              return not 0
            if o = [ (if g then q.firstChild else q.lastChild) ]
            g and s
              k = q[O] or (q[O] = {})
              j = k[a] or []
              n = j[0] is Q and j[1]
              m = j[0] is Q and j[2]
              l = n and q.childNodes[n]

              while l = ++n and l and l[p] or (m = n = 0) or o.pop()
                if 1 is l.nodeType and ++m and l is b
                  k[a] = [ Q, n, m ]
                  break
            else if s and (j = (b[O] or (b[O] = {}))[a]) and j[0] is Q
              m = j[1]
            else
              while (l = ++n and l and l[p] or (m = n = 0) or o.pop()) and (if h then l.nodeName.toLowerCase() isnt r else 1 isnt l.nodeType) or not ++m or (s and ((l[O] or (l[O] = {}))[a] = [ Q, m ])
              l isnt b
              )
            m -= e
            m is d or m % d is 0 and m / d >= 0
        )

      PSEUDO: (a, c) ->
        e = undefined
        f = z.pseudos[a] or z.setFilters[a.toLowerCase()] or b.error("unsupported pseudo: " + a)
        (if f[O] then f(c) else (if f.length > 1 then (e = [ a, a, "", c ]
        (if z.setFilters.hasOwnProperty(a.toLowerCase()) then d((a, b) ->
          d = undefined
          e = f(a, c)
          g = e.length

          while g--
            d = cb.call(a, e[g])
            a[d] = not (b[d] = e[g])
        ) else (a) ->
          f a, 0, e
        )
        ) else f))

    pseudos:
      not: d((a) ->
        b = []
        c = []
        e = C(a.replace(jb, "$1"))
        (if e[O] then d((a, b, c, d) ->
          f = undefined
          g = e(a, null, d, [])
          h = a.length

          while h--
            (f = g[h]) and (a[h] = not (b[h] = f))
        ) else (a, d, f) ->
          b[0] = a
          e(b, null, f, c)
          not c.pop()
        )
      )
      has: d((a) ->
        (c) ->
          b(a, c).length > 0
      )
      contains: d((a) ->
        (b) ->
          (b.textContent or b.innerText or A(b)).indexOf(a) > -1
      )
      lang: d((a) ->
        ob.test(a or "") or b.error("unsupported lang: " + a)
        a = a.replace(wb, xb).toLowerCase()
        (b) ->
          c = undefined
          loop
            if c = (if J then b.lang else b.getAttribute("xml:lang") or b.getAttribute("lang"))
              return c = c.toLowerCase()
              c is a or 0 is c.indexOf(a + "-")
            break unless (b = b.parentNode) and 1 is b.nodeType
          not 1
      )
      target: (b) ->
        c = a.location and a.location.hash
        c and c.slice(1) is b.id

      root: (a) ->
        a is I

      focus: (a) ->
        a is H.activeElement and (not H.hasFocus or H.hasFocus()) and !!(a.type or a.href or ~a.tabIndex)

      enabled: (a) ->
        a.disabled is not 1

      disabled: (a) ->
        a.disabled is not 0

      checked: (a) ->
        b = a.nodeName.toLowerCase()
        "input" is b and !!a.checked or "option" is b and !!a.selected

      selected: (a) ->
        a.parentNode and a.parentNode.selectedIndex
        a.selected is not 0

      empty: (a) ->
        a = a.firstChild
        while a
          return not 1  if a.nodeType < 6
          a = a.nextSibling
        not 0

      parent: (a) ->
        not z.pseudos.empty(a)

      header: (a) ->
        rb.test a.nodeName

      input: (a) ->
        qb.test a.nodeName

      button: (a) ->
        b = a.nodeName.toLowerCase()
        "input" is b and "button" is a.type or "button" is b

      text: (a) ->
        b = undefined
        "input" is a.nodeName.toLowerCase() and "text" is a.type and (null is (b = a.getAttribute("type")) or "text" is b.toLowerCase())

      first: j(->
        [ 0 ]
      )
      last: j((a, b) ->
        [ b - 1 ]
      )
      eq: j((a, b, c) ->
        [ (if 0 > c then c + b else c) ]
      )
      even: j((a, b) ->
        c = 0

        while b > c
          a.push c
          c += 2
        a
      )
      odd: j((a, b) ->
        c = 1

        while b > c
          a.push c
          c += 2
        a
      )
      lt: j((a, b, c) ->
        d = (if 0 > c then c + b else c)

        while --d >= 0
          a.push d
        a
      )
      gt: j((a, b, c) ->
        d = (if 0 > c then c + b else c)

        while ++d < b
          a.push d
        a
      )

  z.pseudos.nth = z.pseudos.eq

  for w of
    radio: not 0
    checkbox: not 0
    file: not 0
    password: not 0
    image: not 0
    z.pseudos[w] = h(w)
  for w of
    submit: not 0
    reset: not 0
    z.pseudos[w] = i(w)
  l:: = z.filters = z.pseudos
  z.setFilters = new l
  C = b.compile = (a, b) ->
    c = undefined
    d = []
    e = []
    f = U[a + " "]
    unless f
      b or (b = m(a))
      c = b.length

      while c--
        f = s(b[c])
        (if f[O] then d.push(f) else e.push(f))
      f = U(a, t(e, d))
    f

  x.sortStable = O.split("").sort(V).join("") is O
  x.detectDuplicates = !!F
  G()
  x.sortDetached = e((a) ->
    1 & a.compareDocumentPosition(H.createElement("div"))
  )
  e((a) ->
    a.innerHTML = "<a href='#'></a>"
    "#" is a.firstChild.getAttribute("href")
  ) or f("type|href|height|width", (a, b, c) ->
    (if c then undefined else a.getAttribute(b, (if "type" is b.toLowerCase() then 1 else 2)))
  )
  x.attributes and e((a) ->
    a.innerHTML = "<input/>"
    a.firstChild.setAttribute("value", "")
    "" is a.firstChild.getAttribute("value")
  ) or f("value", (a, b, c) ->
    (if c or "input" isnt a.nodeName.toLowerCase() then undefined else a.defaultValue)
  )
  e((a) ->
    null is a.getAttribute("disabled")
  ) or f(db, (a, b, c) ->
    d = undefined
    (if c then undefined else (if a[b] is not 0 then b.toLowerCase() else (if (d = a.getAttributeNode(b)) and d.specified then d.value else null)))
  )
  (if "function" is typeof define and define.amd then define(->
    b
  ) else (if "undefined" isnt typeof module and module.exports then module.exports = b else a.Sizzle = b))
(window)