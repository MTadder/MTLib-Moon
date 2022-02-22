## Lua MTLibrary
*logic and utility-focused lua classes written in [Moonscript](https://github.com/leafo/moonscript) [with bindings for [LÖVE2D](https://github.com/love2d/love)]*

[![Badge](https://img.shields.io/badge/v-0.60.31-informational)](https://shields.io)

![Logo](MTLibrary_Lua.png "MTLibrary:Lua")

## Module Contents
`table.`
- `isArray` : `function(tbl)`
- `contains` : `function(tbl, obj)`
- `instances` : `function(tbl, obj)`
- `removeInstances` : `function(tbl, obj)`
- `isUnique` : `function(tbl)`

`MTLibrary.`
- `logic.`
  - `Timer` : `class`
    - `new` : `function(duration, onComplete, loop)`
    - `update` : `function(dT)`
    - `restart` : `function()`
    - `isComplete` : `function()`
  - `nop` : `function()`
  - `newArray` : `function(count, fillWith)`
  - `is` : `function(val, ofClass)`
  - `isAncestor` : `val, ofClass`
  - `are` : `function(tbl, ofClass)`
  - `areAncestors` : `function(tbl, ofClass)`
- `math.`
  - `sigmoid` : `function(x)`
    > returns `(1 / (1 + math.exp(-x)))`
  - `Dyad` : `class`
    - `new` : `function(x, y)`
    > 2-float object, representing a position
    - `lerp` : `function(t)`
    > returns the linear interpolation between `x, y` at `t`
  - `Tetrad` : `class`
    - `new` : `function(x, y, vX, vY)`
    > 4-float object, additionally representing velocity
    - `impulse` : `function(angle, force)`
    - `update` : `function(deltaTime)`
  - `Hexad` : `class extends Tetrad`
    > 6-float object, additionally representing rotation & rotational velocity
    - `update` : `function(deltaTime)`
  - `Octad` : `class extends Hexad`
    > 8-float object, additionally representing dimension & dimensional velocity
    - `update` : `function(deltaTime)`
  - `Shape` : `class`
    > Abstract class for shapely facilities.
  - `shapes.`
    - `Circle` : `class`
    - `Line` : `class`
    - `Rectangle` : `class`
    - `Polygon` : `class`
  - `random` : `function(tbl)`
  - `ifs.`
    > Iterable Function Systems
    - `sin` : `function(x, y)`
    - `sphere` : `function(x, y)`
    - `swirl` : `function(x, y)`
    - `horseshoe` : `function(x, y)`
    - `polar` : `function(x, y)`
    - `handkerchief` : `function(x, y)`
    - `heart` : `function(x, y)`
    - `disc` : `function(x, y)`
    - `spiral` : `function(x, y)`
    - `hyperbolic` : `function(x, y)`
    - `diamond` : `function(x, y)`
    - `exponential` : `function(x, y)`
    - `julia` : `function(x, y)`
    - `bent` : `function(x, y)`
    - `waves` : `function(x, y, a, b, c, d, e, f)`
    - `fisheye` : `function(x, y)`
    - `eyefish` : `function(x, y)`
    - `popcorn` : `function(x, y, a, b, c, d, e, f)`
    - `power` : `function(x, y)`
    - `cosine` : `function(x, y)`
    - `rings` : `function(x, y, a, b, c, d, e, f)`
    - `fan` : `function(x, y, a, b, c, d, e, f)`
    - `blob` : `function(x, y, b)`
    - `pdj` : `function(x, y, a, b, c, d, e, f)`
    - `bubble` : `function(x, y)`
    - `cylinder` : `function(x, y)`
    - `perspective` : `function(x, y, angle, dist)`
    - `noise` : `function(x, y)`
    - `pie` : `function(x, y, slices, rot, thickness)`
    - `ngon` : `function(x, y, pow, sides, corners, circle)`
    - `curl` : `function(x, y, c1, c2)`
    - `rectangles` : `function(x, y, rX, rY)`
    - `tangent` : `function(x, y)`
    - `cross` : `function(x, y)`
- `string.`
  - `split` : `function(delimiter)`
  - `serialize` : `function(object)`
    > Returns a table-style string representation of `object`
    > In the case that `object` is not of `type` `table`, `number` or `string`,
    > the `object` is converted to a string with `tostring`, and encased in parentheses, then returned.
    > Examples:
    > `Serialize( {'foo': 'bar', bizz: {nil, nil, 5}} )`
    > `> '{foo: 'bar', bizz: {3: (5)}}'`
    > `Serialize( {'foo': ()->, bizz: {nil, 5}} )`
    > `> '{foo: (function: 0x...), bizz: {2: 5}}'`

if `love` is `not nil`, everything below is also included in the *Module*
- `graphics.`
  - `View` : `class`
  - `List` : `class extends View`
  - `Grid` : `class extends List`
  - `Element` : `class`
  - `Label` : `class extends Element`
  - `Button` : `class extends Element`
  - `Textbox` : `class extends Element`
  - `Picture` : `class extends Element`
  - `fit` : `function(Ratio)`
    > sets the LÖVE window size to a ratio of the current monitor's size
    > returns the screen's size, and the window's size
  - `getCenter` : `function()`
    > returns the X, and Y coordinates of the screen center

  Lots to do, still