_meta = {
    name: 'MTLibrary',
    author: 'MTadder',
    date: 'Nov. 28, 2021'
    version: {
        major: 0,
        minor: 6,
        revision: 20,
        codename: '☆^*;|;*^☆'
    }
}

-- @logic
_nop = ()-> (nil)
_unpack = (unpack or table.unpack)
_binarySearch = (list, value, resolver)->
    if ((list == nil) or (value == nil)) then return (nil)
    resolver or= ((value)-> (value))
    found, lower, upper = false, 1, #list
    while (found == false) do
        check = math.floor(((upper-lower)/2)+0.5)
        if (list[check] == nil) then break
        elseif (upper == lower) then break
        elseif (resolver(list[check]) == value) then return (check)
        elseif (resolver(list[check]) < value) then upper = check
        elseif (resolver(list[check]) > value) then lower = check
    (nil)
_binaryInsert = (tbl, val, comparator)->
    if ((tbl == nil) or (val == nil)) then return (nil)
    comparator or= (a, b)-> (a < b)
    iStart, iEnd, iMid, iState = 1, #tbl, 1, 0
    while (iStart <= iEnd) do
        iMid = math.floor(((iStart+iEnd)/2+0.5))
        if comparator(val, tbl[iMid]) then
            iEnd, iState = iMid-1, 0
        else iStart, iState = iMid+1, 1
    k = (iMid+iState)
    table.insert(tbl, k, val)
    (k)
_is = (v, ofClass)-> -- This could probably be simplified.
    if ((v == nil) and (ofClass == nil)) then return (true)
    elseif ((v == nil) or (ofClass == nil)) then return (false)
    elseif ((type(v) == 'table') and (v.__class == nil)) then
        return (_are(v, ofClass))
    elseif (type(ofClass) == 'string') then
        return (v.__class.__name == ofClass)
    elseif (v.__class != nil) then return (ofClass == v.__class)
    else return ((v == ofClass) or (type(v) == ofClass))
_are = (tbl, ofClass)->
    for i,v in pairs(tbl) do
        if ((_is(v, ofClass)) == false) then return (false)
    (true)
_isAncestor = (obj, ofClass)-> -- This too. Read up on the Moonscript manual. (@TODO)
    if ((obj == nil) or (ofClass == nil)) then return (false)
    elseif (obj.__parent != nil) then
        if (obj.__parent.__name == ofClass.__name) then return (true)
        elseif ((type(ofClass) == 'string') and (obj.__parent.__name == ofClass)) then return (true)
        else return (_isAncestor(obj.__parent, ofClass))
    (false)

class Timer
    update: (dT)=>
        if (love != nil) then dT or= love.timer.getDelta!
        @Remainder -= dT
        if (@Remainder <= 0) then
            if (@Looping == true) then @restart!
            return (true), (@On_Completion!)
        return (false), (@On_Update!)
    isComplete: => ((@Remainder <= 0) and (@Looping == false))
    restart: =>
        @Remainder = @Duration
        (@)
    new: (duration, on_complete, on_update, looping=false)=>
        @Duration, @Looping = duration, looping
        @On_Update, @On_Completion = (on_update or _nop), (on_complete or _nop)
        @restart!
        (@)

