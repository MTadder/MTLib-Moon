TODO = [[TODO]]
NEEDS_TESTING = [[ needs testing. Use at your own risk.]]

-- TYPE ALIASES
TYPE_TABLE = [[table]]
TYPE_FUNC = [[function]]
TYPE_STRING = [[string]]
TYPE_NIL = [[nil]]
TYPE_BOOL = [[boolean]]
TYPE_USERDATA = [[userdata]]
TYPE_THREAD = [[thread]]
TYPE_NUMBER = [[number]]

-- @logic
_nop = ()-> (nil)
_isCallable = (obj)->
	if (type(obj) == TYPE_FUNC) then return (true)
	if mt = getmetatable(obj) then
		return (mt.__call != nil) and (type(mt.__call) == TYPE_FUNC)
	(false)
_copy = (obj)->
	print('copy'..NEEDS_TESTING)
	if (type(obj) != TYPE_TABLE) then return (obj)
	if (#obj == 0) then return ({})
	(setmetatable({k,v for k,v in pairs obj}, getmetatable(obj)))
_combine = (t1, t2)->
	if ((t1 == nil) or (t2 == nil)) then return ((t1 or t2) or nil)
	if ((type(t1) == TYPE_TABLE) and (type(t1) == type(t2))) then
		r = _copy(t1)
		for k,v in pairs(t2) do r[k] = v
		return r
	else return (t1 + t2)
_is = (val, ofClass)->
	if ((val != nil) and (ofClass != nil)) then
		if (type(val) != TYPE_TABLE) then return (false)
		if (val.__class != nil) then
			if (ofClass.__class != nil) then
				return (val.__class.__name == ofClass.__class.__name)
			return (val.__class.__name == ofClass)
	(false)
_isAncestor =(val, ofClass)->
	if (val == nil or ofClass == nil) then return (false)
	if (val.__parent) then
		if (type(ofClass) == TYPE_STRING) then return (val.__parent.__name == ofClass)
		if (ofClass.__class) then
			if (val.__parent == ofClass.__class) then return (true)
			if (val.__parent.__name == ofClass.__class.__name) then return (true)
			else return (_isAncestor(val.__parent, ofClass))
	(false)
_are =(tbl, ofClass)->
	for i,v in pairs(tbl) do if (_is(v, ofClass) == false) then return (false)
	(true)
_areAncestors =(tbl, ofClass)->
	for i,v in pairs(tbl) do if (_isAncestor(v, ofClass) == false) then return (false)
	(true)
_newArray =(count, fillWith)-> ([(fillWith or 0) for i=1, count])

-- @string
class UUID
	generate=()->
		fn=(x)->
			r = (math.random(16)-1)
			r = ((x == 'x') and (r+1) or (r%4)+9)
			return ("0123456789abcdef"\sub(r, r))
		("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"\gsub("[xy]", fn))
	new: (uuid=nil)=>
		print('UUID'..NEEDS_TESTING)
		@value = uuid or generate!
	__tostring:=>
		return @value or error!
	isUUID: (value)=>
		if (type(value) != TYPE_STRING) then return (false)
		(#({value\match("^(.+)-(.+)-(.+)-(.+)-(.+)$")}) == 5)
_getAddress=(f, l)->
	if ((l == nil) and (type(f) == TYPE_FUNC)) then l = true
	return ("#{((l and '0x') or '')}#{(tostring(f)\gsub('%a*:%s*0?', '')\upper!)}")
_serialize=(v, max_recursion=4, iteration=0)->
	tokens = {
		[TYPE_NIL]: ()-> ('nil')
		[TYPE_BOOL]: (b)-> ("#{b}"\lower!)
		[TYPE_STRING]: (s)-> string.format('%q', s)
		[TYPE_USERDATA]: (u)-> ("UserData @ #{_getAddress(u)}")
		[TYPE_FUNC]: (f)-> ("Function @ #{_getAddress(f)}")
		[TYPE_THREAD]: (t)-> ("Thread @ #{_getAddress(t)}")
		[TYPE_NUMBER]: (num)->
			huge = (math.huge or (1/0))
			if (num != num) then return ('NaN')
			if (num == huge) then return ('INF')
			if (num > huge) then return ('INF+')
			if (num == -huge) then return ('-INF')
			if ((num > 9999) or (num < -9999)) then return ("0x#{string.format("%x", num)\upper!}")
			else return string.format('%d', num)
		[TYPE_TABLE]: (t, s={})->
			rtn = {}
			s[t] = true
			for k,m in pairs(t) do
				if (s[m] == true) then rtn[((#rtn)+1)] = ("...")
				else rtn[((#rtn)+1)] = ("[#{_serialize(k, s)}] = #{_serialize(m, s)}")
			s[t] = nil
			return ("{#{table.concat(rtn, ', ')}}")
	}
	(tokens[type(v)](v))

class List -- TODO
	new: (ofItems)=>
		error(TODO)
		@Items = {k,v for k,v in pairs(ofItems)} --_copy(ofItems or {})
	combine: (withTbl)=>
		if (type(withTbl) == TYPE_TABLE) then
			for k,v in pairs(withTbl) do @add(v, k)
	__tostring:=> _serialize(@Items, ', ')
	__len:=> #@Items
	__add: (v1, v2)->
		if (type(v1) != TYPE_TABLE) then return (v2\add(v1))
		elseif (type(v2) != TYPE_TABLE) then return (v1\add(v2))
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
		@Items[k] = _copy(v)
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
		@On_Completion = (on_complete or _nop)
		@restart!
		(@)
-- @io
_fileExists =(filename)->
	ioF = io.open(filename, 'r+')
	result = (ioF != nil)
	if result then ioF\close!
	(result)
_fileLines =(filename)->
	if not(_fileExists filename) then return {}
	([line for line in io.lines(filename)])
class FileToucher
	new: (file_name, mode)=>
		assert(file_name, "no file name")
		@file_name = file_name
		@file_stream = io.open(file_name, mode or 'rw')
		(@)
	isValid:=> (@file_stream != nil)
	exists:=>
		assert(@file_name, "no file name")
		(_fileExists(@file_name))
	write: (data)=>
		assert(data, "no data for write")
		assert(@isValid!, "invalid file stream")
		@file_stream\write data
		(@)
	read: (what)=>
		assert(@isValid!, "invalid file stream")
		(@file_stream\read (what or "*all"))
	close:=>
		if @isValid! then @file_stream\close!
		(@)

-- Mathematics
_clamp =(v, l=0, u=1)-> math.max(l, math.min(v, u))
_sign =(v)-> (v < 0 and -1 or 1)
_sigmoid =(v)-> (1/(1+math.exp(-v)))
_dist =(x, y, x2, y2)-> math.abs(math.sqrt(math.pow(x2-x, 2)+math.pow(y2-y, 2)))
_angleBetween =(x, y, x2, y2)-> math.abs(math.atan2(y2-y,x2-x))
_invLerp =(a, b, d)-> ((d-a)/(b-a))
_cerp =(a, b, d)->
	pi = (math.pi or 3.1415)
	f = (1-math.cos(d*pi)*0.5)
	(a*(1-f)+(b*f))
_lerp =(a, b, d)-> (a+(b-a)*_clamp(d)) -- (a*(1-d)+b*d) -- a + (b - a) * clamp(amount, 0, 1)
_smooth =(a, b, d)->
	t = _clamp(d)
	m = t*t*(3-2*t)
	(a+(b-a)*m)
_pingPong =(x)-> (1-math.abs(1-x%2))
_isWithinRegion =(x, y, oX, oY, lX, lY)-> ((x > oX and y < lX) and (y > oY and y < lY))
_isWithinCircle =(x, y, oX, oY, oR)-> (_dist(x, y, oX, oY) < oR)
-- _intersects =(o1x, o1y, e1x, e1y, o2x, o2y, e2x, e2y)-> TODO
-- 	-- adapted from https://gist.github.com/Joncom/e8e8d18ebe7fe55c3894
-- 	s1x, s1y = (e1x-o1x), (e1y-o1y)
-- 	s2x, s2y = (e2x-o2x), (e2y-o2y)
-- 	s = (-s1y*(o1x-o2x)+s1x*(o1y-o2y))/(-s2x*s1y+s1x*s2y)
-- 	t =  (s2x*(o1y-o2y)-s2y*(o1x-o2x))/(-s2x*s1y+s1x*s2y)
-- 	((s >= 0) and (s <= 1) and (t >= 0) and (t <= 1))
class Dyad
	lerp: (o, d, d1)=>
		if _is(o, 'Dyad') then
			@Position.x = _lerp(@Position.x, o.Position.x, tonumber(d))
			@Position.y = _lerp(@Position.y, o.Position.y, tonumber(d))
		elseif (type(o) == TYPE_NUMBER) then
			@Position.x = _lerp(@Position.x, o, d1)
			@Position.x = _lerp(@Position.y, d, d1)
		(@)
	get:=> (@Position.x), (@Position.y)
	equals: (o, o2)=>
		if (o == nil) then return (false)
		elseif ((type(o) != TYPE_TABLE) and (o2 == nil)) then return (false)
		elseif _is(o, 'Dyad') then
			return ((@Position.x == o.Position.x) and (@Position.y == o.Position.y))
		elseif ((type(o2) == TYPE_NUMBER) and (o != nil)) then
			return ((@Position.x == o) and (@Position.y == o2))
		(false)
	distance: (o=0, o2=0)=>
		if ((type(o) == TYPE_NUMBER) and (type(o2) == TYPE_NUMBER)) then
			return _dist(@Position.x, @Position.y, o, o2)
		if _is(o, 'Dyad') then
			return @distance(o.Position.x, o.Position.y)
		(nil)
	__tostring:=> ("D{#{@Position.x}, #{@Position.y}}")
	set: (x, y)=>
		@Position or= {}
		@Position.x, @Position.y = tonumber(x or 0), tonumber(y or 0)
		(@)
	__call: (x, y)=> @set(x, y)
	new: (x, y)=> @(x, y)
class Tetrad extends Dyad
	lerp: (o, d)=>
		if _is(o, 'Tetrad') then
			super\lerp(o, d)
			@Velocity.x = _lerp(@Velocity.x, o.Position.x, tonumber(d))
			@Velocity.y = _lerp(@Velocity.y, o.Position.y, tonumber(d))
		(@)
	distance: (o)=> (super\distance(o))
	set: (x, y, xV, yV)=>
		super\set(x, y)
		@Velocity or= {}
		@Velocity.x, @Velocity.y = tonumber(xV or 0), tonumber(yV or 0)
	get:=> unpack({
		@Position.x, @Position.y,
		@Velocity.x, @Velocity.y })
	update: (dT=(1/60))=>
		@Position.x += (@Velocity.x*dT)
		@Position.y += (@Velocity.y*dT)
	impulse: (angle, force)=>
		v = (math.cos(angle)*force)
		@Velocity.x += v
		@Velocity.y += v
	__tostring:=> ("T{#{@Velocity.x}, #{@Velocity.y}, #{super.__tostring(@)}}")
	__call: (x, y, xV, yV)=>
		@set(x, y, xV, yV)
		(@)
	new: (x, y, xV, yV)=> @(x, y, xV, yV)
class Hexad extends Tetrad
	new: (x, y, xV, yV, r, rV)=> (@set(x, y, xV, yV, r, rV))
	set: (x, y, xV, yV, r, rV)=>
		super\set(x, y, xV, yV)
		@Rotator or= {}
		@Rotator.value, @Rotator.inertia = tonumber(r or 0), tonumber(rV or 0)
		(@)
	get:=> unpack({
		@Position.x, @Position.y,
		@Velocity.x, @Velocity.y,
		@Rotator.value, @Rotator.inertia })
	update: (dT=(1/60))=>
		super\update(dT)
		@Rotator.value += (@Rotator.inertia*dT)
		(@)
	torque: (by)=>
		@Rotator.inertia += tonumber(by)
		(@)
	__tostring:=> ("H{#{@Rotator.value}, #{@Rotator.inertia}, #{super.__tostring(@)}}")
class Octad extends Hexad
	new: (x, y, xV, yV, r, rV, dA, dE)=> (@set(x, y, xV, yV, r, rV, dA, dE))
	set: (x, y, xV, yV, r, rV, dA, dE)=>
		super\set(x, y, xV, yV, r, rV)
		@Dimensional or= {}
		@Dimensional.address, @Dimensional.entropy = tonumber(dA or 0), tonumber(dE or 0)
		(@)
	get:=> unpack({
		@Position.x, @Position.y,
		@Velocity.x, @Velocity.y,
		@Rotator.value, @Rotator.inertia,
		@Dimensional.address, @Dimensional.entropy })
	shake: (by)=> @Dimensional.entropy += tonumber(by)
	update: (dT=(1/60))=>
		super\update(dT)
		@Dimensional.address += (@Dimensional.entropy*dT)
		(@)
	__tostring:=> ("O{#{@Dimensional.address}, #{@Dimensional.entropy}, #{super.__tostring(@)}}")
class Shape
	new: (oX, oY)=>
		print('Shape'..NEEDS_TESTING)
		(@set(oX, oY))
	set: (oX, oY)=>
		@Origin or= Dyad(tonumber(oX or 0), tonumber(oY or 0))
		(@)
	__tostring:=> ("S{#{tostring(@Origin)}}")
class Circle extends Shape
	set: (oX, oY, radi)=>
		super\set(oX, oY)
		@Radius = tonumber(radi or math.pi)
		(@)
	draw: (mode)=>
		love = (love or nil)
		if (love == nil) then error('missing LOVE2D!')
		love.graphics.circle(mode, @Origin.x, @Origin.y, @Radius)
		(@)
	__tostring:=> ("C{#{@Radius}, #{super.__tostring(@)}}")
	new: (x, y, rad)=> (@set(x, y, rad))
class Line extends Shape
	new: (oX, oY, eX, eY)=> (@set(oX, oY, eX, eY))
	set: (oX, oY, eX, eY)=>
		super\set(oX, oY)
		@Ending = Dyad(eX, eY)
		(@)
	get:=> unpack({
		@Origin.Position.x, @Origin.Position.y,
		@Ending.Position.x, @Ending.Position.x })
	distance: (o, o2)=> error(TODO)
	getLength:=>
		sOX, sOY = @Origin\get!
		sEX, sEY = @Ending\get!
		(math.sqrt(math.pow(sEX-sOX, 2)+math.pow(sEY-sOY, 2)))
	getSlope:=> ((@Ending.Position.x-@Origin.Position.x)/(@Ending.Position.y-@Origin.Position.y))
	intersects: (o)=>
		error(TODO)
		-- if _is(o, 'Dyad') then
		-- 	sOX, sOY, sEX, sEY = @get!
		-- 	oPX, oPY = o\get!
		-- 	slope = @getSlope!
		-- 	return ((slope*sOX+oPX == 0) or (slope*sEX+sPY == 0))
		-- elseif _is(o, 'Line') then
		-- 	sOX, sOY, sEX, sEY = @get!
		-- 	oOX, oOY, oEX, oEY = o\get!
		-- 	if (_intersects(sOX, sOY, sEX, sEY, oOX, oOY, oEX, oEY)) then return (true)
		-- elseif _is(o, 'Rectangle') then
		-- 	if (o\contains(@Origin) or o\contains(@Ending)) then return (true)
		-- 	for i,l in ipairs(o\getLines!) do if (@intersects(l)) then return (true)
	__tostring:=> ("[{#{tostring(@Origin)}}-(#{@getLength!})->{#{tostring(@Ending)}}]")
class Rectangle extends Shape
	new: (oX, oY, lX, lY)=> (@set(oX, oY, lX, lY))
	set: (oX, oY, lX, lY)=>
		super\set(oX, oY)
		@Limits or= Dyad(lX, lY)
		(@)
	get:=> unpack({
		@Origin.Position.x, @Origin.Position.y,
		@Limits.Position.x, @Limits.Position.y })
	area:=> (@Limits.Position.x*@Limits.Position.y)
	perimeter:=> ((2*(@Limits.Position.x))+(2*(@Limits.Position.y)))
	diagonal:=> math.sqrt(((@Limits.Position.x)^2)+((@Limits.Position.y)^2))
	contains: (o)=>
		if _is(o, 'Dyad') then
			sOX, sOY, sLX, sLY = @get!
			oPX, oPY = o\get!
			return _isWithinRegion(oPX, oPY, sOX, sOY, sLX, sLY)
		elseif _is(o, 'Line') then return (@contains(o.Origin) and @contains(o.Ending))
		elseif _is(o, 'Rectangle') then
			for i,l in ipairs(o\getLines!) do
				if (@contains(l) == false) then return (false)
			return (true)
		(nil)
	render:=>
		sOX, sOY, sLX, sLY = @get!
		({ sOX, sOY, sOX, sLY,
			sOX, sLY, sLX, sLY,
			sLX, sLY, sLX, sOY,
			sLX, sOY, sOX, sOY })
	getLines:=>
		sOX, sOY, sLX, sLY = @get!
		({ Line(sOX, sOY, sOX, sLY),
			Line(sOX, sLY, sLX, sLY),
			Line(sLX, sLY, sLX, sOY),
			Line(sLX, sOY, sOX, sOY) })
class Polygon extends Shape

MTLibrary = {
	__NAME: [[MTLibrary]]
	__AUTHOR: [[MTadder@duck.com]]
	__LICENSE: [[DBAD]]
	__DATE: [[August 8th, 2024]]
	__VERSION: { 0, 7, 42 }
	__VERSION_NAME: [[Afterripening Tahkhana]]
	logic: {
		:Timer, :List,
		NOP: _nop,
		copy: _copy, combine: _combine,
		newArray: _newArray,
		isCallable: _isCallable,
		is: _is, isAncestor: _isAncestor,
		are: _are, areAncestors: _areAncestors
	}
	io: {
		:FileToucher
		fileLines: _fileLines
		fileExists: _fileExists
	}
	math: {
		sign: _sign
		sigmoid: _sigmoid
		angleBetween: _angleBetween
		inverseLerp: _invLerp
		cosineLerp: _cerp
		smooth: _smooth
		pingPong: _pingPong
		isWithinCircle: _isWithinCircle
		random: (tbl)->
			if (type(tbl) == TYPE_TABLE) then return (tbl[math.random(#tbl)])
			(math.random(tonumber(tbl or 1)))
		ifs: {
			sin: (x, y)-> math.sin(x), math.sin(y)
			sphere: (x, y)->
				fac = (1/(math.sqrt((x*x)+(y*y))))
				return (fac*x), (fac*y)
			swirl: (x, y)->
				rsqr = math.sqrt((x*x)+(y*y))
				res_x = ((x*math.sin(rsqr))-(y*math.cos(rsqr)))
				res_y = ((x*math.cos(rsqr))+(y*math.sin(rsqr)))
				return res_x, res_y
			horseshoe: (x, y)->
				factor = (1/(math.sqrt((x*x)+(y*y))))
				return (factor*((x-y)*(x+y))), (factor*(2*(x*y)))
			polar: (x, y) ->
				return (math.atan(x/y)*math.pi), (((x*x)+(y*y))-1)
			handkerchief: (x, y)->
				r = math.sqrt((x*x)+(y*y))
				arcTan = math.atan(x/y)
				return (r*math.sin(arcTan+r)), (r*math.cos(arcTan-r))
			heart: (x, y)->
				r = math.sqrt((x*x)+(y*y))
				arcTan = math.atan(x/y)
				return (r*math.sin(arcTan*r)), (r*(-math.cos(arcTan*r)))
			disc: (x, y)->
				r = math.sqrt((x*x)+(y*y))
				arcTan = math.atan(x/y)
				arctanPi = (arcTan*math.pi)
				return (arctanPi*(math.sin(math.pi*r))), (arctanPi*(math.cos(math.pi*r)))
			spiral: (x, y)->
				r = math.sqrt((x*x)+(y*y))
				factor = (1/(math.sqrt((x*x)+(y*y))))
				arcTan = math.atan(x/y)
				return (factor*(math.cos(arcTan)+math.sin(r))), (factor*(math.sin(arcTan-math.cos(r))))
			hyperbolic: (x, y)->
				r = math.sqrt((x*x)+(y*y))
				arcTan = math.atan(x/y)
				return (math.sin(arcTan)/r), (r*math.cos(arcTan))
			diamond: (x, y)->
				r = math.sqrt((x*x)+(y*y))
				arcTan = math.atan(x/y)
				return (math.sin(arcTan*math.cos(r))), (math.cos(arcTan*math.sin(r)))
			ex: (x, y)->
				r = math.sqrt((x*x)+(y*y))
				arcTan = math.atan(x/y)
				p0 = math.sin(arcTan+r)
				p0 = math.pow(p0,3)
				p1 = math.cos(arcTan-r)
				p1 = math.pow(p1,3)
				return (r*(p0+p1)), (r*(p0-p1))
			julia: (x, y)->
				r = math.sqrt((x*x)+(y*y))
				arcTan = math.atan(x/y)
				omega = if (math.random! >= 0.5) then math.pi else 0
				res_x = (r*(math.cos((arcTan*0.5)+omega)))
				res_y = (r*(math.sin((arcTan*0.5)+omega)))
				return res_x, res_y
			bent: (x, y)->
				if (x < 0 and y >= 0) then return (x*2), (y)
				elseif (x >= 0 and y < 0) then return (x), (y*0.5)
				elseif (x < 0 and y < 0) then return (x*2), (y*0.5)
				return (x), (y)
			waves: (x, y, a, b, c, d, e, f)->
				return (x+b*math.sin(y/(c*c))), (y+e*math.sin(x/(f*f)))
			fisheye: (x, y)->
				r = math.sqrt((x*x)+(y*y))
				factor = ((r+1)*0.5)
				return (factor*y), (factor*x)
			eyefish: (x, y)->
				r = math.sqrt((x*x) + (y*y))
				factor = ((r + 1)*0.5)
				return (factor*x), (factor*y)
			popcorn: (x, y, a, b, c, d, e, f)->
				return (x+c*math.sin(math.tan(3*y))), (y+f*math.sin(math.tan(3*x)))
			power: (x, y)->
				r = math.sqrt((x*x)+(y*y))
				arcTan = math.atan(x/y)
				factor = r^(math.sin(arcTan))
				return (factor*(math.cos(arcTan))), (math.sin(arcTan))
			cosine: (x, y)->
				res_x = (math.cos(math.pi*x)*math.cosh(y))
				res_y = (-(math.sin(math.pi*x)*math.sinh(y)))
				return res_x, res_y
			rings: (x, y, a, b, c, d, e, f)->
				r = math.sqrt((x*x)+(y*y))
				arcTan = math.atan(x/y)
				factor = (r+(c*c))%(2*(c*c)-(c*c)+r*(1-(c*c)))
				return (factor*math.cos(arcTan)), (factor*math.sin(arcTan))
			fan: (x, y, a, b, c, d, e, f)->
				t = (math.pi*(c*c))
				r = math.sqrt((x*x)+(y*y))
				arcTan = math.atan(x/y)
				if ((arcTan+f)%t) > (t*0.5) then
					return (r*math.cos(arcTan-(t*0.5))), (r*math.sin(arcTan-(t*0.5)))
				return (r*math.cos(arcTan+(t*0.5))), (r*math.sin(arcTan+(t*0.5)))
			blob: (x, y, b)->
				r = math.sqrt((x*x)+(y*y))
				arcTan = math.atan(x/y)
				factor = r*(b.Low+((b.High-b.Low)*0.5)*math.sin(b.Waves*arcTan)+1)
				return (factor*math.cos(arcTan)), (factor*math.sin(arcTan))
			pdj: (x, y, a, b, c, d, e, f)->
				return (math.sin(a*y)-math.cos(b*x)), (math.sin(c*x)-math.cos(d*y))
			bubble: (x, y)->
				r = math.sqrt((x*x)+(y*y))
				factor = (4/((r*r)+4))
				return (factor*x), (factor*y)
			cylinder: (x, y)->
				return (math.sin(x)), (y)
			perspective: (x, y, angle, dist)->
				factor = dist/(dist-(y*math.sin(angle)))
				return (factor*x), (factor*(y*math.cos(angle)))
			noise: (x, y)->
				rand = math.random(0,1)
				rand2 = math.random(0,1)
				res_x = (rand*(x*math.cos(2*math.pi*rand2)))
				res_y = (rand*(y*math.sin(2*math.pi*rand2)))
				return res_x, res_y
			pie: (x, y, slices, rotation, thickness)->
				--t1 = truncate(math.random!*slices)
				--t2 = rotation+((2*math.pi)/(slices))*(t1+math.random!*thickness)
				--r0 = math.random!
				--return (r0*math.cos(t2)), (r0*math.sin(t2))
			-- ngon:(x, y, power, sides, corners, circle)-> TODO
			-- 	p2 = (2*math.pi)/sides
			-- 	iArcTan = math.atan(y/x)
			-- 	t3 = (iArcTan-(p2*math.floor(iArcTan/p2)))
			-- 	t4 = if (t3 > (p2*0.5)) then t3 else (t3-p2)
			-- 	--k = ((corners*(1/(math.cos(t4))+circle))/math.pow(r, power)) r??
			-- 	return (k*x), (k*y)
			error(TODO)
			curl: (x, y, c1, c2)->
				t1 = (1+(c1*x)+c2*((x*x)-(y*y)))
				t2 = (c1*y)+(2*c2*x*y)
				factor = (1/((t1*t1)+(t2*t2)))
				return (factor*((x*t1)+(y*t2))), (factor*((y*t1)-(x*t2)))
			rectangles: (x, y, rX, rY)->
				return (((2*math.floor(x/rX) + 1)*rX)-x), (((2*math.floor(y/rY)+1)*rY)-y)
			tangent: (x, y)->
				return (math.sin(x)/math.cos(y)), (math.tan(y))
			cross: (x, y)->
				factor = math.sqrt(1/(((x*x)-(y*y))*((x*x)-(y*y))))
				return (factor*x), (factor*y)
		}
		:Dyad, :Tetrad, :Hexad, :Octad,
		:Shape
		shapes: { :Circle, :Line, :Rectangle, :Polygon },
	}
	string: {
		:UUID
		serialize: _serialize,
		getAddress: _getAddress
	},
	authy: {},
	generative: {}
}
-- @LÖVE2D Bindings
love = (love or nil) 
if love then
	-- @graphics
	class ShaderCode -- GLSL ES Shader Syntax
		new:=> error(TODO)
	class Projector
		new:=> error(TODO)
	class View
		new: (oX, oY, w, h)=>
			error(TODO)
			@Position = Hexad(oX, oY)
			@Conf = { margin: 0 }
			@Canvas = love.graphics.newCanvas(w, h)
			(@)
		configure: (param, value)=>
			@Conf[param] = value
			(@)
		renderTo: (func)=>
			@Canvas\renderTo(func)
			(@)
	class ListView extends View
		new:=> error(TODO)
	class GridView extends ListView
		new:=> error(TODO)
	class Element
		new:=>
			@Position = Hexad!
			(@)
	class Label extends Element
		new:(text, alignment='center')=>
			print('Label'..NEEDS_TESTING)
			@Text = (tostring(text) or 'NaV')
			@Align = alignment
			(@)
		draw:=>
			if (love.graphics.isActive! == false) then return (nil)
			love.graphics.printf(@Text, @Position\get!, love.window.toPixels(#@Text))
			(@)
	class Button extends Element
		new:=> error(TODO)
	class Textbox extends Element
		new:=> error(TODO)
	class Picture extends Element
		new: (f)=>
			print('Label'..NEEDS_TESTING) -- TODO
			@Image = love.graphics.newImage(f)
			(@)
		draw: (x, y, r, sX, sY)=>
			love.graphics.draw(@Image, x, y, r, sX, sY)
			(@)
		getPixel: (x, y)=> return (@Image\getData!)\getPixel(x, y)
		setPixel: (x, y, color)=>
			assert(#color == 4, "color table must have 4 values.")
			iD = @Image\getData!
			iD\setPixel(x, y, color[1], color[2], color[3], color[4])
			@Image = love.graphics.newImage(iD)
			(@)
		map: (func, x, y, w, h)=>
			if _isCallable(func) then
				iD = @Image\getData!
				iD\mapPixel(func, x, y, w, h)
				@Image = love.graphics.newImage(iD)
				(@)
		encode: (f, format)=> (@Image\getData!)\encode(format, f)
	class PictureBatch extends Element
		draw: (id, x=0, y=0, r=0, sX=0, sY=0)=>
			love.graphics.draw(@Image, (@Quads[id] or nil), x, y, r, sX, sY)
			(@)
		new: (f, sprites)=>
			print('Label'..NEEDS_TESTING) -- TODO
			if @Image = love.graphics.newImage(f) then
				@Quads = {}
				for k,v in pairs(sprites) do
					assert(v.x and v.y and v.w and v.h)
					@Quads[k] = love.graphics.newQuad(v.x, v.y, v.w, v.h, @Image\getDimensions!)
			(@)

	MTLibrary.graphics = {
		:View, :ListView, :GridView, :Element, :Label,
		:Button, :Textbox, :Picture, :PictureBatch,
		:Projector,
		patternColorizer: (str, colors)->
			-- if (type(str) == 'string') and (type(colors) == 'table') then
			error(TODO)
		fit: (monitorRatio=1)->
			--oldW, oldH, currentFlags = love.window.getMode!
			--screen, window = {}, {}
			--screen.w, screen.h = love.window.getDesktopDimensions(currentFlags.display)
			--newWindowWidth = truncate(screen.w / monitorRatio)
			--newWindowHeight = truncate(screen.h / monitorRatio)
			--if ((oldW == newWindowWidth) and (oldH == newWindowHeight)) then return (nil), (nil)
			--window.display, window.w = currentFlags.display, newWindowWidth
			--window.h = newWindowHeight
			--window.x = math.floor((screen.w*0.5)-(window.w*0.5))
			--window.y = math.floor((screen.h*0.5)-(window.h*0.5))
			--currentFlags.x, currentFlags.y = window.x, window.y
			--love.window.setMode(window.w, window.h, currentFlags)
			--return (screen), (window)
			error(TODO)
		getCenter: (offset, offsetY)->
			--w, h = love.graphics.getDimensions!
			-- ((w-offset)*0.5), ((h-(offsetY or offset))*0.5)
			error("TODO")
	}
(MTLibrary)