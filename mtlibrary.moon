-- [ = [ --
META_INFO= [[KL0E]]
--  @MTLibrary Developed by A.G.W. / @MTadder
--  @Compatability list:
--      @Busted, @Ubuntu, @Windows (@x32 | @x64)
-- ] = ] --

state = class State
    members: {}
    _include: (members) =>
        for i,k in pairs(members) do @members[i] = k
        return @
    __add: (left, right) ->
        if type(right) == type(left) then
            if (left.__class == right.__class) then
                left\_include(right.members)
            else do left\_include(right)
            return left
    __call: (member, ...) =>
        for i,k in pairs(@members) do
            if (i == member) then
                return k(...)
        return nil
    new: (source) =>
        switch (type(source))
            when "table" do
                return (@ + source)
            when "string" do
                data = require(source)
                return (@ + dat)

MTLibrary = {
    Logic: {
        State: state
    }
    Math: {
        Quadra: class Quadra
            new: (X, Y, O, T) =>
                @x = (tonumber(X) or 0)
                @y = (tonumber(Y) or 0)
                @o = (tonumber(O) or 0)
                @t = (tonumber(T) or 0)
                return @
            __tostring: => return ("x=#{@x}, y=#{@y}, o=#{@o}, t=#{@t}")
            __add: (left, right) ->
                switch (type(left))
                    when "number" do
                        return Quadra(left+right.x, left+right.y,
                            left+right.o, left+right.t)
                    when "table" do
                        if type(right) == "number" then
                            return Quadra(left.x+right, left.y+right,
                                left.o+right, left.t+right)
                        if (left.__class != nil) then
                            if (left.__name == right.__name) then
                                return Quadra(left.x+right.x, left.y+right.y,
                                    left.o+right.o, left.t+right.t)
                error("Invalid addition! (#{type(left)} + #{type(right)})")
            __sub: (left, right) ->
                switch (type(left))
                    when "number" do
                        return Quadra(left-right.x, left-right.y,
                            left-right.o, left-right.t)
                    when "table" do
                        if type(right) == "number" then
                            return Quadra(left.x-right, left.y-right,
                                left.o-right, left.t-right)
                        if (left.__class != nil) then
                            if (left.__name == right.__name) then
                                return Quadra(left.x-right.x, left.y-right.y,
                                    left.o-right.o, left.t-right.t)
                error("Invalid subtraction! (#{type(left)} - #{type(right)})")
            __mul: (left, right) ->
                switch (type(left))
                    when "number" do
                        return Quadra(left*right.x, left*right.y,
                            left*right.o, left*right.t)
                    when "table" do
                        if type(right) == "number" then
                            return Quadra(left.x*right, left.y*right,
                                left.o*right, left.t*right)
                        if (left.__class != nil) then
                            if (left.__name == right.__name) then
                                return Quadra(left.x*right.x, left.y*right.y,
                                    left.o*right.o, left.t*right.t)
                error("Invalid multiplication! (#{type(left)} * #{type(right)})")
            __div: (left, right) ->
                switch (type(left))
                    when "number" do
                        return Quadra(left/right.x, left/right.y,
                            left/right.o, left/right.t)
                    when "table" do
                        if type(right) == "number" then
                            return Quadra(left.x/right, left.y/right,
                                left.o/right, left.t/right)
                        if (left.__class != nil) then
                            if (left.__name == right.__name) then
                                return Quadra(left.x/right.x, left.y/right.y,
                                    left.o/right.o, left.t/right.t)
                error("Invalid division! (#{type(left)} / #{type(right)})")
            __unm: => return Quadra(-@x, -@y, -@o, -@t)
        truncate: (value) ->
            if (value == nil) then return nil
            if (value >= 0) then return math.floor(value + 0.5)
            else do return math.ceil(value - 0.5)
    }
}

if describe != nil then -- @Busted Test
    print('\n'.."MTLibrary(#{META_INFO})-bust")
    return describe("MTLibrary", ()->
        it("has no nil-errors", ()->
            assert.has_no.errors(()->
                recurse=(target)->
                    for _, member in pairs(target)
                        if (type(member) == "function") then
                            member(nil)
                        elseif (type(member) == "table") then
                            if (member.__class == nil) then
                                recurse(member)
                recurse(MTLibrary)
            )
        )
        it("supports Quadra mathematics", ()->
            assert.has_no.errors(()->
                m1 = MTLibrary.Math.Quadra!
                m1 += 256
                -- m2 = m1 ^ 2 
                m2 = -m1 / 256
                --print m1, m2
            )
        )
        it("supports Stately mechanisms", ()->
            assert.has_no.errors(()->
                s1 = MTLibrary.Logic.State({'default'})
                s1 += {
                    foo:()->print("yeet")
                    woo:(...)->print(...)
                }
                --s1('foo')
                --s1('woo', 420, 'etc', 520)
            )
        )
    )

if love != nil then
    -- @LOVE Section
    -- export lSteam = require("luasteam")
    -- export sfxrl = require("sfxr")
    MTLibrary.Graphics={
        fit: (monitorRatio=1) ->
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
        getCenter: (offset, offsetY) ->
            w, h = love.graphics.getDimensions!
            return ((w - offset) * 0.5), ((h - (offsetY or offset)) * 0.5)
    }
    print "MTLibrary(#{META_INFO})-LOVE"
else do
    print "MTLibrary(#{META_INFO})"

