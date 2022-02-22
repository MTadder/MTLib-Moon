## Lua MTLibrary
*logic and utility-focused lua classes written in [Moonscript](https://github.com/leafo/moonscript) [with bindings for [LÖVE2D](https://github.com/love2d/love)]*

[![forthebadge](data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIxMTAuNjEwMDAwMDAwMDAwMDEiIGhlaWdodD0iMzUiIHZpZXdCb3g9IjAgMCAxMTAuNjEwMDAwMDAwMDAwMDEgMzUiPjxyZWN0IGNsYXNzPSJzdmdfX3JlY3QiIHg9IjAiIHk9IjAiIHdpZHRoPSIzNS41NiIgaGVpZ2h0PSIzNSIgZmlsbD0iIzAwMDAwMCIvPjxyZWN0IGNsYXNzPSJzdmdfX3JlY3QiIHg9IjMzLjU2IiB5PSIwIiB3aWR0aD0iNzcuMDUwMDAwMDAwMDAwMDEiIGhlaWdodD0iMzUiIGZpbGw9IiMzODlBRDUiLz48cGF0aCBjbGFzcz0ic3ZnX190ZXh0IiBkPSJNMTYuNTEgMjJMMTMuNDYgMTMuNDdMMTUuMDggMTMuNDdMMTcuMjIgMjAuMTRMMTkuMzkgMTMuNDdMMjEuMDIgMTMuNDdMMTcuOTUgMjJMMTYuNTEgMjJaIiBmaWxsPSIjRkZGRkZGIi8+PHBhdGggY2xhc3M9InN2Z19fdGV4dCIgZD0iTTQ3LjMyIDE3LjgwTDQ3LjMyIDE3LjgwUTQ3LjMyIDE2LjQ1IDQ3Ljc5IDE1LjQ2UTQ4LjI2IDE0LjQ2IDQ5LjEwIDEzLjk1UTQ5Ljk1IDEzLjQzIDUxLjAyIDEzLjQzTDUxLjAyIDEzLjQzUTUyLjA5IDEzLjQzIDUyLjkzIDEzLjk1UTUzLjc3IDE0LjQ2IDU0LjI1IDE1LjQ2UTU0LjcyIDE2LjQ1IDU0LjcyIDE3LjgwTDU0LjcyIDE3LjgwUTU0LjcyIDE5LjE1IDU0LjI1IDIwLjE1UTUzLjc3IDIxLjE0IDUyLjkzIDIxLjY1UTUyLjEwIDIyLjE3IDUxLjAyIDIyLjE3TDUxLjAyIDIyLjE3UTQ5Ljk1IDIyLjE3IDQ5LjEwIDIxLjY1UTQ4LjI2IDIxLjE0IDQ3Ljc5IDIwLjE1UTQ3LjMyIDE5LjE2IDQ3LjMyIDE3LjgwWk00OS43MCAxNy44MEw0OS43MCAxNy44MFE0OS43MCAxOS4wNiA1MC4wNiAxOS42NFE1MC40MSAyMC4yMiA1MS4wMiAyMC4yMkw1MS4wMiAyMC4yMlE1MS42MyAyMC4yMiA1MS45OCAxOS42NFE1Mi4zNCAxOS4wNiA1Mi4zNCAxNy44MEw1Mi4zNCAxNy44MFE1Mi4zNCAxNi41NCA1MS45OCAxNS45NlE1MS42MyAxNS4zOCA1MS4wMiAxNS4zOEw1MS4wMiAxNS4zOFE1MC40MSAxNS4zOCA1MC4wNiAxNS45NlE0OS43MCAxNi41NCA0OS43MCAxNy44MFpNNTguOTMgMjAuNzVMNTguOTMgMjAuNzVRNTguOTMgMjAuMTUgNTkuMzIgMTkuNzhRNTkuNzEgMTkuNDEgNjAuMzAgMTkuNDFMNjAuMzAgMTkuNDFRNjAuOTAgMTkuNDEgNjEuMjkgMTkuNzhRNjEuNjcgMjAuMTUgNjEuNjcgMjAuNzVMNjEuNjcgMjAuNzVRNjEuNjcgMjEuMzQgNjEuMjggMjEuNzJRNjAuODkgMjIuMTEgNjAuMzAgMjIuMTFMNjAuMzAgMjIuMTFRNTkuNzIgMjIuMTEgNTkuMzMgMjEuNzJRNTguOTMgMjEuMzQgNTguOTMgMjAuNzVaTTY1LjkwIDE4LjAzTDY1LjkwIDE4LjAzUTY1LjkwIDE2LjU5IDY2LjQ2IDE1LjU1UTY3LjAxIDE0LjUxIDY4LjAyIDEzLjk3UTY5LjAzIDEzLjQzIDcwLjM2IDEzLjQzTDcwLjM2IDEzLjQzUTcxLjA4IDEzLjQzIDcxLjczIDEzLjU5UTcyLjM4IDEzLjc0IDcyLjgzIDE0LjA0TDcyLjgzIDE0LjA0TDcxLjk3IDE1Ljc1UTcxLjM2IDE1LjMxIDcwLjQyIDE1LjMxTDcwLjQyIDE1LjMxUTY5LjUxIDE1LjMxIDY4Ljk1IDE1LjgyUTY4LjM4IDE2LjMyIDY4LjMwIDE3LjI3TDY4LjMwIDE3LjI3UTY5LjAyIDE2LjY1IDcwLjIwIDE2LjY1TDcwLjIwIDE2LjY1UTcwLjk5IDE2LjY1IDcxLjY1IDE2Ljk4UTcyLjMwIDE3LjMxIDcyLjY5IDE3LjkxUTczLjA4IDE4LjUyIDczLjA4IDE5LjMwTDczLjA4IDE5LjMwUTczLjA4IDIwLjE1IDcyLjY1IDIwLjgwUTcyLjIxIDIxLjQ2IDcxLjQ2IDIxLjgyUTcwLjcxIDIyLjE3IDY5Ljc4IDIyLjE3TDY5Ljc4IDIyLjE3UTY3Ljk5IDIyLjE3IDY2Ljk0IDIxLjEwUTY1LjkwIDIwLjAzIDY1LjkwIDE4LjAzWk02OC40NyAxOS40Mkw2OC40NyAxOS40MlE2OC40NyAxOS44OSA2OC43OCAyMC4xOFE2OS4xMCAyMC40OCA2OS42NCAyMC40OEw2OS42NCAyMC40OFE3MC4xNSAyMC40OCA3MC40NiAyMC4xOVE3MC43OCAxOS45MCA3MC43OCAxOS40MUw3MC43OCAxOS40MVE3MC43OCAxOC45MyA3MC40NiAxOC42NFE3MC4xNSAxOC4zNSA2OS42MyAxOC4zNUw2OS42MyAxOC4zNVE2OS4xMiAxOC4zNSA2OC43OSAxOC42NVE2OC40NyAxOC45NCA2OC40NyAxOS40MlpNNzcuMDkgMjAuNzVMNzcuMDkgMjAuNzVRNzcuMDkgMjAuMTUgNzcuNDggMTkuNzhRNzcuODcgMTkuNDEgNzguNDYgMTkuNDFMNzguNDYgMTkuNDFRNzkuMDUgMTkuNDEgNzkuNDQgMTkuNzhRNzkuODIgMjAuMTUgNzkuODIgMjAuNzVMNzkuODIgMjAuNzVRNzkuODIgMjEuMzQgNzkuNDMgMjEuNzJRNzkuMDQgMjIuMTEgNzguNDYgMjIuMTFMNzguNDYgMjIuMTFRNzcuODggMjIuMTEgNzcuNDggMjEuNzJRNzcuMDkgMjEuMzQgNzcuMDkgMjAuNzVaTTgzLjYwIDIxLjM0TDgzLjYwIDIxLjM0TDg0LjQ2IDE5LjU1UTg0Ljk1IDE5Ljg4IDg1LjU3IDIwLjA3UTg2LjE5IDIwLjI1IDg2Ljc5IDIwLjI1TDg2Ljc5IDIwLjI1UTg3LjQwIDIwLjI1IDg3Ljc2IDIwLjAyUTg4LjEyIDE5Ljc5IDg4LjEyIDE5LjM3TDg4LjEyIDE5LjM3UTg4LjEyIDE4LjU1IDg2Ljg0IDE4LjU1TDg2Ljg0IDE4LjU1TDg1Ljg0IDE4LjU1TDg1Ljg0IDE3LjA1TDg3LjM0IDE1LjQ0TDg0LjAzIDE1LjQ0TDg0LjAzIDEzLjYwTDkwLjEwIDEzLjYwTDkwLjEwIDE1LjA5TDg4LjM2IDE2Ljk2UTg5LjQwIDE3LjE4IDg5Ljk2IDE3LjgyUTkwLjUyIDE4LjQ2IDkwLjUyIDE5LjM3TDkwLjUyIDE5LjM3UTkwLjUyIDIwLjExIDkwLjEyIDIwLjc1UTg5LjcxIDIxLjM5IDg4Ljg5IDIxLjc4UTg4LjA3IDIyLjE3IDg2Ljg2IDIyLjE3TDg2Ljg2IDIyLjE3UTg1Ljk3IDIyLjE3IDg1LjEwIDIxLjk1UTg0LjIzIDIxLjc0IDgzLjYwIDIxLjM0Wk05NS45OSAxNS40NEw5NC40MyAxNS40NEw5NC40MyAxMy42MEw5OC4zNyAxMy42MEw5OC4zNyAyMkw5NS45OSAyMkw5NS45OSAxNS40NFoiIGZpbGw9IiNGRkZGRkYiIHg9IjQ2LjU2Ii8+PC9zdmc+)](https://forthebadge.com)

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