import isInstanceOf from require([[mtlib.logic]])
import types from require([[mtlib.constants]])

clamp =(v, l=0, u=1)-> math.max(l, math.min(v, u))
sign =(v)-> (v < 0 and -1 or 1)
sigmoid =(v)-> (1/(1+math.exp(-v)))
distance =(x, y, x2, y2)-> math.abs(math.sqrt(math.pow(x2-x, 2)+math.pow(y2-y, 2)))
angleBetween =(x, y, x2, y2)-> math.abs(math.atan2(y2-y,x2-x))
invLerp =(a, b, d)-> ((d-a)/(b-a))
cerp =(a, b, d)->
	pi = (math.pi or 3.1415)
	f = (1-math.cos(d*pi)*0.5)
	(a*(1-f)+(b*f))
lerp =(a, b, d)-> (a+(b-a)*clamp(d)) -- (a*(1-d)+b*d) -- a + (b - a) * clamp(amount, 0, 1)
smooth =(a, b, d)->
	t = clamp(d)
	m = t*t*(3-2*t)
	(a+(b-a)*m)
pingPong =(x)-> (1-math.abs(1-x%2))
isWithinRegion =(x, y, oX, oY, lX, lY)-> ((x > oX and y < lX) and (y > oY and y < lY))
isWithinCircle =(x, y, oX, oY, oR)-> (distance(x, y, oX, oY) < oR)
-- _intersects =(o1x, o1y, e1x, e1y, o2x, o2y, e2x, e2y)-> TODO
-- 	-- adapted from https://gist.github.com/Joncom/e8e8d18ebe7fe55c3894
-- 	s1x, s1y = (e1x-o1x), (e1y-o1y)
-- 	s2x, s2y = (e2x-o2x), (e2y-o2y)
-- 	s = (-s1y*(o1x-o2x)+s1x*(o1y-o2y))/(-s2x*s1y+s1x*s2y)
-- 	t =  (s2x*(o1y-o2y)-s2y*(o1x-o2x))/(-s2x*s1y+s1x*s2y)
-- 	((s >= 0) and (s <= 1) and (t >= 0) and (t <= 1))
class Dyad
	lerp: (o, d, d1)=>
		if isInstanceOf(o, 'Dyad') then
			@Position.x = lerp(@Position.x, o.Position.x, tonumber(d))
			@Position.y = lerp(@Position.y, o.Position.y, tonumber(d))
		elseif (type(o) == types.NUMBER) then
			@Position.x = lerp(@Position.x, o, d1)
			@Position.x = lerp(@Position.y, d, d1)
		(@)
	get:=> (@Position.x), (@Position.y)
	equals: (o, o2)=>
		if (o == nil) then return (false)
		elseif ((type(o) != types.TABLE) and (o2 == nil)) then return (false)
		elseif isInstanceOf(o, 'Dyad') then
			return ((@Position.x == o.Position.x) and (@Position.y == o.Position.y))
		elseif ((type(o2) == types.NUMBER) and (o != nil)) then
			return ((@Position.x == o) and (@Position.y == o2))
		(false)
	distance: (o=0, o2=0)=>
		if ((type(o) == types.NUMBER) and (type(o2) == types.NUMBER)) then
			return distance(@Position.x, @Position.y, o, o2)
		if isInstanceOf(o, 'Dyad') then
			return @distance(o.Position.x, o.Position.y)
		(nil)
	set: (x, y)=>
		@Position or= {}
		@Position.x, @Position.y = tonumber(x or 0), tonumber(y or 0)
		(@)
	__call: (x, y)=> @set(x, y)
	new: (x, y)=> @(x, y)
class Tetrad extends Dyad
	lerp: (o, d)=>
		if isInstanceOf(o, 'Tetrad') then
			super\lerp(o, d)
			@Velocity.x = lerp(@Velocity.x, o.Position.x, tonumber(d))
			@Velocity.y = lerp(@Velocity.y, o.Position.y, tonumber(d))
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
class Shape
	new: (oX, oY)=>
        error!
		(@set(oX, oY))
	set: (oX, oY)=>
		@Origin or= Dyad(tonumber(oX or 0), tonumber(oY or 0))
		(@)
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
	--distance: (o, o2)=> error!
	getLength:=>
		sOX, sOY = @Origin\get!
		sEX, sEY = @Ending\get!
		(math.sqrt(math.pow(sEX-sOX, 2)+math.pow(sEY-sOY, 2)))
	getSlope:=> ((@Ending.Position.x-@Origin.Position.x)/(@Ending.Position.y-@Origin.Position.y))
	intersects: (o)=> error!
		-- if isInstanceOf(o, 'Dyad') then
		-- 	sOX, sOY, sEX, sEY = @get!
		-- 	oPX, oPY = o\get!
		-- 	slope = @getSlope!
		-- 	return ((slope*sOX+oPX == 0) or (slope*sEX+sPY == 0))
		-- elseif isInstanceOf(o, 'Line') then
		-- 	sOX, sOY, sEX, sEY = @get!
		-- 	oOX, oOY, oEX, oEY = o\get!
		-- 	if (_intersects(sOX, sOY, sEX, sEY, oOX, oOY, oEX, oEY)) then return (true)
		-- elseif isInstanceOf(o, 'Rectangle') then
		-- 	if (o\contains(@Origin) or o\contains(@Ending)) then return (true)
		-- 	for i,l in ipairs(o\getLines!) do if (@intersects(l)) then return (true)
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
		if isInstanceOf(o, 'Dyad') then
			sOX, sOY, sLX, sLY = @get!
			oPX, oPY = o\get!
			return isWithinRegion(oPX, oPY, sOX, sOY, sLX, sLY)
		elseif isInstanceOf(o, 'Line') then return (@contains(o.Origin) and @contains(o.Ending))
		elseif isInstanceOf(o, 'Rectangle') then
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
    new:=> error!

{
    :sign
    :sigmoid
    :angleBetween
    :lerp
    :inverseLerp
    :cosineLerp
    :smooth
    :pingPong
    :isWithinRegion
    :isWithinCircle

    :Dyad
    :Tetrad
    :Hexad
    :Octad

    :Shape
    :Line
    :Circle
    :Rectangle
    :Polygon
}