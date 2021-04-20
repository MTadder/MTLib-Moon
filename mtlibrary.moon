love = require "love"
sfxrl = require "sfxr"
assert love, sfxrl

assertTypes = (ExpectedTypes, ...) -> -- Call an error if any of the arg's type does not match the first arg
    if (type(ExpectedTypes) != 'string')
        error("Argument #1 must be a string. got '#{type ExpectedTypes}'.")
    for testIndex, testValue in pairs {...}
        if (type(testValue) != ExpectedTypes)
            error("Type mismatch at ##{testIndex}, expected a '#{ExpectedTypes}', got a '#{type(testValue)}'")

clampValue = (Value, Min, Max) ->  -- Clamp a value between two others
    return (math.max(Min, math.min(Value, Max)))

serializeTbl = (Tbl, Seperator=", ") ->
    if type(Tbl) != "table" return tostring Tbl
    serial = '{'
    for index,value in pairs Tbl
        valType = type value
        if valType == "table"
            serial ..= serializeTbl value, Seperator
        else
            serial ..= tostring(index) ..": " .. tostring(value) .. Seperator
    return string.sub(serial, 1, -3) .. '}'

withinRegion = (Query, Region) -> -- Test if a position lies within a bounding region
    assertTypes "table", Query,Region
    assert Query.X and Query.Y and Region.X and Region.Y and Region.W and Region.H
    if Query.X >= Region.X and Query.X <= (Region.X + Region.W)
            if Query.Y >= Region.Y and Query.Y <= (Region.Y + Region.H)
                    return true
    return false

fileExists: (QueryPath) -> -- Tests if a file exists at a path
    assertTypes "string", QueryPath
    with fStream = io.open QueryPath, 'r'
        if fStream != nil
            fStream\close!
            return true
    print("failed to find a file at '#{QueryPath}'")
    return false

class loveColor
    new: (R, G, B, A=1) =>
        assertTypes "number", R,G,B,A
        @data = { :R, :G, :B, :A }

class button
    new: (Label, X, Y, W, H) =>
        assertTypes "string", Label
        assertTypes "number", X,Y,W,H
        @data = { :Label, :X, :Y, :W, :H, Key:1, IsPressed: false, IsHovered: false }
    Update: () =>
        mousePos = {X: love.mouse.getX!, Y: love.mouse.getY!}
        if withinRegion mousePos, @data
            @data.IsHovered = true
            if love.mouse.isDown @data.Key
                @data.IsPressed = true
        else 
            @data.IsHovered = false
    Draw: () =>
        love.graphics.rectangle "line", @data.X, @data.Y, @data.W, @data.H
        love.graphics.printf @data.Label, @data.X, @data.Y + 5, @data.W, "center"

{
    __Author: [[MTadder]]
    __Version: [[Blue Geanie]]
    __Date: [[04/19/21]]
    __Date_Format: [[MM/DD/YYYY]]
    logic: {
    }
    geometry: {
    }
    graphics: {
        ScaleWindow: (Ratio=1) ->
            _,_, currentFlags = love.window.getMode!
            screen = {}
            monW, monH = love.window.getDesktopDimensions currentFlags.display
            screen.w = monW
            screen.h = monH
            winW = math.floor screen.w / Ratio
            winH = math.ceil screen.h / Ratio
            window =
                x: math.floor((screen.w / 2) - (winW / 2))
                y: math.ceil((screen.h / 2) - (winH / 2))
            currentFlags.x = window.x
            currentFlags.y = window.y
            love.window.setMode winW, winH, currentFlags
            return screen, window
        ui: {
            Button: button
        }
        RenderTarget: class
            new: (W, H) => 
                @target = love.graphics.newImageData(W, H)
            GetSize: () =>
                return {W:@target\getWidth!, H:@target\getHeight!}
            Sample: (X, Y) =>
                return loveColor(unpack(@target\getPixel(X,Y)))
            Paint: (X, Y, Color) =>
                if @target
                    @target\setPixel X, Y, unpack(Color.data)
                    return true
                return false
            Encode: (DestinationFile, Format="png") =>
                if @target\getSize! > 1
                    @target\encode Format, DestinationFile
                    return true
                return false
    }
    system: {
        Exists: fileExists
    }
    sound: {

    }
    strings: {
        Deserialize: (Serial) ->
            assertTypes "string", Serial
            return nil
        Serialize: (Tbl, Delimiter) ->
            assertTypes "table", Tbl
            assertTypes "number", Delimiter
            serializeTbl(Tbl, Delimiter)
    }
    math: {
        Lerp: (A, B, C) ->
            assertTypes "number", A, B, C
            return (1 - C) * A + C * B
        Distance: (X1, X2, Y1, Y2) ->
            assertTypes "number", X1, X2, Y1, Y2
            return (math.sqrt((X1 - X2)^2 + (Y1 - Y2)^2))
        RandomValue: (Tbl) ->
            return Tbl[math.random(1, #Tbl)] or (math.random -math.huge!, math.huge!)
        RandomTable: (Indices, MinValue, MaxValue, Scale) ->
            rndmTbl = {}
            for i = 1, Indices
                rndmTbl[i] = math.random(MinValue, MaxValue) * Scale
            return rndmTbl
        Clamp: clampValue
        WithinRegion: withinRegion
    }
}