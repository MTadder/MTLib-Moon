meta = {
    name: 'MTLibrary'
    author: 'MTadder'
    version: {
        major: 0
        minor: 6
        revision: 7
        str:-> return ("#{major}.#{minor}.#{revision}")
    }
    date: 'Nov. 6th, 2021'
}

-- @logic
class Exception
    Message: "", CallsError: false,
    new: (message, callsError=false)=> @Message, @CallsError = message, callsError
    __call:=> if (@CallsError) then error(@message)

class Timer
    Duration: 0,
    Remainder: 0,
    Looping: false,
    On_Completion: ()->nil
    On_Update: (time_left)->nil
    new: (duration, on_complete, on_update, looping=false)=>
        @Duration, @Looping, @On_Completion = duration, looping, on_complete
        @restart!
    restart: ()=> @Remainder = @Duration
    finished: ()=> return ((@Remainder <= 0) and (@Looping == false))
    update: (dT)=>
        assert(dT, "timer.update called without a deltaTime argument!")
        assert(type(dT) == 'number', "timer.update was called with a #{type(dT)} deltaTime argument!")
        @Remainder -= dt
        if (@Remainder <= 0) then
            if (@Looping == true) then
                @restart!
            return (@Looping == false), @On_Completion!
        else return false, nil

class Container
    Items: {}
    Keys: {}
    get: (key)=> for k,k2 in ipairs(@Keys) do if (k2 == key) then return (@Items[k])
    getKey: (item)=>
        for k,i in ipairs(@Items) do
            if (i == item) then
                for k2,k3 in ipairs(@Keys) do
                    if (k2 == k) then return (k3)
        (nil)
    count: ()=> ((#@Items) or 0)
    top: => (@Items[@count!])
    pop: =>
        if item = @top! then @Items[@count!] = nil
        (item or nil)
    insert: (item, key)=>
        if (type(item) == 'table') then
            for k,v in pairs(item) do @insert(v, k)
        else do @Items[#@Items+1], @Keys[#@Keys+1] = item, (key or @count!+1)
    __call: (item, key)=>
        @insert(item, key)
        (@)
    new: (initial)=>
        @insert(initial)
        (@)
    iterator: ()=>
        i, keys, items = 0, @Keys, @Items
        ()->
            i += 1
            item = items[i]
            if (item == nil) then item = items[keys[i]]
            if (item != nil) then return keys[i], item
            (nil)
    forEach: (action)=> {key,action(key, val) for key,val in @iterator!}

-- @math
_sigmoid = (x)-> (1/(1+math.exp(-x)))
_lerp = (a,b,t)-> (a+(b-a)*t)
_intersects = (o1x, o1y, e1x, e1y, o2x, o2y, e2x, e2y)->
    -- adapted from https://gist.github.com/Joncom/e8e8d18ebe7fe55c3894
    s1x, s1y = (e1x - o1x), (e1y - o1y)
    s2x, s2y = (e2x - o2x), (e2y - o2y)
    s = (-s1y * (o1x - o2x) + s1x * (o1y - o2y)) / (-s2x * s1y + s1x * s2y)
    t = ( s2x * (o1y - o2y) - s2y * (o1x - o2x)) / (-s2x * s1y + s1x * s2y)
    return (s >= 0 and s <= 1 and t >= 0 and t <= 1)

class Dyad
    lerp: (o, t)=>
        if (o.__class.__name == "Dyad") then
            @Position.x = _lerp(@Position.x, o.Position.x, tonumber(t))
            @Position.y = _lerp(@Position.y, o.Position.y, tonumber(t))
        return @Position.x, @Position.y
    set: (x, y)=>
        @Position or= {}
        @Position.x, @Position.y = tonumber(x or 0), tonumber(y or 0)
    get: => return unpack({ @Position.x, @Position.y })
    equals: (o)=>
        if (o.Position != nil) then
            posEq = (@Position.x == o.Position.x and @Position.y == o.Position.y)
            return posEq
        (false)
    __tostring:=> ("D{#{@Position.x}, #{@Position.y}}")
    new: (x, y)=> @set(x, y)
class Tetrad extends Dyad
    lerp: (o, t)=>
        super\lerp(o, t)
        if (o.Velocity != nil) then
            @Velocity.x = _lerp(@Velocity.x, o.Position.x, tonumber(t))
            @Velocity.y = _lerp(@Velocity.y, o.Position.y, tonumber(t))
        (@)
    distance: (o)=>
        if (o.Position != nil) then
            return (math.sqrt(math.pow(o.Position.x-@Position.x, 2)+
                math.pow(o.Position.y - @Position.y, 2)))
        (0)
    set: (p1, p2, v1, v2)=>
        super\set(p1, p2)
        @Velocity or= {}
        @Velocity.x, @Velocity.y = tonumber(v1 or 0), tonumber(v2 or 0)
    get: => return unpack({
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
    set: (p1, p2, v1, v2, r, rV)=>
        super\set(p1, p2, v1, v2)
        @Rotator or= {}
        @Rotator.value, @Rotator.inertia = tonumber(r or 0), tonumber(rV or 0)
    get: => return unpack({
        @Position.x, @Position.y,
        @Velocity.x, @Velocity.y,
        @Rotator.value, @Rotator.inertia })
    update: (dT=(1/60)) =>
        super\update(dT)
        @Rotator.value += (@Rotator.inertia*dT)
    torque: (by)=> @Rotator.inertia += tonumber(by)
    __tostring: => (super.__tostring(@))..("H{#{@Rotator.value}, #{@Rotator.inertia}}")
    new: (p1, p2, v1, v2, r, rv)=> @set(p1, p2, v1, v2, r, rV)
class Octad extends Hexad
    set: (p1, p2, v1, v2, r, rV, dA, dE)=>
        super\set(p1, p2, v1, v2, r, rV)
        @Dimensional or= {}
        @Dimensional.address, @Dimensional.entropy = tonumber(dA or 0), tonumber(dE or 0)
    get: => return unpack({
        @Position.x, @Position.y,
        @Velocity.x, @Velocity.y,
        @Rotator.value, @Rotator.inertia,
        @Dimensional.address, @Dimensional.entropy })
    shake: (by)=> @Dimensional.entropy += tonumber(by)
    update: (dT=(1/60))=>
        super\update(dT)
        @Dimensional.address += (@Dimensional.entropy*dT)
    __tostring: => (super.__tostring(@))..("O{#{@Dimensional.address}, #{@Dimensional.entropy}}")
    new: (p1, p2, v1, v2, r, rv, dA, dE)=> @set(p1, p2, v1, v2, r, rV, dA, dE)
truncate = (value)->
    if (value == nil) then return (0)
    if (value >= 0) then return math.floor(value+0.5)
    math.ceil(value-0.5)
class Shape
    set: (oX, oY)=>
        @Origin or= Dyad(tonumber(oX or 0), tonumber(oY or 0))
    __tostring: => ("S{#{tostring(@Origin)}}")
    new: (oX, oY)=> @set(oX, oY)
class Circle extends Shape
    set: (oX, oY, radi)=>
        super\set(oX, oY)
        @Radius or= tonumber(radi or math.pi)
    draw: (mode) => love.graphics.circle(mode, @Origin.x, @Origin.y, @Radius)
    __tostring: => super.__tostring(@)..("C{#{@Radius}}")
    new: (x, y, rad)=> @set(x, y, rad)
class Line extends Shape
    set: (oX, oY, eX, eY)=>
        super\set(oX, oY)
        @Ending or= Dyad(eX, eY)
    get: => return unpack({
        @Origin.Position.x, @Origin.Position.y,
        @Ending.Position.x, @Ending.Position.x })
    getDistance: (o)=> return nil
    getLength: =>
        sOX, sOY = @Origin\get!
        sEX, sEY = @Ending\get!
        return math.sqrt(math.pow(sEX-sOX,2)+math.pow(sEY-sOY, 2))
    getSlope: => return ((@Ending.Position.x-@Origin.Position.x)/(@Ending.Position.y-@Origin.Position.y))
    intersects: (o)=>
        if (o.__class.__name == "Line") then
            sOX, sOY, sEX, sEY = @get!
            oOX, oOY, oEX, oEY = o\get!
            if (_intersects(sOX, sOY, sEX, sEY, oOX, oOY, oEX, oEY)) then return (true)
            return (false)
        return (nil)
    __tostring: => super.__tostring(@)..("-->{#{tostring(@Ending)}}")
    new: (oX, oY, eX, eY)=> @set(oX, oY, eX, eY)
class Rectangle extends Shape
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
        if (o.__class.__name == "Dyad") then
            sOX, sOY, sLX, sLY = @get!
            pos = (o.Position or error("o.Position is nil!"))
            return ((pos.x > sOX and pos.x < sLX) and (pos.y < sOY and pos.y <= sLY))
        if (o.__class.__name == "Line") then
            for i,line in ipairs(@\getLines!) do
                if (o\intersects(line)) then return (true)
            return (o\contains(@Origin) or o\contains(@Ending))
        if (o.__class.__name == "Rectangle") then
            sOX, sOY, sLX, sLY = @get!
            oOX, oOY, oLX, oLY = o\get!
            return ((oOX > sOX and oOY > sOY) and (oEX < sLX and oLY < sLY))
        (nil)
    getLines: =>
        sOX, sOY, sLX, sLY = @get!
        return ({
            [1]: Line(sOX, sOY, sOX, sLY),
            [2]: Line(sOX, sLY, sLX, sLY),
            [3]: Line(sLX, sLY, sLX, sOY),
            [4]: Line(sLX, sOY, sOX, sOY) })
    new: (oX, oY, lX, lY)=> @set(oX, oY, lX, lY)
class Polygon extends Shape
    points: {}
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
        return found
    minimum: =>
        found = math.huge
        for k, v in pairs(@) do
            for i, j in pairs(v) do
                if (j < found) then found = j
        return found
    new: (arrays)=>
        if (type(TblOrDimensions) == 'table') then
            for k,v in ipairs(TblOrDimensions) do
                table.insert(@, k, v)
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
serialize = (Object, ShowIndices=false, Indentation=1)->
    serial = ''
    switch type(Object)
        when 'table' do
            serial ..= "{\n"
            serial ..= string.rep(' ', Indentation)
            for k,v in pairs(Object) do
                if (ShowIndices) then serial ..= "[#{k}]="
                serial ..= "#{serialize(v, ShowIndices, Indentation+1)}, "
            serial ..= "\n#{string.rep(' ', Indentation-1)}}"
        when 'number' do serial ..= string.format('%d', Object)
        when 'string' do serial ..= string.format('%q', Object)
        else do serial ..= "(#{tostring(Object)})"
    return (serial)
split = (str, delimiter)->
    assert(type(str) == 'string')
    with res = {}
        regex = ("([^%s]+)")\format(delimiter)
        for m in str\gmatch(regex) do
            table.insert(res, m)
        return (res)

-- @module
MTLibrary = {
    :meta, 
    logic: {
        :Container, :Timer,

    },
    math: {
        random: (tbl)->
            if (type(tbl) == 'table') then return (tbl[math.random(#tbl)])
            else return math.random(tonumber(tbl))
        ifs: {
            sin: (x,y)-> return math.sin(x), math.sin(y)
            sphere: (x,y)->
                fac = (1/(math.sqrt((x*x)+(y*y))))
                return fac*x, fac*y
            swirl: (x,y)->
                rsqr = math.sqrt((x*x)+(y*y))
                return ((x*math.sin(rsqr))-(y*math.cos(rsqr))), ((x*math.cos(rsqr))+(y*math.sin(rsqr)))
            horseshoe: (x,y)->
                factor = (1/(math.sqrt((x*x)+(y*y))))
                return factor*((x-y)*(x+y)), factor*(2*(x*y))
            polar: (x,y) -> return math.atan(x/y)*math.pi, ((x*x)+(y*y))-1
            handkerchief: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                return r*math.sin(arcTan+r), r*math.cos(arcTan-r)
            heart: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                return r*math.sin(arcTan*r), r*(-math.cos(arcTan*r))
            disc: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                arctanPi = (arcTan*math.pi)
                return arctanPi*(math.sin(math.pi*r)), arctanPi*(math.cos(math.pi*r))
            spiral: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                factor = (1/(math.sqrt((x*x)+(y*y))))
                arcTan = math.atan(x/y)
                return factor*(math.cos(arcTan)+math.sin(r)), factor*(math.sin(arcTan-math.cos(r)))
            hyperbolic: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                return math.sin(arcTan)/r, r*math.cos(arcTan)
            diamond: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                return math.sin(arcTan*math.cos(r)), math.cos(arcTan*math.sin(r))
            ex: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                p0 = math.sin(arcTan+r)
                p0 = math.pow(p0,3)
                p1 = math.cos(arcTan-r)
                p1 = math.pow(p1,3)
                return r*(p0+p1), r*(p0-p1)
            julia: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                omega = if (math.random! >= 0.5) then math.pi else 0
                return r*(math.cos((arcTan*0.5)+omega)), r*(math.sin((arcTan*0.5)+omega))
            bent: (x,y)->
                if (x < 0 and y >= 0) then return x*2, y
                elseif (x >= 0 and y < 0) then return x, y*0.5
                elseif (x < 0 and y < 0) then return x*2, y*0.5
                else do return x, y
            waves: (x,y, a, b, c, d, e, f)->
                return (x+b*math.sin(y/(c*c))), (y+e*math.sin(x/(f*f)))
            fisheye: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                factor = ((r+1)*0.5)
                return factor*y, factor*x
            eyefish: (x, y)->
                r = math.sqrt((x*x) + (y*y))
                factor = ((r + 1)*0.5)
                return factor*x, factor*y
            popcorn: (x,y, a, b, c, d, e, f)->
                return (x+c*math.sin(math.tan(3*y))), (y+f*math.sin(math.tan(3*x)))
            power: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                factor = r^(math.sin(arcTan))
                return factor*(math.cos(arcTan)), (math.sin(arcTan))
            cosine: (x,y)->
                return (math.cos(math.pi*x)*math.cosh(y)), -(math.sin(math.pi*x)*math.sinh(y))
            rings: (x,y, a, b, c, d, e, f)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                factor = (r+(c*c))%(2*(c*c)-(c*c)+r*(1-(c*c)))
                return factor*math.cos(arcTan), factor*math.sin(arcTan)
            fan: (x,y, a, b, c, d, e, f)->
                t = (math.pi*(c*c))
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                if ((arcTan+f)%t) > (t*0.5) then
                    return r*math.cos(arcTan-(t*0.5)), r*math.sin(arcTan-(t*0.5))
                else do return r*math.cos(arcTan+(t*0.5)), r*math.sin(arcTan+(t*0.5))
            blob: (x,y, b)->
                r = math.sqrt((x*x)+(y*y))
                arcTan = math.atan(x/y)
                factor = r*(b.Low+((b.High-b.Low)*0.5)*math.sin(b.Waves*arcTan)+1)
                return factor*math.cos(arcTan), factor*math.sin(arcTan)
            pdj: (x,y, a, b, c, d, e, f)->
                return (math.sin(a*y) - math.cos(b*x)), (math.sin(c*x) - math.cos(d*y))
            bubble: (x,y)->
                r = math.sqrt((x*x)+(y*y))
                factor = (4/((r*r)+4))
                return factor*x, factor*y
            cylinder: (x,y)-> return math.sin(x), y
            perspective: (x,y, angle, dist)->
                factor = dist/(dist-(y*math.sin(angle)))
                return factor*x, factor*(y*math.cos(angle))
            noise: (x,y)->
                rand = math.random(0,1)
                rand2 = math.random(0,1)
                return rand*(x*math.cos(2*math.pi*rand2)), rand*(y*math.sin(2*math.pi*rand2))
            pie: (x,y, slices, rotation, thickness)->
                t1 = truncate(math.random!*slices)
                t2 = rotation+((2*math.pi)/(slices))*(t1+math.random!*thickness)
                r0 = math.random!
                return r0*math.cos(t2), r0*math.sin(t2)
            ngon: (x,y, power, sides, corners, circle)->
                p2 = (2*math.pi)/sides
                iArcTan = math.atan(y/x)
                t3 = (iArcTan-(p2*math.floor(iArcTan/p2)))
                t4 = if (t3 > (p2*0.5)) then t3 else (t3-p2)
                k = (corners*(1/(math.cos(t4))+circle))/(math.pow(r,power))
                return k*x, k*y
            curl: (x,y, c1, c2)->
                t1 = (1+(c1*x)+c2*((x*x)-(y*y)))
                t2 = (c1*y)+(2*c2*x*y)
                factor = (1/((t1*t1)+(t2*t2)))
                return factor*((x*t1)+(y*t2)), factor*((y*t1)-(x*t2))
            rectangles: (x,y, rX, rY)-> return (((2*math.floor(x/rX) + 1)*rX)-x), (((2*math.floor(y/rY)+1)*rY)-y)
            tangent: (x,y)-> return (math.sin(x)/math.cos(y)), math.tan(y)
            cross: (x,y)-> 
                factor = math.sqrt(1/(((x*x)-(y*y))*((x*x)-(y*y))))
                return factor*x, factor*y
        }
        :Shape, shapes: {
            :Circle, :Line, :Rectangle, :Polygon
        }
        :Dyad, :Tetrad, :Hexad, :Octad,
        :Vector, :Matrix
        :truncate,
    }
    string: {
        :serialize, :split
    }
}

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

return MTLibrary
