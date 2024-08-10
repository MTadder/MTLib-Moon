love = (love or nil) -- Autodetect LOVE2D
if (love == nil) then return (nil)
import graphics, window from love

import Hexad from require([[mtlib.math]])
import isCallable from require([[mtlib.logic]])
import types from require([[mtlib.constants]])
import FileGenerator from require([[mtlib.fs]]).generators

-- @graphics
class Projector
    new:=> error!
class View
    new: (oX, oY, w, h)=>
        error!
        @Position = Hexad(oX, oY)
        @Conf = { margin: 0 }
        @Canvas = graphics.newCanvas(w, h)
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
        if (graphics.isActive! == false) then return (nil)
        graphics.printf(@Text, @Position\get!, window.toPixels(#@Text))
        (@)
class Button extends Element
    new:=> error!
class Textbox extends Element
    new:=> error!
class Picture extends Element
    new: (f)=>
        error!
        @Image = graphics.newImage(f)
        (@)
    draw: (x, y, r, sX, sY)=>
        graphics.draw(@Image, x, y, r, sX, sY)
        (@)
    getPixel: (x, y)=> return (@Image\getData!)\getPixel(x, y)
    setPixel: (x, y, color)=>
        assert(#color == 4, [[color table must have 4 values]])
        iD = @Image\getData!
        iD\setPixel(x, y, color[1], color[2], color[3], color[4])
        @Image = graphics.newImage(iD)
        (@)
    map: (func, x, y, w, h)=>
        if isCallable(func) then
            iD = @Image\getData!
            iD\mapPixel(func, x, y, w, h)
            @Image = graphics.newImage(iD)
            (@)
    encode: (f, format)=> (@Image\getData!)\encode(format, f)
class PictureBatch extends Element
    draw: (id, x=0, y=0, r=0, sX=0, sY=0)=>
        graphics.draw(@Image, (@Quads[id] or nil), x, y, r, sX, sY)
        (@)
    new: (f, sprites)=>
        error!
        if @Image = graphics.newImage(f) then
            @Quads = {}
            for k,v in pairs(sprites) do
                assert(v.x and v.y and v.w and v.h)
                @Quads[k] = graphics.newQuad(v.x, v.y, v.w, v.h, @Image\getDimensions!)
        (@)

class ConfigGenerator extends FileGenerator -- TODO
class MainGenerator extends FileGenerator -- TODO

unused = true

{
    :ShaderCode
    :View
    :ListView
    :GridView
    :Element
    :Label
    :Button
    :Textbox
    :Picture
    :PictureBatch
    :Projector
    generators: {
        :MainGenerator
		:ConfigGenerator
    }
    patternColorizer: (str, colors)-> error!
    scaleWindow: (ratio=1)->
        --oldW, oldH, currentFlags = window.getMode!
        --screen, window = {}, {}
        --screen.w, screen.h = window.getDesktopDimensions(currentFlags.display)
        --newWindowWidth = truncate(screen.w / monitorRatio)
        --newWindowHeight = truncate(screen.h / monitorRatio)
        --if ((oldW == newWindowWidth) and (oldH == newWindowHeight)) then return (nil), (nil)
        --window.display, window.w = currentFlags.display, newWindowWidth
        --window.h = newWindowHeight
        --window.x = math.floor((screen.w*0.5)-(window.w*0.5))
        --window.y = math.floor((screen.h*0.5)-(window.h*0.5))
        --currentFlags.x, currentFlags.y = window.x, window.y
        --window.setMode(window.w, window.h, currentFlags)
        --return (screen), (window)
        error!
    getCenter: (offset, offsetY)-> error!
}