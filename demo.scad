// demo.scad - demonstrate rendering example LEGO bricks
// Andrew Ho (andrew@zeuscat.com)

include <lego.scad>;

$fn = 32;
gap_height = brick_height;

// Base plate
plate(4, 12);

// Bricks
translate([0, 0, plate_height + gap_height]) {
  brick(2, 2);
  translate([unit_width(3), 0, 0]) brick(1, 2);
  translate([0, unit_width(3), 0]) brick(4, 2);
  translate([0, unit_width(6), 0]) brick(4, 1);
  translate([0, unit_width(8), 0]) brick(1, 4);
  translate([unit_width(2), unit_width(8), 0]) brick(2, 3);

  // Plates
  translate([0, 0, brick_height + gap_height]) {
    plate(2, 2);
    translate([unit_width(3), 0, 0]) plate(1, 2);
    translate([0, unit_width(3), 0]) plate(4, 2);
    translate([0, unit_width(6), 0]) plate(4, 1);
    translate([0, unit_width(8), 0]) plate(1, 4);
    translate([unit_width(2), unit_width(8), 0]) plate(2, 3);

    // Tiles
    translate([0, 0, plate_height + gap_height]) {
      tile(2, 2);
      translate([unit_width(3), 0, 0]) tile(1, 2);
      translate([0, unit_width(3), 0]) tile(4, 2);
      translate([0, unit_width(6), 0]) tile(4, 1);
      translate([0, unit_width(8), 0]) tile(1, 4);
      translate([unit_width(2), unit_width(8), 0]) tile(2, 3);
    }
  }
}
