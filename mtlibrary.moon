meta = {
    name: 'MTLibrary'
    author: 'MTadder'
    version: {
        major: 0
        minor: 6
        revision: 3
        __tostring: => return ("#{major}.#{minor}.#{revision}")
    }
    date: 'Nov. 6th, 2021'
}

-- @logic
class Timer
    Duration: 0,
    Remainder: 0,
    Looping: false,
    On_Completion: ()->nil
    new: (duration, on_complete, looping=false)=>
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
                return false, @On_Completion!
            return true, @On_Completion!
        else return false, nil

class Container
    items: {}
    top: => return (@items[#@items] or nil)
    pop: =>
        if got = @top! then @items[#@items] = nil 
        return (got or nil)
    insert: (item, atKey)=>
        if (type(item) == 'table') then
            @items[atKey] = {i,k for i,k in pairs(item)}
        else do @items[atKey] = item
        return (@)
    __add: (item)=> return @push(item)
    __call: (target, ...)=>
        if item = @items[target] then
            if (type(item) == 'function') then
                return item(...)
            else return (item or nil)
        return (nil)
    new: (initial)=>
        if (initial != nil) then return (@ + intial)
        else return (@)
    forEach: (action)=> return {key,action(val, key) for key,val in pairs(@items)}

-- @math
sigmoid = (x)-> (1 / (1 + math.exp(-x)))
class Dyad
    position: {x: nil, y: nil},
    lerp: (t)=> (@position.x + (@position.y - @position.x) * t)
    set: (p1, p2)=>
        @position.x = tonumber(p1 or 0)
        @position.y = tonumber(p2 or 0)
    new: (p1, p2)=>
        @set(p1, p2)
class Tetrad extends Dyad
    velocity: {x: nil, y: nil},
    set: (p1, p2, v1, v2)=>
        @position.x = tonumber(p1 or @position.x or 0)
        @position.y = tonumber(p2 or @position.y or 0)
        @velocity.x = tonumber(v1 or @velocity.x or 0)
        @velocity.y = tonumber(v2 or @velocity.y or 0)
    update: (deltaTime)=>
        if deltaTime == nil then deltaTime = love.timer.getDelta!
        if (@velocity.x != 0) then @position.x += (@velocity.x * deltaTime)
        if (@velocity.y != 0) then @position.y += (@velocity.y * deltaTime)
    impulse: (angle, force)=>
        @velocity.x += (math.cos(angle) * force)
        @velocity.y += (math.sin(angle) * force)
    new: (p1, p2, v1, v2)=>
        @set(p1, p2, v1, v2)
class Hexad extends Tetrad
    rotator: {value: 0, velocity: 0},
    torque: (by)=> @rotator.velocity += tonumber(by)
    update: (deltaTime)=>
        @rotator.value += (@rotator.velocity * deltatime)
        super\update(deltaTime)
class Octad extends Hexad
    dimensional: {position: 0, velocity: 0},
    slant: (by)=> @dimensional.velocity += tonumber(by)
    update: (deltaTime)=>
        @dimensional.position += (@dimensional.velocity * deltaTime)
        super\update(deltaTime)
truncate = (value)->
    if (value == nil) then return nil
    if (value >= 0) then return math.floor(value + 0.5)
    else do return math.ceil(value - 0.5)
class Shape
    translation: Tetrad!
    distance: (toShape)=>
        return math.sqrt((@translation.position.x - toShape.position.x)^2 +
            (@translation.position.y - toShape.position.y)^2)
    draw: => nil
class Circle extends Shape
    new: (x, y, radius=1, mode='line')=>
        @radius = tonumber(radius)
        @mode = tostring(mode)
        @position\set(x, y)
    draw: =>
        love.graphics.circle(@mode, @position.x, @position.y, @radius)
class Line extends Shape
    endPoint: Dyad!
    new: (oX, oY, eX, eY)=>
        @position.set()
class Rectangle extends Shape
    new: (X, Y, Width, Height)=>
        @dimensions = { width: Width, height: Height }
        @position\set(X, Y)
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
        return sum
    sum: =>
        sum = 0
        for k, v in pairs(@) do 
            for i, j in pairs(v) do
                sum += j
        return sum
    maximum: =>
        found = -math.huge
        for k, v in pairs(@) do
            for i, j in pairs(v) do
                if j > found then found = j
        return found
    minimum: =>
        found = math.huge
        for k, v in pairs(@) do
            for i, j in pairs(v) do
                if j < found then found = j
        return found
    new: (arrays)=>
        if type(TblOrDimensions) == 'table' then
            for k, v in ipairs(TblOrDimensions) do
                table.insert(@, k, v)
        elseif type(TblOrDimensions) == 'number' then
            with Dimensions = TblOrDimensions do
                FillWith = (Lengths or 0)
                for i=1, Dimensions do
                    @[i] = {}
                    if type(FillWith) == 'number' then
                        for j=1, Dimensions do @[i][j] = FillWith
                    elseif type(FillWith) == 'table' then
                        for j, k in pairs(FillWith) do @[i][j] = k

-- @string
serialize = (Object, Indentation=1)->
    serial = ''
    switch type(Object)
        when "table" do
            serial ..= '{\n'
            serial ..= string.rep(' ', Indentation)
            for k, v in pairs(Object) do
                serial ..= "[#{k}]=#{serialize(v, Indentation+1)}, "
            serial ..= '\n'..string.rep(' ', Indentation-1)..'}'
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

-- @graphics
class View
class List extends View
class Grid extends List
class Element
class Label extends Element
class Button extends Element
class Textbox extends Element
class Picture extends Element

-- @module
MTLibrary = {
    logic: {
        :Container, :Timer,
    },
    math: { 
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
