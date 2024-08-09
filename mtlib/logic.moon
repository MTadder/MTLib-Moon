import p from require([[moon.all]]) -- Moonscript Standard library
import Types from require([[mtlib.constants]])

NOP =()->nil
isCallable = (value)->
	if (type(value) == Types.FUNC) then return (true)
	if mt = getmetatable(value) then
		return (mt.__call != nil) and (type(mt.__call) == Types.FUNC)
	(false)
deepCopy = (value)->
	if (type(value) != Types.TABLE) then return (value)
	if (#value == 0) then return ({})
	(setmetatable({k,v for k,v in pairs value}, getmetatable(value)))
-- export combine = (t1, t2)->
-- 	if ((t1 == nil) or (t2 == nil)) then return ((t1 or t2) or nil)
-- 	if ((type(t1) == Types.TABLE) and (type(t1) == type(t2))) then
-- 		r = _deepCopy(t1)
-- 		for k,v in pairs(t2) do r[k] = v
-- 		return r
-- 	else return (t1 + t2)
isInstanceOf = (value, of)->
    if (value == class) then return true
    if (type(value) != Types.TABLE) then return (false)
    if (value.__class != nil) then
        val_class = value.__class
        if (of.__class != nil) then
            of_class = of.__class
            return (val_class.__name == of_class.__name)
        return (val_class.__name == of)
    (false)
isAncestor =(value, of)->
	if (value == nil or of == nil) then return (false)
	if (value.__parent) then
		if (type(of) == Types.STRING) then return (value.__parent.__name == of)
		if (of.__class) then
			if (value.__parent == of.__class) then return (true)
			if (value.__parent.__name == of.__class.__name) then return (true)
			else return (isAncestor(value.__parent, of))
	(false)
are =(tbl, of)->
	for _,v in pairs(tbl) do if ((type(v) == of) == false) then return (false)
	(true)
areAncestors =(tableOfValues, ofClass)->
	for _,v in pairs(tableOfValues) do
        if (isAncestor(v, ofClass) == false) then return (false)
	(true)
newArray =(count, fillWith)-> ([(fillWith or 0) for i=1, count])
class List
    new: (ofItems)=>
        error!
        @Items = {k,v for k,v in pairs(ofItems)} --_deepCopy(ofItems or {})
    combine: (withTbl)=>
        if (type(withTbl) == type.TABLE) then
            for k,v in pairs(withTbl) do @add(v, k)
    __tostring:=> p(@Items, ', ')
    __len:=> #@Items
    __add: (v1, v2)->
        if (type(v1) != type.TABLE) then return (v2\add(v1))
        elseif (type(v2) != type.TABLE) then return (v1\add(v2))
        if (v1.__name == 'List') then
            if (v2.__name == 'List') then
                for k,v in pairs(v2.Items) do v1\add(v, k)
                return (v1)
            else
                v2L = List(v2)
                return (v1 + v2L)
        elseif (v2.__name == 'List') then
            v1L = List(v1)
            return (v1L + v2)
        (nil)
    __index: (k)=> (@Items[k] or nil)
    contains: (value, atKey)=>
        if (atKey != nil) then
            if v = @Items[atKey] then
                return (value == v)
        else for _,v in pairs(@Items) do
            if (v == value) then return (true)
        (false)
    removeAt: (idx)=>
        @Items[idx] = nil
        (@Items[idx] == nil)
    remove: (item)=>
        for k,v in pairs(@Items) do
            if (v == item) then
                @Items[k] = nil
                return (true)
        (false)
    forEach: (doFunc, iterations=1)=>
        for k,v in pairs(@Items) do
            for i=1, iterations do
                @Items[k] = (doFunc(v, i, k) or v)
        (nil)
    add: (v, k)=>
        k = (k or (#@Items+1))
        @Items[k] = deepCopy(v)
        @Top = @Items[k]
        (nil)
    topKey:=>
        lK = nil
        for k,_ in pairs(@Items) do lK = k
        (lK)
    top:=>
        if (@Top != nil) then return (@Top)
        (@Items[@topKey!] or nil)
    pop: (atKey)=>
        table.remove(@Items, (atKey or #@Items))
class Timer
    update: (dT)=>
        now = os.clock!
        love = (love or nil)
        if (love != nil) then dT = (dT or love.timer.getDelta!)
        else dT = (dT or (now-(@last_update or now)))
        @Remainder -= dT
        @last_update = now
        if (@Remainder <= 0) then
            if (@Looping == true) then @restart!
            @On_Completion!
            return (true)
        (false)
    isComplete:=> ((@Remainder <= 0) and (@Looping == false))
    restart:=>
        @Remainder = @Duration
        (@)
    new: (duration, on_complete, looping=false)=>
        @Duration, @Looping = duration, looping
        @last_update = os.clock!
        @On_Completion = (on_complete or NOP)
        @restart!
        (@)

{
    :isCallable, :deepCopy, :isInstanceOf,
    :are, :areAncestors, :newArray,
    :Timer
}