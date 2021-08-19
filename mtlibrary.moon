--  @MTLibrary by @MTadder

class State
    _include: (Stack)=>
        for i,k in pairs(Stack) do @members[i] = k
        return @
    __add: (Left, Right)->
        if type(Right) == type(Left) then
            map = (if (Left.__class == Right.__class) then Right.members else Right)
            return Left\_include(map)
    __call: (Member, ...)=>
        if tgt = @members[Member] then
            if type(tgt) == 'function' then
                return tgt(...)
            return tgt
        elseif (Member == nil) then return @members
        return nil
    new: (Source)=>
        @members = {}
        if (Source == nil) then return @
        else switch type(Source)
            when 'table' do return (@ + Source)
            when 'string' do return (@ + require(Source))

-- class Brain
--     layers: {},
--     Cell: class Cell
--         excitement: 0, bias: 0, weights: {},
--         new: (Inputs, Bias=math.random!)=>
--             for i=1, Inputs do @weights[i] = (math.random! * 0.1)
--             @bias = Bias
--         activate: (Input, Threshold)=>
--             signal = @bias
--             for i=1, #@weights do signal += (@weights[i] * Input[i])
--             @excitement = 1 / (1 + math.exp((signal * -1) / Threshold))
--             return @excitement
--     createLayer: (Cells=1, Inputs=1)=>
--         layer = {}
--         for i=1, Cells do layer[i] = Cell(Inputs)
--         table.insert(@layers, layer)
--     new: (LayerCells, LearningRate, Threshold)=>
--         @createLayer(LayerCells[1], LayerCells[1])
--         for i=2, #LayerCells do @createLayer(LayerCells[1], LayerCells[i-1])
--         return @

class Quadra
    position: {x: nil, y: nil},
    velocity: {x: nil, y: nil},
    set: (Px, Py, Vx, Vy)=>
        @position.x = tonumber(Px or 0)
        @position.y = tonumber(Py or 0)
        @velocity.x = tonumber(Vx or 0)
        @velocity.y = tonumber(Vy or 0)
    step: (DeltaTime)=>
        if DeltaTime == nil then DeltaTime = love.timer.getDelta!
        if @velocity.x != 0 then @position.x += (@velocity.x * DeltaTime)
        if @velocity.y != 0 then @position.y += (@velocity.y * DeltaTime)
    impulse: (Angle, Force)=>
        @velocity.x += (math.cos(Angle) * Force)
        @velocity.y += (math.sin(Angle) * Force)
    new: (Px, Py, Vx, Vy)=> @set(Px, Py, Vx, Vy)
    
class Shape
    translation: { scale: 1, rotation: 0, position: Quadra! }
class Circle extends Shape
    new: (X, Y, Radius=1)=>
        @radius = tonumber(Radius)
        @position\set(X, Y)
class Rectangle extends Shape
    new: (X, Y, Width, Height)=>
        @dimensions = { width: Width, height: Height }
        @position\set(X, Y)
class Polygon extends Shape
    points: {}

if love then
    class View
    class List extends View
    class Grid extends List
    class Element
    class Label extends Element
        --  draw: => love.graphics.printf(@Text, @Position.X, @Position.Y, @Width, @Alignment,
        --      @Position.R + @Offset.R, @Scale.X, @Scale.Y, @Offset.X, @Offset.Y)
    class Button extends Element
    class Textbox extends Element
    class Picture extends Element
        --  new: (ImagePath, ...) =>
        --      @Drawable = love.graphics.newImage(ImagePath)

Serialize = (Object)->
    serial = ''
    switch type(Object)
        when "table" do
            serial ..= '{'
            for k,v in pairs(Object) do
                serial ..= "#{k}: #{Serialize(v)}, "
            if (serial\sub(-1) != '{') then serial = serial\sub(0, -3)
            serial ..= '}'
        when "function" do serial ..= "(#{tostring(Object)\gsub('function: ', '')})"
        when "thread" do serial ..= "[#{tostring(Object)\gsub('thread: ', '')}]"
        when "string" do serial ..= "'#{Object}'"
        else do serial ..= tostring(Object)
    return serial

class Combinator
    new: (combos)=>
        @banks = {}
        for k,v in pairs(combos) do
            if type(v) == 'string' then
                if rtn = dofile(v) then
                    if type(rtn) == 'table' then
                        @banks[k] = rtn
                else error("Combinator: lua file does not return a table: #{v}")
            elseif type(v) == 'table' then
                @banks[k] = v
    __tostring:=>
        combo = ''
        for k,bank in pairs(@banks) do
            combo ..= (bank[math.random(#bank)]..' ')
        return combo\sub(0, -2)

MTLibrary = {
    string:{ :Serialize, :Combinator }
    logic:{ :State }
    math:{ 
        :Quadra, :Shape, :Point, :Circle, :Rectangle, :Polygon,
        truncate: (value)->
            if (value == nil) then return nil
            if (value >= 0) then return math.floor(value + 0.5)
            else do return math.ceil(value - 0.5)
    }
}

if love then
    MTLibrary.graphics = {
        :View, :List, :Element, :Label,
        :Button, :Textbox, :Checkbox,
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
