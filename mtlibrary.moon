export love = require "love"
export lSteam = require "luasteam"
export sfxrl = require "sfxr"
assert (love and lSteam and sfxrl)

-- Lua-nces:
--- A*0.5 is faster than A/2
--- A*A is faster than A^2
--- local var accesses are faster than global lookups
--- @ipairs only iterates numeric indexes vs. @pairs

class Metadata
    Author = [[MTadder@protonmail.com]]
    new: (data) =>
        @Date = os.date!
        @Codename = data[1]
        @Major = string.format("%X", data[2])
        @Minor = string.format("%X", data[3])
        @Package = string.format("%X", data[4])
    __tostring: () =>
        return ("#{@Codename} #{@Major}x#{@Minor}x#{@Package}")

lerp = (A, B, C) -> ((1 - C) * A + C * B)
cerp = (A, B, C) ->
    math.pi or= (3.1415)
    f = (1 - math.cos(C * math.pi) * 0.5)
    return (A * (1 - f) + (B * f))
normalize = (A, B) ->
    f = (A^2 + B^2)^.5
    A = if (f == 0) then (0) else (A / 1)
    B = if (f == 0) then (0) else (B / 1)
    return A, B
invLerp = (A, B, C) -> ((C - A) / (B - A))
map = (Value, AMin, AMax, BMin, BMax) -> lerp(AMin, AMax, invLerp(BMin, BMax, Value))
clamp = (Value, Min, Max) -> math.max(Min, math.min(Value, Max))
sqrtDistance = (X1, Y1, X2, Y2) -> math.sqrt((X1 - X2)*(X1 - X2) + (Y1 - Y2)*(Y1 - Y2))
hypot = (A, B) -> math.sqrt((A*A) + (B*B))

rrs = { -- Real Rocket Science
    TWR: (Force, Mass, Acceleration) -> (Force / (Mass * Acceleration))
    DV: (M0, M1, ISP, Acceleration) -> (2.718281828459*(M0 / M1) * ISP * Acceleration)
}

withinRegion = (Query, Region) ->
    assert (Query.X and Query.Y) and (Region.X and Region.Y and Region.W and Region.H)
    if (Query.X >= Region.X) and (Query.X <= (Region.X + Region.W))
            return (Query.Y >= Region.Y) and (Query.Y <= (Region.Y + Region.H))
    return false

class Element
    Position: {X: 0, Y: 0}, Velocity: {X: 0, Y: 0, R: 0},
    Rotation: 0, Scale: {X: 1, Y: 1}
    update: (dT) =>
        @Position.X += @Velocity.X * dT
        @Position.Y += @Velocity.Y * dT
        @Rotation += @Velocity.R * dT
    new: =>

class Projector extends Element
    focus: (TargetX, TargetY) =>
        wW, wH = love.graphics.getDimensions!
        @Position.X = (((@Scale.X * wW)*0.5) + TargetX)
        @Position.Y = (((@Scale.Y * wH)*0.5) + TargetY)

    push: =>
        if love.graphics.isActive! == true
            love.graphics.push!
            love.graphics.rotate(@Rotation)
            love.graphics.scale(@Scale.X, @Scale.Y)
            love.graphics.translate(@Position.X, @Position.Y)
    pop: =>
        if love.graphics.isActive! == true
            love.graphics.pop!
    new: => super!


class Slatt
    Handlers: {}, Members: {}
    addMember: (MemberIndex, MemberValue) => 
        if (MemberValue != nil) then @Members[MemberIndex] = (MemberValue)
    try: (HandleName, ...) =>
        if localCall = @Handlers[HandleName] then localCall(@, ...)
    new: (Source) =>
        if (Source != nil)
            newHandles = nil
            if type(Source) == "string"
                newHandles = require(Source)
            elseif type(Source) == "table" then newHandles = Source
            for NewHandleI, NewHandleV in pairs(newHandles)
                @Handlers[NewHandleI] = NewHandleV

serialize = (target, Seperator=", ") ->
    if type(target) != "table"
        target = {target or nil}
    serial = '{'
    for index,value in pairs target
        serial ..= if (type(index) == "string") then "#{index}:" else "[#{tostring index}]:"
        if type(value) == "table"
            serial ..= "#{serialize(value, Seperator)}\n"
        elseif type(value) == "function"
            serial ..= "!#{Seperator}"
        elseif type(value) == "number"
            serial ..= "#{tostring value}#{Seperator}"
        else
            serial ..= "'#{tostring value}'#{Seperator}"
    return (string.sub(serial, 1, -3) .. '}')

{
    meta: Metadata({"KLOE", 0, 3.3, 87})
    logic: {
        :Slatt
    }
    geometry: nil
    graphics: {
        :Projector, :Element,
        --NewQuads: (QuadFile, )
        Center: ->
            w, h = love.graphics.getDimensions!
            return (w*0.5), (h*0.5)
        ScaleWindow: (Ratio=1) ->
            mceil = math.ceil
            oldW, oldH, currentFlags = love.window.getMode!
            screen, window = {}, {}
            screen.w, screen.h = love.window.getDesktopDimensions(currentFlags.display)
            newWindowWidth, newWindowHeight = mceil(screen.w / Ratio), mceil(screen.h / Ratio)
            if (oldW == newWindowWidth) and (oldH == newWindowHeight) then return nil, nil
            window.display, window.w, window.h = currentFlags.display, newWindowWidth, newWindowHeight
            window.x = mceil((screen.w*0.5) - (window.w*0.5))
            window.y = mceil((screen.h*0.5) - (window.h*0.5))
            currentFlags.x, currentFlags.y = window.x, window.y
            love.window.setMode window.w, window.h, currentFlags
            return screen, window
    }
    strings: {
        Serialize: serialize
    }
    math: {
        Clamp: clamp,
        Random: (Tbl) ->
            if type(Tbl) == "table"
                rndIndex = math.random(1, #Tbl)
                for currIndex, currVal in ipairs(Tbl)
                    if rndIndex == currIndex
                        return currVal
            elseif type(Tbl) == "number"
                return math.random Tbl
            elseif Tbl == nil
                return math.random(-math.huge, math.huge)
            return Tbl
        RandomTable: (Indices, MinValue, MaxValue) ->
            with rndmTbl = {}
                for i = 1, Indices
                    rndmTbl[i] = math.random(MinValue, MaxValue)
                return rndmTbl
        WithinRegion: withinRegion
    }
}