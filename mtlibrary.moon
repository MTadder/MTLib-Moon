love = require "love"
export lSteam = require "luasteam"
assert love, lSteam

unpack or= table.unpack

lerp = (A, B, C) ->
    return ((1 - C) * A + C * B)
cerp = (A, B, C) ->
    math.pi or= (3.1415)
    f = (1 - math.cos(C * math.pi) * 0.5)
    return (A * (1 - f) + (B * f))
normalize = (A, B) ->
    f = (A^2 + B^2)^.5
    A = if (f == 0) then (0) else (A / 1)
    B = if (f == 0) then (0) else (B / 1)
    return A, B
invLerp = (A, B, C) ->
    return ((C - A) / (B - A))
map = (Value, AMin, AMax, BMin, BMax) ->
    return lerp(AMin, AMax, invLerp(BMin, BMax, Value))
clamp = (Value, Min, Max) ->
    return math.max(Min, math.min(Value, Max))
sqrDistance = (X1, Y1, X2, Y2) ->
    return math.sqrt((X1 - X2)^2 + (Y1 - Y2)^2)
withinRegion = (Query, Region) ->
    assert Query.X and Query.Y and Region.X and Region.Y and Region.W and Region.H
    if (Query.X >= Region.X) and Query.X <= (Region.X + Region.W)
            return (Query.Y >= Region.Y) and Query.Y <= (Region.Y + Region.H)
    false

serializeTbl = (Tbl, Seperator=", ") ->
    if type(Tbl) != "table"
        Tbl = {Tbl or nil}
    serial = '{'
    for index,value in pairs Tbl
        serial ..= if (type(index) == "string") then "#{index}:" else "[#{tostring index}]:"
        if type(value) == "table"
            serial ..= "#{serializeTbl(value, Seperator)}\n"
        elseif type(value) == "function"
            serial ..= "!#{Seperator}"
        elseif type(value) == "number"
            serial ..= "#{tostring value}#{Seperator}"
        else
            serial ..= "'#{tostring value}'#{Seperator}"
    return (string.sub(serial, 1, -3) .. '}')

class Color
    new: (R=1, G=1, B=1, A=1) =>
        @data = { :R, :G, :B, :A }
    __tostring: () =>
        return "{R=#{@data.R}, G=#{@data.G}, B=#{@data.B}, A=#{@data.A}}"
    __eq: (To) =>
        rCompEq = (@data.R == To.data.R)
        gCompEq = (@data.G == To.data.G)
        bCompEq = (@data.B == To.data.B)
        aCompEq = (@data.A == To.data.A)
        return ( rCompEq and gCompEq and bCompEq and aCompEq )
    __mul: (By) =>
        if type(By) == "number"
            for dataIndex,dataValue in ipairs(@data)
                @data[dataIndex] = (dataValue * By)
        elseif By.__name == @__name
            @data.R *= By.R
            @data.G *= By.G
            @data.B *= By.B
            @data.A *= By.A

class RenderTarget
    new: (W, H) => 
        @target = love.image.newImageData(W, H)
    draw: (X, Y) =>
        targetImage = love.graphics.newImage @target
        love.graphics.draw targetImage, X, Y
    getSize: () =>
        return {W:@target\getWidth!, H:@target\getHeight!}
    getPixel: (X, Y) =>
        return Color(unpack(@target\getPixel(X,Y)))
    setPixel: (X, Y, pixelColor) =>
        if @target != nil
            @target\setPixel X, Y, pixelColor.R, pixelColor.G, pixelColor.B, pixelColor.A
            return true
        return false
    encode: (DestinationFile, Format="png") =>
        return @target\encode Format, "#{DestinationFile}.#{Format}"

class Button
    new: (Label, Geometry) =>
        @data = { :Label, :Geometry, State:0 }
    update: () =>
        if @data.Geometry
            @data.State = @data.Geometry\getState!
    draw: (Mode="line") =>
        @data.Geometry\draw Mode
        width = (@data.Geometry.W or @data.Geometry.Radius)
        love.graphics.printf @data.Label, @data.Geometry.X, @data.Geometry.Y + 5, width, "center"

class Shape
    new: (Pos={X:0, Y:0}) =>
        @X, @Y = Pos.X, Pos.Y
    getState: () =>
        if @test != nil
            return @test({X: love.mouse.getX!, Y: love.mouse.getY!})
        else return (0)

class Circle extends Shape
    new: (Radius, Pos) =>
        assert Radius
        super(Pos)
        @Radius = Radius
    draw: (Mode="line") =>
        love.graphics.circle(Mode, @X, @Y, @Radius)
    test: (Pos) =>
        assert Pos and (Pos.X and Pos.Y)
        if sqrDistance(@X, @Y, Pos.X, Pos.Y) <= @Radius
            if love.mouse.isDown 1
                return (2)
            return (1)
        return (0)

class Rectangle extends Shape
    new: (Dimens, Pos) =>
        assert Dimens and (Dimens.W and Dimens.H) and Pos and (Pos.X and Pos.Y)
        super(Pos)
        @data.W, @data.H = Dimens.W, Dimens.H
    draw: (Mode="line")=>
        love.graphics.rectangle(Mode, @data.X, @data.Y, @data.W, @data.H)
    test: (Pos) =>
        if withinRegion(Pos, @data)
            if love.mouse.isDown 1
                return (2)
            return (1)
        return (0)

class Slate
    new: () =>
        @data = {Bank:{}, }

        
{
    __Author: [[MTadder]]
    __Version: [[Erutrun]]
    __Date: [[04/23/21]]
    __Date_Format: [[MM/DD/YYYY]]

    logic: {
        :Shape
    }
    geometry: {
        :Circle
        :Rectangle
    }
    graphics: {
        :Color
        :Button
        :RenderTarget
        :Slate

        ScaleWindow: (Ratio=1) ->
            _,_, currentFlags = love.window.getMode!
            screen = {}
            screen.w, screen.h = love.window.getDesktopDimensions currentFlags.display
            winW = math.floor screen.w / Ratio
            winH = math.ceil screen.h / Ratio
            window =
                x: math.floor((screen.w / 2) - (winW / 2))
                y: math.ceil((screen.h / 2) - (winH / 2))
            currentFlags.x = window.x
            currentFlags.y = window.y
            love.window.setMode winW, winH, currentFlags
            return screen, window
    }
    strings: {
        Serialize: serializeTbl
    }
    math: {
        Lerp: lerp
        Cerp: cerp
        InverseLerp: invLerp
        Map: map
        Distance: sqrDistance
        Random: (Tbl) ->
            if type(Tbl) == "table"
                rndIndex = math.random(1, #Tbl)
                for currIndex, currVal in ipairs Tbl
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
        Clamp: clamp
        WithinRegion: withinRegion
    }
}