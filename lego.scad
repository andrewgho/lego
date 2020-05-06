// https://bricks.stackexchange.com/questions/288/what-are-the-dimensions-of-a-lego-brick
// https://www.bartneck.de/2019/04/21/lego-brick-dimensions-and-measurements/
// http://www.robertcailliau.eu/en/Alphabetical/L/Lego/Dimensions/General%20Considerations/

// 1 Lego Unit = 1.6mm
u = 1.6;
function u(n) = u * n;

stud_height = u;
brick_height = u(6);
plate_height = brick_height / 3;
tile_height = plate_height;
unit_width = u(5);
half_width = unit_width / 2;

/*

brick
-----

Create a brick with given dimensions.

```
brick(width, depth, height, studs = true/false, posts = true/false);
```

Parameters:

* width, depth - dimensions of the brick, measured in studs.
* height - absolute height of the brick without studs, measured in mm.
* studs - if true (default), include studs on top and dimples underneath them.
* posts - if true (default), include interior posts.

*/
module brick(width = 4, depth = 2, height = brick_height, studs = true, posts = true) {
  aw = width * u(5);  // absolute width in mm
  ad = depth * u(5);  // absolute depth in mm
  e = 0.1;        // small epsilon overlap to help rendering

  // Rectangular shell with interior cavity
  module shell() {
    difference() {
      cube([aw, ad, height]);
      translate([u, u, -e]) cube([aw - u(2), ad - u(2), (height - u) + e]);
    }
  }

  // Posts on bottom
  module posts() {
    if (width > 1 && depth > 1) {
      // Large hollow posts nestled underneath groups of four studs
      for(x = [0 : width - 2]) {
        for(y = [0 : depth - 2]) {
          ax = x * u(5);
          ay = y * u(5);
          if (width > 1 && depth > 1) {
            od = ((5 * sqrt(2)) - 3) * u;
            id = 4.80;
            translate([ax + u(5), ay + u(5), 0]) {
              difference() {
                cylinder(d = od, h = height);
                translate([0, 0, -e]) cylinder(d = id, h = height + e);
              }
            }
          }
        }
      }
    } else if (width > 1) {
      // Small solid posts between two linearly contiguous studs (x-axis)
      for(x = [0 : width - 2]) {
        translate([(x * u(5)) + u(5), u(5) / 2, 0])
          cylinder(d = u(2), h = height);
      }
    } else if (depth > 1) {
      // Small solid posts between two linearly contiguous studs (y-axis)
      for(y = [0 : depth - 2]) {
        translate([u(5) / 2, (y * u(5)) + u(5), 0])
          cylinder(d = u(2), h = height);
      }
    }
  }

  // Studs on top
  module studs() {
    for(x = [0 : width - 1]) {
      for(y = [0 : depth - 1]) {
        ax = x * u(5);
        ay = y * u(5);
        translate([ax + (u(5) / 2), ay + (u(5) / 2), height])
          cylinder(d = u(3), h = stud_height, center = true);
      }
    }
  }

  // Cutouts for interior dimples underneath studs
  module stud_dimples() {
    for(x = [0 : width - 1]) {
      for(y = [0 : depth - 1]) {
        ax = x * u(5);
        ay = y * u(5);
        translate([ax + (u(5) / 2), ay + (u(5) / 2), (height - u) - e])
          cylinder(d = u(1.5), h = u + e);
      }
    }
  }

  if (studs) {
    studs();
    difference() {
      shell();
      stud_dimples();
    }
  } else {
    shell();
  }
  if (posts) {
    posts();
  }
}

/*

plate
-----

Create a plate with given dimensions. A plate is a brick of one third height.

```
plate(width, depth, studs = true/false, posts = true/false);
```

Parameters:

* width, depth - dimensions of the plate, measured in studs.
* studs - if true (default), include studs on top and dimples underneath them.
* posts - if true (default), include interior posts.

*/
module plate(width, depth, studs = true, posts = true) {
  brick(width, depth, height = plate_height, studs = studs, posts = posts);
}

/*

tile
----

Create a tile with given dimensions. A tile is a plate without studs on top.

```
tile(width, depth, posts = true/false);
```

Parameters:

* width, depth - dimensions of the plate, measured in studs.
* posts - if true, include interior posts.

Interior posts are included by default, except for the special case of a 2x1
(or 1x2) tile, which has no interior post by default.

*/
module tile(width, depth, posts = undef) {
  function set_default(p) = posts == undef ?
    !((width == 2 && depth == 1) || (width == 1 && depth == 2)) : posts;
  plate(width, depth, studs = false, posts = set_default(posts));
  // TODO: add tiny bottom bevels around edge
}

$fn = 32;

gap_height = brick_height;

plate(8, 8);
translate([0, 0, plate_height + gap_height]) {
  brick(2, 2);
  translate([unit_width * 3, 0, 0]) brick(1, 2);
  translate([0, u(12), 0]) brick(4, 2);
  translate([0, u(24), 0]) brick(4, 1);
  translate([0, u(31), 0]) brick(1, 4);
  translate([u(10), u(31), 0]) brick(2, 3);
  translate([0, 0, brick_height + gap_height]) {
    plate(2, 2);
    translate([unit_width * 3, 0, 0]) plate(1, 2);
    translate([0, u(12), 0]) plate(4, 2);
    translate([0, u(24), 0]) plate(4, 1);
    translate([0, u(31), 0]) plate(1, 4);
    translate([u(10), u(31), 0]) plate(2, 3);
    translate([0, 0, plate_height + gap_height]) {
      tile(2, 2, posts = true);
      translate([unit_width * 3, 0, 0]) tile(1, 2);
      translate([0, u(12), 0]) tile(4, 2);
      translate([0, u(24), 0]) tile(4, 1);
      translate([0, u(31), 0]) tile(1, 4);
      translate([u(10), u(31), 0]) tile(2, 3);
    }
  }
}
