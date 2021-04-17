love = require "love"
assert love -- Make sure we can access the LÖVE

steam = require "luasteam"
assert steam -- Make sure we can access the Steam API

assertTypes = (ExpectedType, ...) ->
    if (type(ExpectedType) != 'string')
        error("Argument #1 must be a string. got '#{type ExpectedType}'.")
    for testIndex, testValue in pairs {...}
        if (type(testValue) != ExpectedType)
            error("Type mismatch at ##{testIndex}, expected a '#{ExpectedType}', got a '#{type(testValue)}'")

clampVal = (Val, Min, Max) ->
    return (math.max(Min, math.min(Val, Max)))

serializeTbl = (Tbl, Seperator) ->
    if type(Tbl) != "table" return tostring Tbl

    Seperator or= ", "
    serial = '{'
    for index,value in pairs Tbl
        valType = type value
        if valType == "table"
            serial ..= serializeTbl value, Seperator
        else
            serial ..= tostring(index) ..": " .. tostring(value) .. Seperator
    return string.sub(serial, 1, -3) .. '}'

withinRegion = (Query, Region) ->
    assertTypes "table", Query, Region
    if Query.x >= Region.x
        if Query.x <= (Region.x + Region.w)
            if Query.y >= Region.y
                if Query.y <= (Region.y + Region.h)
                    return true
    return false
fs = {
    Exists: (QueryPath) ->
        assertTypes "string", QueryPath
        foundFile = false
        with fStream = io.open QueryPath, 'r'
            if fStream == nil
                print("failed to find a file at '#{QueryPath}'")
            else
                foundFile = true
                fStream\close!
        return foundFile
}

class button -- ui
    new: (LabelText, XPos, YPos, Width, Height) =>
        assertTypes "string", LabelText
        assertTypes "number", XPos, YPos, Width, Height
        @text = LabelText
        @data = { x:XPos, y:YPos, w:Width, h:Height,
            hooks:{ hover:nil, press:nil},
            key:1}
    Hook: (func, isPress = true) =>
        assertTypes "function", func
        if isPress
            @data.hooks.press = func
        else
            @data.hooks.hover = func
    Update: () =>
        mouseX, mouseY = love.mouse.getPosition!
        if withinRegion({x:mouseX, y:mouseY}, @data)
            -- is hovering
            if @data.hooks.hover != nil
                @data.hooks.hover!
            if love.mouse.isDown @data.key
                -- is pressing using the proper key.
                if @data.hooks.press != nil
                    @data.hooks.press!
            

    Draw: () =>
        love.graphics.rectangle "line", @data.x, @data.y, @data.w, @data.h
        love.graphics.printf @text, @data.x, @data.y + 5, @data.w, "center"

-- class buttonBar -- TODO

-- Declare return module
{
    __Author: [[MTadder / Ayden G.W.]]
    __Version: (0xD + 0x1 + 0x3 + 0x6) /100
    __Date: [[04/10/21]]
    __Date_Format: [[MM/DD/YYYY]]
    
    logic: {
        AssertTypes: assertTypes
        State: class
            new: (Identifier) =>
                @id = Identifier
    }
    geometry: {
        Position: class
            new: (data) =>
                if type(data) == "number"
                    @pos = {data,data}
                else
                    error "Positional argument should be a number. not a #{type data}"
        Circle: class
            new: (Radius) =>
                assertTypes "number", Radius
                @radius = Radius
    }
    graphics: {
        Scale: (Ratio) ->
            -- Scale the LOVE window to the current display based on the provided ratio
            Ratio or= 1
            -- Fetch current window flags for persistence
            _, _, currentFlags = love.window.getMode!
            -- Setup screen table by fetching the monitor dimensions
            screen =
                w: nil
                h: nil
            with monW, monH = love.window.getDesktopDimensions currentFlags.display
                screen.w = monW
                screen.h = monH
            -- Calculate window data
            winW = math.floor(screen.w / Ratio)
            winH = math.ceil(screen.h / Ratio)
            window =
                x: math.floor((screen.w / 2) - (winW / 2))
                y: math.ceil((screen.h / 2) - (winH / 2))
            currentFlags.x = window.x
            currentFlags.y = window.y
            -- Tell LOVE to use this.
            love.window.setMode winW, winH, currentFlags
            return screen, window
        ui: {
            Button: button
            ButtonBar: buttonBar
        }
    }
    system: {
        files: fs
    }
    steam: {
        Begin: () ->
            steam.init!
        End: () ->
            steam.shutdown!
    }
    strings: {
        Deserialize: (Serial) -> -- Deserializes a serialized table with delimiters
            assertTypes "string", Serial
            return nil
        Serialize: (Tbl, Delimiter) -> -- Serialized a table with delimiters
            assertTypes "table", Tbl
            assertTypes "number", Delimiter
            serializeTbl(Tbl, Delimiter)
        RandomValue: (Tbl) ->
            return Tbl[math.random(1, #Tbl)]
    }
    math: {
        -- Linear Interpolation
        Lerp: (A, B, C) ->
            assertTypes "number", A, B, C
            return (1 - C) * A + C * B
        Distance: (X1, X2, Y1, Y2) ->
            assertTypes "number", X1, X2, Y1, Y2
            return (math.sqrt((X1 - X2)^2 + (Y1 - Y2)^2))
        Clamp: clampVal
        WithinRegion: withinRegion
    }
}