-- class Element
--     Position: {X: 0, Y: 0, R: 0}, Velocity: {X: 0, Y: 0, R: 0},
--     Scale: {X: 1, Y: 1}, Offset: {X: 0, Y: 0, R: 0}, Drawable: nil
--     update: (dT) =>
--         if (@Velocity.R != 0) then
--             @Position.R += (@Velocity.R * dT)
--         if (@Velocity.X != 0) or (@Velocity.Y != 0) then
--             @move(@Velocity.X * dT, @Velocity.Y * dT)
--     draw: =>
--         if love.graphics.isActive! == false then return nil
--         if @Drawable == nil then return nil else
--             love.graphics.draw(@Drawable, @Position.X, @Position.Y,
--                 @Position.R + @Offset.R, @Scale.X, @Scale.Y,
--                 @Offset.X, @Offset.Y)
--     move: (ByX, ByY) =>
--         @Position.X, @Position.Y = (@Position.X + ByX), (@Position.Y + (ByY or ByX))
--     setPosition: (NewX, NewY) => @Position.X, @Position.Y = NewX, NewY
--     getPosition: => return (@Position.X), (@Position.Y)
--     applyForce: (Force, AngleForce, Angle) =>
--         if (Force == nil) and (AngleForce == nil) then return nil
--         if (Angle == nil) then Angle = @Position.R else Angle += @Position.R
--         @Velocity.R += (AngleForce or 0)
--         @Velocity.X += (math.cos(Angle) * Force)
--         @Velocity.Y += (math.sin(Angle) * Force)

-- class ProceduralSound
--     LSource: nil, SFXRSound: nil
--     new: (Generator, Seed=math.random!, AutoPlay=false, Loop=false) =>
--         @SFXRSound = sfxrl.newSound!
--         if SFXRGenerator = (@SFXRSound[Generator] or false) then
--             SFXRGenerator(@SFXRSound, Seed)
--         elseif SFXRGenerator = (@SFXRSound["random"..Generator] or false) then
--             SFXRGenerator(@SFXRSound, Seed)
--         else @SFXRSound\loadBinary(Generator)
--         @LSource = love.audio.newSource(@SFXRSound\generateSoundData!, "stream")
--         @LSource\setLooping Loop
--         if AutoPlay == true then @play!
--     save: (FileName) => @SFXRSound\saveBinary(FileName or tostring(os.time!))
--     play: => @LSource\play!
--     pause: => @LSource\pause!

-- class Picture extends Element
--     new: (ImagePath, ...) =>
--         @Drawable = love.graphics.newImage(ImagePath)
--         super(...)

-- class RenderTarget extends Picture
--     new: (x, y, width, height) =>
--         @PictureData = love.image.newImageData(width, height)
--         super(@PictureData, x, y)
--     interpret: (Mapper) =>
--         if type(Mapper) == "function" then
--             OldPicData = @PictureData
--             NewPicData = OldPicData
--             for xPos=1, oldLC\getWidth! do
--                 for yPos=1, oldLC\getHeight! do
--                     r, g, b, a = oldLC\getPixel(xPos, yPos)
--                     newX, newY = Mapper(xPos, yPos)
--                     NewPicData\setPixel(newX, newY, r, g, b, a)
--             @PictureData\paste(NewPicData)
--     noise: (amount=100, alpha=1) =>
--         mapper = (x, y, r, g, b, a) ->
--             mr = math.random
--             return x, y, mr(0,1)*amount, mr(0,1)*amount, mr(0,1)*amount, mr(0,1)*alpha
--         @interpret(mapper)

-- class Label extends Element
--     Alignment: 'center', Width: nil, Text: nil
--     new: (TextStr, ...) =>
--         @Text = TextStr
--         @Width = (#TextStr) * 12
--         super(...)
--     draw: => love.graphics.printf(@Text, @Position.X, @Position.Y, @Width, @Alignment,
--         @Position.R + @Offset.R, @Scale.X, @Scale.Y, @Offset.X, @Offset.Y)

-- class Button extends Element
-- class CheckBox extends Button
-- class Projector extends Element
--     push: =>
--         love.graphics.push!
--         love.graphics.rotate(@Position.R)
--         love.graphics.scale(@Scale.X, @Scale.Y)
--         love.graphics.translate(@Position.X, @Position.Y)
--     pop: => love.graphics.pop!

-- class GameState
--     Handlers: {}, Members: {}
--     setMember: (MemberIndex, MemberValue) =>
--         if @Members[MemberIndex] == nil then
--             @Members[MemberIndex] = MemberValue
--     tryMember: (MemberIndex, MemberHandle, ...) =>
--         if TargetMember = @Members[MemberIndex] then
--             if TargetMHandle = TargetMember[MemberHandle] then
--                 TargetMHandle(TargetMember, ...)
--     tryHandle: (HandleName, ...) =>
--         if HandlerCall = @Handlers[HandleName]
--             HandlerCall(@, ...)
--         if HandleName == "draw" then return
--         for MemberIndex, MemberValue in pairs @Members
--             if MemberCall = MemberValue[HandleName] then
--                 MemberCall(MemberValue, ...)
--     new: (Source) =>
--         SourceData = require(Source)
--         for HandleIndex, Handle in pairs(SourceData)
--             @Handlers[HandleIndex] = Handle

return (MTLibrary) or error("MTLibrary failure!")