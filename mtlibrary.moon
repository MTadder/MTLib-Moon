-- @meta-info
_meta = {
    name: 'MTLibrary',
    author: 'MTadder',
    date: 'June 12, 2022',
    version: { 0, 61, 34, 'OTP' }
}

-- @logic
_nop =-> (nil)
_isCallable =(obj)->
    if (type(obj) == 'function') then return (true)
    if mt = getmetatable(obj) then return (mt.__call != nil)
    (false)
_copy =(obj)->
    if (type(obj) != 'table') then return (obj)
    if (#obj == 0) then return ({})
    c = {}
    for k,v in pairs(obj) do c[_copy(k)] = _copy(v)
    (setmetatable(c, getmetatable(obj)))
_combine =(t1, t2)->
    if ((t1 == nil) or (t2 == nil)) then return ((t1 or t2) or nil)
    if ((type(t1) == 'table') and type(t1) == type(t2)) then
        r = _copy(t1)
        for k,v in pairs(t2) do r[k] = v
        return r
    else return (t1 + t2)
_is =(val, ofClass)->
    if ((val != nil) and (ofClass != nil)) then
        if (type(val) != 'table') then return (false)
        if (val.__class != nil) then
            if (ofClass.__class != nil) then return (val.__class.__name == ofClass.__class.__name)
            return (val.__class.__name == ofClass)
_isAncestor =(val, ofClass)->
    if (val == nil or ofClass == nil) then return (false)
    if (val.__parent) then
        if (type(ofClass) == 'string') then return (obj.__parent.__name == ofClass)
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
_getAddress =(f, l)->
    if ((l == nil) and (type(f) == 'function')) then l = true
    return ("#{((l and '0x') or '')}#{(tostring(f)\gsub('%a*:%s*0?', '')\upper!)}")
_serialize =(v)->
    tokens = {
        ['nil']:-> ('nil')
        ['boolean']:(b)-> ("#{b}"\lower!)
        ['string']:(s)-> string.format('%q', s)
        ['userdata']:(u)-> ("UserData @ #{_getAddress(u)}")
        ['function']:(f)-> ("Function @ #{_getAddress(f)}")
        ['thread']:(t)-> ("Thread @ #{_getAddress(t)}")
        ['number']:(n)->
            huge = (math.huge or (1/0))
            if (n != n) then return ('NaN')
            if (n == huge) then return ('INF')
            if (n > huge) then return ('INF+')
            if (n == -huge) then return ('-INF')
            if (n > 9999) then return ("0x#{string.format("%x", n)\upper!}")
            else return (string.format('%d', n))
        ['table']:(t, s={})->
            rtn = {}
            s[t] = true
            for k,m in pairs(t) do
                if (s[m] == true) then
                    rtn[((#rtn)+1)] = "..."
                else
                    rtn[((#rtn)+1)] = "#{_serialize(m, s)}"
            s[t] = nil
            return ("{#{table.concat(rtn, ', ')}}")
    }
    return (tokens[type(v)](v))

class List
    new:(ofItems)=>
        @Items = _copy(ofItems or {})
    combine:(withTbl)=>
        if (type(ofItems) == 'table') then
            for k,v in pairs(withTbl) do @push(v, k)
    __tostring:=> _serialize(@Items, ', ')
    __add:(v1, v2)->
        if (type(v1) != 'table') then return (v2\push(v1))
        elseif (type(v2) != 'table') then return (v1\push(v2))
        if (v1.__name == 'List') then
            if (v2.__name == 'List') then
                for k,v in pairs(v2.Items) do v1\push(v, k)
                return (v1)
            else
                v2L = List(v2)
                return (v1 + v2L)
        elseif (v2.__name == 'List') then
            v1L = List(v1)
            return (v1L + v2)
        (nil)
    contains:(value, atKey)=>
        if (atKey != nil) then
            if v = @Items[atKey] then
                return (value == v)
        else for k,v in pairs(@Items) do
            if (v == value) then return (true)
        (false)
    removeAt:(idx)=>
        @Items[idx] = nil
        (true)
    remove:(item)=>
        for k,v in pairs(@Items) do
            if (v == item) then
                @Items[k] = nil
                return (true)
        (false)
    forEach:(doFunc, iterations=1)=>
        for k,v in pairs(@Items) do
            for i=1, iterations do
                @Items[k] = (doFunc(v, i, k) or v)
        (nil)
    push:(item, toKey)=>
        k = (tonumber(toKey) or (#@Items+1))
        table.insert(@Items, k, item)
        return (@Items[k] == item)
    flatten:=>
        stck = {}
        fT = {}
        conflictors = {}
        enter=(t, s={})->
        for k,v in pairs(@Items) do
            if (type(v) == 'table') then
                enter(v, s)
        return (fT)

    top:=> (@Items[#@Items])
    pop:(atKey)=> table.remove(@Items, (atKey or #@Items))
class Timer
    update:(dT)=>
        now = os.clock!
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
    new:(duration, on_complete, looping=false)=>
        @Duration, @Looping = duration, looping
        @last_update = os.clock!
        @On_Completion = (on_complete or _nop)
        @restart!
        (@)

-- @math
_uuid =->
    fn =(x)->
        r = (math.random(16)-1)
        r = ((x == 'x') and (r+1) or (r%4)+9)
        return ("0123456789abcdef"\sub(r, r))
    return ("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"\gsub("[xy]", fn))
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
_intersects =(o1x, o1y, e1x, e1y, o2x, o2y, e2x, e2y)->
    -- adapted from https://gist.github.com/Joncom/e8e8d18ebe7fe55c3894
    s1x, s1y = (e1x-o1x), (e1y-o1y)
    s2x, s2y = (e2x-o2x), (e2y-o2y)
    s = (-s1y*(o1x-o2x)+s1x*(o1y-o2y))/(-s2x*s1y+s1x*s2y)
    t =  (s2x*(o1y-o2y)-s2y*(o1x-o2x))/(-s2x*s1y+s1x*s2y)
    ((s >= 0) and (s <= 1) and (t >= 0) and (t <= 1))
class Dyad
    lerp:(o, d, d1)=>
        if (_is(o, 'Dyad')) then
            @Position.x = _lerp(@Position.x, o.Position.x, tonumber(d))
            @Position.y = _lerp(@Position.y, o.Position.y, tonumber(d))
        elseif (type(o) == 'number') then
            @Position.x = _lerp(@Position.x, o, d1)
            @Position.x = _lerp(@Position.y, d, d1)
        (@)
    get:=> (@Position.x), (@Position.y)
    equals:(o, o2)=>
        if (o == nil) then return (false)
        elseif ((type(o) != 'table') and (o2 == nil)) then return (false)
        elseif (_is(o, 'Dyad')) then return ((@Position.x == o.Position.x) and (@Position.y == o.Position.y))
        elseif ((type(o2) == 'number') and (o1 != nil)) then
            return ((@Position.x == o) and (@Position.y == o2))
        (false)
    distance:(o=0, o2=0)=>
        if ((type(o) == 'number') and (type(o2) == 'number')) then
            return _dist(@Position.x, @Position.y, o, o2)
        if (_is(o, 'Dyad')) then
            return @distance(o.Position.x, o.Position.y)
        (nil)
    __tostring:=> ("D{#{@Position.x}, #{@Position.y}}")
    set:(x, y)=>
        @Position or= {}
        @Position.x, @Position.y = tonumber(x or 0), tonumber(y or 0)
        (@)
    __call:(x, y)=> @set(x, y) 
    new:(x, y)=> @(x, y)
class Tetrad extends Dyad
    lerp:(o, d)=>
        if (_is(o, 'Tetrad')) then
            super\lerp(o, d)
            @Velocity.x = _lerp(@Velocity.x, o.Position.x, tonumber(d))
            @Velocity.y = _lerp(@Velocity.y, o.Position.y, tonumber(d))
        (@)
    distance:(o)=> (super\distance(o))
    set:(x, y, xV, yV)=>
        super\set(x, y)
        @Velocity or= {}
        @Velocity.x, @Velocity.y = tonumber(xV or 0), tonumber(yV or 0)
    get:=> unpack({
        @Position.x, @Position.y,
        @Velocity.x, @Velocity.y })
    update:(dT=(1/60))=>
        @Position.x += (@Velocity.x*dT)
        @Position.y += (@Velocity.y*dT)
    impulse:(angle, force)=>
        v = (math.cos(angle)*force)
        @Velocity.x += v
        @Velocity.y += v
    __tostring:=> ("T{#{@Velocity.x}, #{@Velocity.y}, #{super.__tostring(@)}}")
    __call:(x, y, xV, yV)=> @set(x, y, xV, yV)
    new:(x, y, xV, yV)=> @(x, p2, xV, yV)
class Hexad extends Tetrad
    new:(x, y, xV, yV, r, rv)=> @set(x, y, xV, yV, r, rV)
    set:(x, y, xV, yV, r, rV)=>
        super\set(x, y, xV, yV)
        @Rotator or= {}
        @Rotator.value, @Rotator.inertia = tonumber(r or 0), tonumber(rV or 0)
    get:=> unpack({
        @Position.x, @Position.y,
        @Velocity.x, @Velocity.y,
        @Rotator.value, @Rotator.inertia })
    update:(dT=(1/60))=>
        super\update(dT)
        @Rotator.value += (@Rotator.inertia*dT)
    torque:(by)=> @Rotator.inertia += tonumber(by)
    __tostring:=> ("H{#{@Rotator.value}, #{@Rotator.inertia}, #{super.__tostring(@)}}")
class Octad extends Hexad
    new:(x, y, xV, yV, r, rv, dA, dE)=> @set(x, y, xV, yV, r, rV, dA, dE)
    set:(x, y, xV, yV, r, rV, dA, dE)=>
        super\set(x, y, xV, yV, r, rV)
        @Dimensional or= {}
        @Dimensional.address, @Dimensional.entropy = tonumber(dA or 0), tonumber(dE or 0)
    get:=> unpack({
        @Position.x, @Position.y,
        @Velocity.x, @Velocity.y,
        @Rotator.value, @Rotator.inertia,
        @Dimensional.address, @Dimensional.entropy })
    shake:(by)=> @Dimensional.entropy += tonumber(by)
    update:(dT=(1/60))=>
        super\update(dT)
        @Dimensional.address += (@Dimensional.entropy*dT)
    __tostring:=> ("O{#{@Dimensional.address}, #{@Dimensional.entropy}, #{super.__tostring(@)}}")
class Shape
    new:(oX, oY)=> @set(oX, oY)
    set:(oX, oY)=>
        @Origin or= Dyad(tonumber(oX or 0), tonumber(oY or 0))
    __tostring:=> ("S{#{tostring(@Origin)}}")
class Circle extends Shape
    set:(oX, oY, radi)=>
        super\set(oX, oY)
        @Radius = tonumber(radi or math.pi)
    draw:(mode)=> love.graphics.circle(mode, @Origin.x, @Origin.y, @Radius)
    __tostring:=> ("C{#{@Radius}, #{super.__tostring(@)}}")
    new:(x, y, rad)=> @set(x, y, rad)
class Line extends Shape
    new:(oX, oY, eX, eY)=> @set(oX, oY, eX, eY)
    set:(oX, oY, eX, eY)=>
        super\set(oX, oY)
        @Ending = Dyad(eX, eY)
    get:=> unpack({
        @Origin.Position.x, @Origin.Position.y,
        @Ending.Position.x, @Ending.Position.x })
    distance:(o, o2)=> -- @TODO
    getLength:=>
        sOX, sOY = @Origin\get!
        sEX, sEY = @Ending\get!
        (math.sqrt(math.pow(sEX-sOX, 2)+math.pow(sEY-sOY, 2)))
    getSlope:=> ((@Ending.Position.x-@Origin.Position.x)/(@Ending.Position.y-@Origin.Position.y))
    intersects:(o)=>
        if _is(o, 'Dyad') then
            sOX, sOY, sEX, sEY = @get!
            oPX, oPY = o\get!
            slope = @getSlope!
            return ((slope*sOX+oPX == 0) or (slope*sEX+sPY == 0))
        elseif _is(o, 'Line') then
            sOX, sOY, sEX, sEY = @get!
            oOX, oOY, oEX, oEY = o\get!
            if (_intersects(sOX, sOY, sEX, sEY, oOX, oOY, oEX, oEY)) then return (true)
        elseif _is(o, 'Rectangle') then
            if (o\contains(@Origin) or o\contains(@Ending)) then return (true)
            for i,l in ipairs(o\getLines!) do if (@intersects(l)) then return (true)
        (false)
    __tostring:=> ("[{#{tostring(@Origin)}}-(#{@getLength!})->{#{tostring(@Ending)}}]")
class Rectangle extends Shape
    new:(oX, oY, lX, lY)=> @set(oX, oY, lX, lY)
    set:(oX, oY, lX, lY)=>
        super\set(oX, oY)
        @Limits or= Dyad(lX, lY)
    get:=> unpack({
        @Origin.Position.x, @Origin.Position.y,
        @Limits.Position.x, @Limits.Position.y })
    area:=> (@Limits.Position.x*@Limits.Position.y)
    perimeter:=> ((2*(@Limits.Position.x))+(2*(@Limits.Position.y)))
    diagonal:=> math.sqrt(((@Limits.Position.x)^2)+((@Limits.Position.y)^2))
    contains:(o)=>
        if (_is(o, 'Dyad')) then
            sOX, sOY, sLX, sLY = @get!
            oPX, oPY = o\get!
            return (_isWithinRegion(oPX, oPY, sOX, sOY, sLX, sLY))
        elseif (_is(o, 'Line')) then return (@contains(o.Origin) and @contains(o.Ending))
        elseif (_is(o, 'Rectangle')) then
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

-- @return @module
MTLibrary = { 
    _meta: _meta,
    logic: {
        :Timer, :List,
        nop: _nop,
        copy: _copy, combine: _combine,
        newArray: _newArray,
        isCallable: _isCallable,
        is: _is, isAncestor: _isAncestor,
        are: _are, areAncestors: _areAncestors
    },
    math: {
        UUID: _uuid,
        random: (tbl)->
            if (type(tbl) == 'table') then return (tbl[math.random(#tbl)])
            (math.random(tonumber(tbl or 1)))
        ifs: {
            sin:(x, y)-> math.sin(x), math.sin(y)
            sphere:(x, y)->
                fac = (1/(math.sqrt((x*x)+(y*y))))
                (fac*x), (fac*y)
            swirl:(x, y)->
                rsqr = math.sqrt((x*x)+(y*y))
                ((x*math.sin(rsqr))-(y*math.cos(rsqr))), ((x*math.cos(rsqr))+(y*math.sin(rsqr)))
            horseshoe:(x, y)->
                factor = (1/(math.sqrt((x*x)+(y*y))))
                (factor*((x-y)*(x+y))), (factor*(2*(x*y)))
            polar:(x, y) -> (math.atan(x/y)*math.pi), (((x*x)+(y*y))-1)
            handkerchief:(x, y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                (r*math.sin(arcTan+r)), (r*math.cos(arcTan-r))
            heart:(x, y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                (r*math.sin(arcTan*r)), (r*(-math.cos(arcTan*r)))
            disc:(x, y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                arctanPi = (arcTan*math.pi)
                (arctanPi*(math.sin(math.pi*r))), (arctanPi*(math.cos(math.pi*r)))
            spiral:(x, y)->
                r = math.sqrt((x*x)+(y*y))
                factor = (1/(math.sqrt((x*x)+(y*y))))
                arcTan = math.atan(x/y)
                (factor*(math.cos(arcTan)+math.sin(r))), (factor*(math.sin(arcTan-math.cos(r))))
            hyperbolic:(x, y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                (math.sin(arcTan)/r), (r*math.cos(arcTan))
            diamond:(x, y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                (math.sin(arcTan*math.cos(r))), (math.cos(arcTan*math.sin(r)))
            ex:(x, y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                p0 = math.sin(arcTan+r)
                p0 = math.pow(p0,3)
                p1 = math.cos(arcTan-r)
                p1 = math.pow(p1,3)
                (r*(p0+p1)), (r*(p0-p1))
            julia:(x, y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                omega = if (math.random! >= 0.5) then math.pi else 0
                (r*(math.cos((arcTan*0.5)+omega))), (r*(math.sin((arcTan*0.5)+omega)))
            bent:(x, y)->
                if (x < 0 and y >= 0) then return (x*2), (y)
                elseif (x >= 0 and y < 0) then return (x), (y*0.5)
                elseif (x < 0 and y < 0) then return (x*2), (y*0.5)
                (x), (y)
            waves:(x, y, a, b, c, d, e, f)-> (x+b*math.sin(y/(c*c))), (y+e*math.sin(x/(f*f)))
            fisheye:(x, y)->
                r = math.sqrt((x*x)+(y*y))
                factor = ((r+1)*0.5)
                (factor*y), (factor*x)
            eyefish: (x, y)->
                r = math.sqrt((x*x) + (y*y))
                factor = ((r + 1)*0.5)
                (factor*x), (factor*y)
            popcorn:(x, y, a, b, c, d, e, f)->
                (x+c*math.sin(math.tan(3*y))), (y+f*math.sin(math.tan(3*x)))
            power:(x, y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                factor = r^(math.sin(arcTan))
                (factor*(math.cos(arcTan))), (math.sin(arcTan))
            cosine:(x, y)-> (math.cos(math.pi*x)*math.cosh(y)), (-(math.sin(math.pi*x)*math.sinh(y)))
            rings:(x, y, a, b, c, d, e, f)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                factor = (r+(c*c))%(2*(c*c)-(c*c)+r*(1-(c*c)))
                (factor*math.cos(arcTan)), (factor*math.sin(arcTan))
            fan:(x, y, a, b, c, d, e, f)->
                t = (math.pi*(c*c))
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                if ((arcTan+f)%t) > (t*0.5) then
                    return (r*math.cos(arcTan-(t*0.5))), (r*math.sin(arcTan-(t*0.5)))
                (r*math.cos(arcTan+(t*0.5))), (r*math.sin(arcTan+(t*0.5)))
            blob:(x, y, b)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                factor = r*(b.Low+((b.High-b.Low)*0.5)*math.sin(b.Waves*arcTan)+1)
                (factor*math.cos(arcTan)), (factor*math.sin(arcTan))
            pdj:(x, y, a, b, c, d, e, f)-> (math.sin(a*y)-math.cos(b*x)), (math.sin(c*x)-math.cos(d*y))
            bubble:(x, y)->
                r = math.sqrt((x*x)+(y*y))
                factor = (4/((r*r)+4))
                (factor*x), (factor*y)
            cylinder:(x, y)-> (math.sin(x)), (y)
            perspective:(x, y, angle, dist)->
                factor = dist/(dist-(y*math.sin(angle)))
                (factor*x), (factor*(y*math.cos(angle)))
            noise:(x, y)->
                rand = math.random(0,1)
                rand2 = math.random(0,1)
                (rand*(x*math.cos(2*math.pi*rand2))), (rand*(y*math.sin(2*math.pi*rand2)))
            pie:(x, y, slices, rotation, thickness)->
                t1 = truncate(math.random!*slices)
                t2 = rotation+((2*math.pi)/(slices))*(t1+math.random!*thickness)
                r0 = math.random!
                (r0*math.cos(t2)), (r0*math.sin(t2))
            ngon:(x, y, power, sides, corners, circle)->
                p2 = (2*math.pi)/sides
                iArcTan = math.atan(y/x)
                t3 = (iArcTan-(p2*math.floor(iArcTan/p2)))
                t4 = if (t3 > (p2*0.5)) then t3 else (t3-p2)
                k = (corners*(1/(math.cos(t4))+circle))/(math.pow(r,power))
                (k*x), (k*y)
            curl:(x, y, c1, c2)->
                t1 = (1+(c1*x)+c2*((x*x)-(y*y)))
                t2 = (c1*y)+(2*c2*x*y)
                factor = (1/((t1*t1)+(t2*t2)))
                (factor*((x*t1)+(y*t2))), (factor*((y*t1)-(x*t2)))
            rectangles:(x, y, rX, rY)-> (((2*math.floor(x/rX) + 1)*rX)-x), (((2*math.floor(y/rY)+1)*rY)-y)
            tangent:(x, y)-> (math.sin(x)/math.cos(y)), (math.tan(y))
            cross:(x, y)-> 
                factor = math.sqrt(1/(((x*x)-(y*y))*((x*x)-(y*y))))
                (factor*x), (factor*y)
        },
        :Dyad, :Tetrad, :Hexad, :Octad,
        :Shape, shapes: { :Circle, :Line, :Rectangle, :Polygon },
    },
    string: {
        serialize: _serialize,
        getAddress: _getAddress
    },
    authy: {
        _nop!
    },
    generative: {
        
    }
}
-- @love
if love then
    -- @graphics
    class ShaderCode -- Uses LOVE2D-Standard GLSL ES Shader Syntax
        new:(src)=>
        validate:=>
            assert(love, '')
    class Projector
        new:=>
        setup:=>
        push:=>
        pop:=>
            if (love ~= nil) then
                love.graphics.pop!
    class View
        new:(oX, oY, w, h)=>
            @Position = Hexad(oX, oY)
            @Conf = { margin: 0 }
            @Canvas = love.graphics.newCanvas(w, h)
        configure:(param, value)=> @Conf[param] = value
        renderTo:(func)=> @Canvas\renderTo(func)
    class ListView extends View
        new:=>
            @Conf = { marg: 0, align: 'center' }
            @Items = {}
    class GridView extends ListView
        new:=>
            @Conf = { rows: 0, cols: 0, marg: 0 }
            @Items = {}
    class Element
        new:=> @Position = Hexad!
    class Label extends Element
        new:(text, alignment='center')=>
            @Text = (tostring(text) or 'NaV')
            @Align = alignment
        draw:=>
            if (love.graphics.isActive! == false) then return (nil)
            love.graphics.printf(@Text, @Position\get!, love.window.toPixels(#@Text))
    class Button extends Element
    class Textbox extends Element
    class Picture extends Element
        new:()=>
        draw:=>
        encode:(toFilename, fileFormat)=>
    class Atlas extends Picture
    MTLibrary.graphics = {
        :View, :ListView, :GridView, :Element, :Label,
        :Button, :Textbox, :Picture, :Atlas,
        :Projector,
        patternColorizer:(str, colors)->
            -- if (type(str) == 'string') and (type(colors) == 'table') then
                
            return (nil)
        fit:(monitorRatio=1)->
            oldW, oldH, currentFlags = love.window.getMode!
            screen, window = {}, {}
            screen.w, screen.h = love.window.getDesktopDimensions(currentFlags.display)
            newWindowWidth = truncate(screen.w / monitorRatio)
            newWindowHeight = truncate(screen.h / monitorRatio)
            if ((oldW == newWindowWidth) and (oldH == newWindowHeight)) then return (nil), (nil)
            window.display, window.w = currentFlags.display, newWindowWidth
            window.h = newWindowHeight
            window.x = math.floor((screen.w*0.5)-(window.w*0.5))
            window.y = math.floor((screen.h*0.5)-(window.h*0.5))
            currentFlags.x, currentFlags.y = window.x, window.y
            love.window.setMode(window.w, window.h, currentFlags)
            return (screen), (window)
        getCenter:(offset, offsetY)->
            w, h = love.graphics.getDimensions!
            (error!)
            -- ((w-offset)*0.5), ((h-(offsetY or offset))*0.5)
    }
(MTLibrary)