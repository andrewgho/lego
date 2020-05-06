# OpenSCAD models for LEGO® bricks

This repository contains code to model LEGO® bricks with the OpenSCAD parametric
3D CAD software.

## Usage

```
include <lego.scad>

brick(4, 2);
translate([0, unit_width * 3, 0]) plate(2, 2);
translate([0, 0, brick_height * 2]) tile(4, 2);
```

## Constants

*   u - the so-called "LEGO unit" (1.6mm) which other measurements are defined
    in terms of.
*   u(n) - a helper function that multiples by LEGO units, because `u(5)` is
    significantly less verbose than `(u * 5)` in complex expressions.

Other absolute measurements in mm:

*   stud_height - height of a stud (1 unit).
*   brick_height - height of one brick without studs (6 units).
*   plate_height - height of one plate without studs, or of a tile (2 units).
*   unit_width - width of a one-stud brick or plate (5 units).
*   half_width - half the width of a one-stud bric or plate (2.5 units).

These are useful for positioning bricks in a model.

## Modules

=== brick

Create a brick with given dimensions.

```
brick(width, depth, height, studs = true/false, posts = true/false);
```

Parameters:

*   width, depth - dimensions of the brick, measured in studs.
*   height - absolute height of the brick without studs, measured in mm.
*   studs - if true (default), include studs on top and dimples underneath them.
*   posts - if true (default), include interior posts.

=== plate

Create a plate with given dimensions. A plate is a brick of one third height.

```
plate(width, depth, studs = true/false, posts = true/false);
```

Parameters:

*   width, depth - dimensions of the plate, measured in studs.
*   studs - if true (default), include studs on top and dimples underneath them.
*   posts - if true (default), include interior posts.

## tile

Create a tile with given dimensions. A tile is a plate without studs on top.

```
tile(width, depth, posts = true/false);
```

Parameters:

*   width, depth - dimensions of the plate, measured in studs.
*   posts - if true, include interior posts.

Interior posts are included by default, except for the special case of a 2x1 (or
1x2) tile, which has no interior post by default.

## References

*   https://bricks.stackexchange.com/questions/288/what-are-the-dimensions-of-a-lego-brick
*   https://www.bartneck.de/2019/04/21/lego-brick-dimensions-and-measurements/
*   http://www.robertcailliau.eu/en/Alphabetical/L/Lego/Dimensions/General%20Considerations/

## Legal

LEGO® is a trademark of the LEGO Group of companies which does not sponsor,
authorize or endorse this site.
