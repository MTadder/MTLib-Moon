-- MTLibrary 0.5.9.21 (major.minor.dd.yy)
-- by MTadder

-- @logic
class Container
    members: {}
    top: => return @members[#@members]
    pop: =>
        if got = @top! then @members[#@members] = nil 
        return (got or nil)
    push: (newMembers)=>
        if (type(newMembers) == 'table')
            for i,k in pairs(newMembers) do @members[i] = k
        else do table.insert(@members, newMembers)
        return @
    __add: (left, right)->
        if (type(right) == type(left)) then
            map = (if left.__class == right.__class then right.members else right)
            return left\push(map)
    __call: (target, ...)=>
        if member = @members[target] then
            if (type(member) == 'function') then
                return member(...)
            return member
        else return nil
    forEach: (action)=>
        results = {}
        for k,v in pairs(@members) do
            table.insert(results, k, action(v, k))
        return results
    new: (members)=>
        if (members != nil) then return (@ + members)
        return @

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
        if @velocity.x != 0 then @position.x += (@velocity.x * deltaTime)
        if @velocity.y != 0 then @position.y += (@velocity.y * deltaTime)
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
    return serial
split = (str, delimiter)->
    assert(type(str)=='string')
    with res = {}
        regex = ("([^%s]+)")\format(delimiter)
        for m in str\gmatch(regex) do
            table.insert(res, m)
        return res

-- @graphics
class View
class List extends View
class Grid extends List
class Element
class Label extends Element
class Button extends Element
class Textbox extends Element
class Picture extends Element
class Atlas extends Picture

-- @module
MTLibrary = {
    logic: {
        :Container
    }
    math: { 
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