class Container
    set: (item, key)=>
        idx = ((@count!)+1)
        if (item != nil) then @Items[idx], @Keys[idx] = item, (key or idx)
        (@count!)
    new: (initial)=>
        @Items, @Keys = {}, {}
        @set(initial)
        (@)
    __call: (item, key)=> (@set(item, key))
    get: (key)=>
        for k,v in pairs(@Keys) do if (v == key) then return (@Items[k] or nil)
        (nil)
    getKey: (item)=>
        for k,v in ipairs(@Items) do if (v == item) then return (@Keys[k])
        (nil)
    count: => ((#@Keys) or 0)
    top: => (@Items[#@Items] or nil)
    pop: =>
        item = @top!
        if (item != nil) then @Items[@count!] = nil
        (item or nil)
    forEach: (action)=> ({key,action(key, val) for key,val in @iterator!})
    iterator: ()=>
        i, keys, items = 0, @Keys, @Items
        ()->
            i += 1
            item = items[i]
            if (item == nil) then item = items[keys[i]]
            elseif (item != nil) then return keys[i], item
            (nil)

-- @math
_sigmoid = (x)-> (1/(1+math.exp(-x)))
_dist = (x, y, oX, oY)-> math.abs(math.sqrt(math.pow(x-oX, 2)+math.pow(y-oY, 2)))
_lerp = (a, b, t)-> (a+(b-a)*t)
_isWithin = (x, y, oX, oY, lX, lY)-> ((x > oX and y < lX) and (y > oY and y < lY))
_isWithinPie = (x, y, oX, oY, oR)-> -- @TODO

_intersects = (o1x, o1y, e1x, e1y, o2x, o2y, e2x, e2y)->
    -- adapted from https://gist.github.com/Joncom/e8e8d18ebe7fe55c3894
    s1x, s1y = (e1x - o1x), (e1y - o1y)
    s2x, s2y = (e2x - o2x), (e2y - o2y)
    s = (-s1y * (o1x - o2x) + s1x * (o1y - o2y)) / (-s2x * s1y + s1x * s2y)
    t = ( s2x * (o1y - o2y) - s2y * (o1x - o2x)) / (-s2x * s1y + s1x * s2y)
    (s >= 0 and s <= 1 and t >= 0 and t <= 1)

class Dyad
    lerp: (o, t)=>
        if (_isAncestor(o, 'Dyad')) then
            @Position.x = _lerp(@Position.x, o.Position.x, tonumber(t))
            @Position.y = _lerp(@Position.y, o.Position.y, tonumber(t))
            (@Position.x), (@Position.y)
        (@)
    get: => (@Position.x), (@Position.y)
    equals: (o)=>
        if (_isAncestor(o, 'Dyad')) then
            return (@Position.x == o.Position.x and @Position.y == o.Position.y)
        (false)
    distance: (o)=>
        if (_isAncestor(o, 'Dyad')) then
            return _dist()
            -- return (math.sqrt(math.pow(o.Position.x-@Position.x, 2)+
            --     math.pow(o.Position.y - @Position.y, 2)))
        (0)
    __tostring:=> ("D{#{@Position.x}, #{@Position.y}}")
    set: (x, y)=>
        @Position or= {}
        @Position.x, @Position.y = tonumber(x or 0), tonumber(y or 0)
        (@)
    new: (x, y)=>
        @set(x, y)
        (@)
class Tetrad extends Dyad
    lerp: (o, t)=>
        if (_isAncestor(o, 'Tetrad')) then
            super\lerp(o, t)
            @Velocity.x = _lerp(@Velocity.x, o.Position.x, tonumber(t))
            @Velocity.y = _lerp(@Velocity.y, o.Position.y, tonumber(t))
        (@)
    distance: (o)=> (super\distance(o))
    set: (p1, p2, v1, v2)=>
        super\set(p1, p2)
        @Velocity or= {}
        @Velocity.x, @Velocity.y = tonumber(v1 or 0), tonumber(v2 or 0)
    get: => return _unpack({
        @Position.x, @Position.y,
        @Velocity.x, @Velocity.y })
    update: (dT=(1/60))=>
        @Position.x += (@Velocity.x*dT)
        @Position.y += (@Velocity.y*dT)
    impulse: (angle, force)=>
        v = (math.cos(angle)*force)
        @Velocity.x += v
        @Velocity.y += v
    __tostring: => (super.__tostring(@))..("T{#{@Velocity.x}, #{@Velocity.y}}")
    new: (p1, p2, v1, v2)=> @set(p1, p2, v1, v2)

class Hexad extends Tetrad
    new: (p1, p2, v1, v2, r, rv)=> @set(p1, p2, v1, v2, r, rV)
    set: (p1, p2, v1, v2, r, rV)=>
        super\set(p1, p2, v1, v2)
        @Rotator or= {}
        @Rotator.value, @Rotator.inertia = tonumber(r or 0), tonumber(rV or 0)
    get: => return _unpack({
        @Position.x, @Position.y,
        @Velocity.x, @Velocity.y,
        @Rotator.value, @Rotator.inertia })
    update: (dT=(1/60)) =>
        super\update(dT)
        @Rotator.value += (@Rotator.inertia*dT)
    torque: (by)=> @Rotator.inertia += tonumber(by)
    __tostring: => (super.__tostring(@))..("H{#{@Rotator.value}, #{@Rotator.inertia}}")

class Octad extends Hexad
    new: (p1, p2, v1, v2, r, rv, dA, dE)=> @set(p1, p2, v1, v2, r, rV, dA, dE)
    set: (p1, p2, v1, v2, r, rV, dA, dE)=>
        super\set(p1, p2, v1, v2, r, rV)
        @Dimensional or= {}
        @Dimensional.address, @Dimensional.entropy = tonumber(dA or 0), tonumber(dE or 0)
    get: => return _unpack({
        @Position.x, @Position.y,
        @Velocity.x, @Velocity.y,
        @Rotator.value, @Rotator.inertia,
        @Dimensional.address, @Dimensional.entropy })
    shake: (by)=> @Dimensional.entropy += tonumber(by)
    update: (dT=(1/60))=>
        super\update(dT)
        @Dimensional.address += (@Dimensional.entropy*dT)
    __tostring: => (super.__tostring(@))..("O{#{@Dimensional.address}, #{@Dimensional.entropy}}")

class Shape
    new: (oX, oY)=> @set(oX, oY)
    set: (oX, oY)=>
        @Origin or= Dyad(tonumber(oX or 0), tonumber(oY or 0))
    __tostring: => ("S{#{tostring(@Origin)}}")

class Circle extends Shape
    set: (oX, oY, radi)=>
        super\set(oX, oY)
        @Radius = tonumber(radi or math.pi)
    draw: (mode) => love.graphics.circle(mode, @Origin.x, @Origin.y, @Radius)
    __tostring: => super.__tostring(@)..("C{#{@Radius}}")
    new: (x, y, rad)=> @set(x, y, rad)

class Line extends Shape
    new: (oX, oY, eX, eY)=> @set(oX, oY, eX, eY)
    set: (oX, oY, eX, eY)=>
        super\set(oX, oY)
        @Ending = Dyad(eX, eY)
    get: => return unpack({
        @Origin.Position.x, @Origin.Position.y,
        @Ending.Position.x, @Ending.Position.x })
    getDistance: (o)=>
        error!
        if (_isAncestor(o, Dyad)) then
            pX, pY = o\get!
            
    getLength: =>
        sOX, sOY = @Origin\get!
        sEX, sEY = @Ending\get!
        (math.sqrt(math.pow(sEX-sOX, 2)+math.pow(sEY-sOY, 2)))
    getSlope: => ((@Ending.Position.x-@Origin.Position.x)/(@Ending.Position.y-@Origin.Position.y))
    -- map: (o, x, y) => ((@getSlope!*x)-(-x))
    intersects: (o)=>
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
            for i,l in ipairs(o\getLines!) do
                if (@intersects(l)) then return (true)
        (false)
    __tostring: => super.__tostring(@)..("-->{#{tostring(@Ending)}}")

class Rectangle extends Shape
    new: (oX, oY, lX, lY)=> @set(oX, oY, lX, lY)
    set: (oX, oY, lX, lY)=>
        super\set(oX, oY)
        @Limits or= Dyad(lX, lY)
    get: => return unpack({
        @Origin.Position.x, @Origin.Position.y,
        @Limits.Position.x, @Limits.Position.y })
    area: => (@Limits.Position.x*@Limits.Position.y)
    diagonal: => math.sqrt(math.pow(@Limits.Position.x, 2), math.pow(@Limits.Position.y, 2))
    perimeter: => (2*(@Limits.Position.x+@Limits.Position.y))
    contains: (o)=>
        if (_is(o, 'Dyad')) then
            sOX, sOY, sLX, sLY = @get!
            oPX, oPY = o\get!
            return (_isWithin(oPX, oPY, sOX, sOY, sLX, sLY))
        elseif (_is(o, 'Line')) then return (@contains(o.Origin) and @contains(o.Ending))
        elseif (_is(o, 'Rectangle')) then
            for i,l in ipairs(o\getLines!) do
                if (@contains(l) == false) then return (false)
            return (true)
        (nil)
    render: =>
        sOX, sOY, sLX, sLY = @get!
        return ({ sOX, sOY, sOX, sLY,
            sOX, sLY, sLX, sLY,
            sLX, sLY, sLX, sOY,
            sLX, sOY, sOX, sOY })
    getLines: =>
        sOX, sOY, sLX, sLY = @get!
        return ({ Line(sOX, sOY, sOX, sLY),
            Line(sOX, sLY, sLX, sLY),
            Line(sLX, sLY, sLX, sOY),
            Line(sLX, sOY, sOX, sOY) })

class Polygon extends Shape
class Matrix
    __add: (Left, Right)->
    __sub: (Left, Right)->
    __div: (Left, Right)->
    __mul: (Left, Right)->
    __tostring: =>
    fill: ()=>
    dot: (VectorOrMatrix)=>
        sum = 0
        (sum)
    sum: =>
        sum = 0
        for k,v in pairs(@) do 
            for i,j in pairs(v) do
                sum += j
        (sum)
    maximum: =>
        found = -math.huge
        for k,v in pairs(@) do
            for i,j in pairs(v) do
                if (j > found) then found = j
        (found)
    minimum: =>
        found = math.huge
        for k, v in pairs(@) do for i, j in pairs(v) do
            if (j < found) then found = j
        (found)
    new: (arrays)=>
        if (type(TblOrDimensions) == 'table') then
            for k,v in ipairs(TblOrDimensions) do table.insert(@, k, v)
        elseif (type(TblOrDimensions) == 'number') then
            with Dimensions = TblOrDimensions do
                FillWith = (Lengths or 0)
                for i=1, Dimensions do
                    @[i] = {}
                    if (type(FillWith) == 'number') then
                        for j=1, Dimensions do @[i][j] = FillWith
                    elseif (type(FillWith) == 'table') then
                        for j,k in pairs(FillWith) do @[i][j] = k

-- @string
serialize = (obj, showIndices=false)->
    serial = ''
    switch type(obj)
        when 'table' do
            if (#obj == 0) then return ("{}") 
            serial ..= "{"
            for k,v in pairs(obj) do
                if (showIndices) then serial ..= "[#{k}]="
                serial ..= "#{serialize(v, showIndices)}, "
            serial = serial\sub(1, -3)
            serial ..= "}"
        when 'number' do serial ..= string.format('%d', obj)
        when 'string' do serial ..= string.format('%q', obj)
        else serial ..= "(#{tostring(obj)})"
    (serial)

-- @return @module
MTLibrary = { :_meta,
    logic: { :Container, :Timer, isAncestor: _isAncestor, are: _are, is: _is},
    math: {
        random: (tbl)->
            if (type(tbl) == 'table') then return (tbl[math.random(#tbl)])
            (math.random(tonumber(tbl or 1)))
        ifs: {
            sin: (x,y)-> math.sin(x), math.sin(y)
            sphere: (x,y)->
                fac = (1/(math.sqrt((x*x)+(y*y))))
                (fac*x), (fac*y)
            swirl: (x,y)->
                rsqr = math.sqrt((x*x)+(y*y))
                ((x*math.sin(rsqr))-(y*math.cos(rsqr))), ((x*math.cos(rsqr))+(y*math.sin(rsqr)))
            horseshoe: (x,y)->
                factor = (1/(math.sqrt((x*x)+(y*y))))
                (factor*((x-y)*(x+y))), (factor*(2*(x*y)))
            polar: (x,y) -> (math.atan(x/y)*math.pi), (((x*x)+(y*y))-1)
            handkerchief: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                (r*math.sin(arcTan+r)), (r*math.cos(arcTan-r))
            heart: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                (r*math.sin(arcTan*r)), (r*(-math.cos(arcTan*r)))
            disc: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                arctanPi = (arcTan*math.pi)
                (arctanPi*(math.sin(math.pi*r))), (arctanPi*(math.cos(math.pi*r)))
            spiral: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                factor = (1/(math.sqrt((x*x)+(y*y))))
                arcTan = math.atan(x/y)
                (factor*(math.cos(arcTan)+math.sin(r))), (factor*(math.sin(arcTan-math.cos(r))))
            hyperbolic: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                (math.sin(arcTan)/r), (r*math.cos(arcTan))
            diamond: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                (math.sin(arcTan*math.cos(r))), (math.cos(arcTan*math.sin(r)))
            ex: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                p0 = math.sin(arcTan+r)
                p0 = math.pow(p0,3)
                p1 = math.cos(arcTan-r)
                p1 = math.pow(p1,3)
                (r*(p0+p1)), (r*(p0-p1))
            julia: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                omega = if (math.random! >= 0.5) then math.pi else 0
                (r*(math.cos((arcTan*0.5)+omega))), (r*(math.sin((arcTan*0.5)+omega)))
            bent: (x,y)->
                if (x < 0 and y >= 0) then return (x*2), (y)
                elseif (x >= 0 and y < 0) then return (x), (y*0.5)
                elseif (x < 0 and y < 0) then return (x*2), (y*0.5)
                (x), (y)
            waves: (x,y, a, b, c, d, e, f)-> (x+b*math.sin(y/(c*c))), (y+e*math.sin(x/(f*f)))
            fisheye: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                factor = ((r+1)*0.5)
                (factor*y), (factor*x)
            eyefish: (x, y)->
                r = math.sqrt((x*x) + (y*y))
                factor = ((r + 1)*0.5)
                (factor*x), (factor*y)
            popcorn: (x,y, a, b, c, d, e, f)->
                (x+c*math.sin(math.tan(3*y))), (y+f*math.sin(math.tan(3*x)))
            power: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                factor = r^(math.sin(arcTan))
                (factor*(math.cos(arcTan))), (math.sin(arcTan))
            cosine: (x,y)-> (math.cos(math.pi*x)*math.cosh(y)), (-(math.sin(math.pi*x)*math.sinh(y)))
            rings: (x,y, a, b, c, d, e, f)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                factor = (r+(c*c))%(2*(c*c)-(c*c)+r*(1-(c*c)))
                (factor*math.cos(arcTan)), (factor*math.sin(arcTan))
            fan: (x,y, a, b, c, d, e, f)->
                t = (math.pi*(c*c))
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                if ((arcTan+f)%t) > (t*0.5) then
                    return (r*math.cos(arcTan-(t*0.5))), (r*math.sin(arcTan-(t*0.5)))
                (r*math.cos(arcTan+(t*0.5))), (r*math.sin(arcTan+(t*0.5)))
            blob: (x,y, b)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                factor = r*(b.Low+((b.High-b.Low)*0.5)*math.sin(b.Waves*arcTan)+1)
                (factor*math.cos(arcTan)), (factor*math.sin(arcTan))
            pdj: (x,y, a, b, c, d, e, f)-> (math.sin(a*y)-math.cos(b*x)), (math.sin(c*x)-math.cos(d*y))
            bubble: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                factor = (4/((r*r)+4))
                (factor*x), (factor*y)
            cylinder: (x,y)-> (math.sin(x)), (y)
            perspective: (x,y, angle, dist)->
                factor = dist/(dist-(y*math.sin(angle)))
                (factor*x), (factor*(y*math.cos(angle)))
            noise: (x,y)->
                rand = math.random(0,1)
                rand2 = math.random(0,1)
                (rand*(x*math.cos(2*math.pi*rand2))), (rand*(y*math.sin(2*math.pi*rand2)))
            pie: (x,y, slices, rotation, thickness)->
                t1 = truncate(math.random!*slices)
                t2 = rotation+((2*math.pi)/(slices))*(t1+math.random!*thickness)
                r0 = math.random!
                (r0*math.cos(t2)), (r0*math.sin(t2))
            ngon: (x,y, power, sides, corners, circle)->
                p2 = (2*math.pi)/sides
                iArcTan = math.atan(y/x)
                t3 = (iArcTan-(p2*math.floor(iArcTan/p2)))
                t4 = if (t3 > (p2*0.5)) then t3 else (t3-p2)
                k = (corners*(1/(math.cos(t4))+circle))/(math.pow(r,power))
                (k*x), (k*y)
            curl: (x,y, c1, c2)->
                t1 = (1+(c1*x)+c2*((x*x)-(y*y)))
                t2 = (c1*y)+(2*c2*x*y)
                factor = (1/((t1*t1)+(t2*t2)))
                (factor*((x*t1)+(y*t2))), (factor*((y*t1)-(x*t2)))
            rectangles: (x,y, rX, rY)-> (((2*math.floor(x/rX) + 1)*rX)-x), (((2*math.floor(y/rY)+1)*rY)-y)
            tangent: (x,y)-> (math.sin(x)/math.cos(y)), (math.tan(y))
            cross: (x,y)-> 
                factor = math.sqrt(1/(((x*x)-(y*y))*((x*x)-(y*y))))
                (factor*x), (factor*y)
        }
        :Shape, shapes: { :Circle, :Line, :Rectangle, :Polygon },
        :Dyad, :Tetrad, :Hexad, :Octad,
        :Vector, :Matrix, :truncate }, string: { :serialize, :split } }

-- @love
if love then
    -- @graphics
    class Projector
        scale: { x: 0, y: 0 }
        state: false
        new: ()=>
        setup: ()=>
        push: ()=>
        pop: ()=>
    class View
    class List extends View
    class Grid extends List
    class Element
    class Label extends Element
    class Button extends Element
    class Textbox extends Element
    class Picture extends Element

    MTLibrary.graphics = {
        :View, :List, :Grid, :Element, :Label,
        :Button, :Textbox, :Picture, :Atlas
        fit: (monitorRatio=1)->
            oldW, oldH, currentFlags = love.window.getMode!
            screen, window = {}, {}
            screen.w, screen.h = love.window.getDesktopDimensions(currentFlags.display)
            newWindowWidth = truncate(screen.w / monitorRatio)
            newWindowHeight = truncate(screen.h / monitorRatio)
            if (oldW == newWindowWidth) and (oldH == newWindowHeight) then return nil, nil
            window.display, window.w = currentFlags.display, newWindowWidth
            window.h = newWindowHeight
            window.x = truncate((screen.w*0.5) - (window.w*0.5))
            window.y = truncate((screen.h*0.5) - (window.h*0.5))
            currentFlags.x, currentFlags.y = window.x, window.y
            love.window.setMode(window.w, window.h, currentFlags)
            return screen, window
        getCenter: (offset, offsetY)->
            w, h = love.graphics.getDimensions!
            return ((w - offset) * 0.5), ((h - (offsetY or offset)) * 0.5)
    }

(MTLibrary)