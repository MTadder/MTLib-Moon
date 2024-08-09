love = (love or nil) -- Autodetect LOVE2D
if (love == nil) then return {}

import Hexad from require([[math]])
import isCallable from require([[logic]])

-- @graphics
class ShaderCode -- GLSL ES Shader Syntax
    new:=> error!
class Projector
    new:=> error!
class View
    new: (oX, oY, w, h)=>
        error!
        @Position = Hexad(oX, oY)
        @Conf = { margin: 0 }
        @Canvas = love.graphics.newCanvas(w, h)
        (@)
    configure: (param, value)=>
        @Conf[param] = value
        (@)
    renderTo: (func)=>
        @Canvas\renderTo(func)
        (@)
class ListView extends View
    new:=> error!
class GridView extends ListView
    new:=> error!
class Element
    new:=>
        @Position = Hexad!
        (@)
class Label extends Element
    new:(text, alignment='center')=>
        error!
        @Text = (tostring(text) or [[NIL]])
        @Align = alignment
        (@)
    draw:=>
        if (love.graphics.isActive! == false) then return (nil)
        love.graphics.printf(@Text, @Position\get!, love.window.toPixels(#@Text))
        (@)
class Button extends Element
    new:=> error!
class Textbox extends Element
    new:=> error!
class Picture extends Element
    new: (f)=>
        error!
        @Image = love.graphics.newImage(f)
        (@)
    draw: (x, y, r, sX, sY)=>
        love.graphics.draw(@Image, x, y, r, sX, sY)
        (@)
    getPixel: (x, y)=> return (@Image\getData!)\getPixel(x, y)
    setPixel: (x, y, color)=>
        assert(#color == 4, [[color table must have 4 values]])
        iD = @Image\getData!
        iD\setPixel(x, y, color[1], color[2], color[3], color[4])
        @Image = love.graphics.newImage(iD)
        (@)
    map: (func, x, y, w, h)=>
        if isCallable(func) then
            iD = @Image\getData!
            iD\mapPixel(func, x, y, w, h)
            @Image = love.graphics.newImage(iD)
            (@)
    encode: (f, format)=> (@Image\getData!)\encode(format, f)
class PictureBatch extends Element
    draw: (id, x=0, y=0, r=0, sX=0, sY=0)=>
        love.graphics.draw(@Image, (@Quads[id] or nil), x, y, r, sX, sY)
        (@)
    new: (f, sprites)=>
        error!
        if @Image = love.graphics.newImage(f) then
            @Quads = {}
            for k,v in pairs(sprites) do
                assert(v.x and v.y and v.w and v.h)
                @Quads[k] = love.graphics.newQuad(v.x, v.y, v.w, v.h, @Image\getDimensions!)
        (@)

{
    :ShaderCode
    :View, :ListView, :GridView, :Element, :Label,
    :Button, :Textbox, :Picture, :PictureBatch,
    :Projector,
    patternColorizer: (str, colors)-> error!
    fit: (monitorRatio=1)->
        --oldW, oldH, currentFlags = love.window.getMode!
        --screen, window = {}, {}
        --screen.w, screen.h = love.window.getDesktopDimensions(currentFlags.display)
        --newWindowWidth = truncate(screen.w / monitorRatio)
        --newWindowHeight = truncate(screen.h / monitorRatio)
        --if ((oldW == newWindowWidth) and (oldH == newWindowHeight)) then return (nil), (nil)
        --window.display, window.w = currentFlags.display, newWindowWidth
        --window.h = newWindowHeight
        --window.x = math.floor((screen.w*0.5)-(window.w*0.5))
        --window.y = math.floor((screen.h*0.5)-(window.h*0.5))
        --currentFlags.x, currentFlags.y = window.x, window.y
        --love.window.setMode(window.w, window.h, currentFlags)
        --return (screen), (window)
        error!
    getCenter: (offset, offsetY)-> error!

}

{

}