// https://bricks.stackexchange.com/questions/288/what-are-the-dimensions-of-a-lego-brick
// https://www.bartneck.de/2019/04/21/lego-brick-dimensions-and-measurements/
// http://www.robertcailliau.eu/en/Alphabetical/L/Lego/Dimensions/General%20Considerations/

$fn = 32;

// 1 Lego Unit = 1.6mm
u = 1.6;
function u(n) = u * n;

module tile_1x1() {
  brick(1, 1, h = u(2), studs = false);
}

module plate_1x1() {
  beam(1, h = u(2));
}

module brick_1x1() {
  beam(1);
}

module brick_2x1() {
  beam(2);
}

module brick(w, d, h = u(6), studs = true) {
  aw = w * u(5);  // absolute width in mm
  ad = d * u(5);  // absolute depth in mm
  e = 0.1;        // small epsilon overlap to help rendering
  difference() {
    union() {
      // Basic rectangular solid
      cube([aw, ad, h]);
      if (studs) {
        // Studs on top
        for(x = [0 : w - 1]) {
          for(y = [0 : d - 1]) {
            ax = x * u(5);
            ay = y * u(5);
            half = u(5) / 2;
            translate([ax + half, ay + half, h])
              cylinder(d = u(3), h = u, center = true);
          }
        }
      }
    }
    union() {
      // Interior cavity
      translate([u, u, -e]) cube([aw - u(2), ad - u(2), (h - u) + e]);
      if (studs) {
        // Interior dimples underneath studs
        for(x = [0 : w - 1]) {
          for(y = [0 : d - 1]) {
            ax = x * u(5);
            ay = y * u(5);
            half = u(5) / 2;
            translate([ax + half, ay + half, (h - u) - e])
              cylinder(d = u(1.5), h = u + e);
          }
        }
      }
    }
  }
  // Posts on bottom
  if (w > 1 && d > 1) {
    // Large hollow posts nestled underneath groups of four studs
    for(x = [0 : w - 2]) {
      for(y = [0 : d - 2]) {
        ax = x * u(5);
        ay = y * u(5);
        if (w > 1 && d > 1) {
          od = ((5 * sqrt(2)) - 3) * u;
          id = 4.80;
          translate([ax + u(5), ay + u(5), 0]) {
            difference() {
              cylinder(d = od, h = h);
              translate([0, 0, -e]) cylinder(d = id, h = h + e);
            }
          }
        }
      }
    }
  } else if (w > 1) {
    // Small solid posts between two linearly contiguous studs
    for(x = [0 : w - 2]) {
      translate([(x * u(5)) + u(5), u(5) / 2, 0]) cylinder(d = u(2), h = h);
    }
  } else if (d > 1) {
    for(y = [0 : d - 2]) {
      translate([u(5) / 2, (y * u(5)) + u(5), 0]) cylinder(d = u(2), h = h);
    }
  }
}

module beam(n, h = u(6)) {
  brick(n, 1, h);
}

for (i = [1 : 4]) {
  translate([0, i * u(6), 0]) beam(5 - i);
  translate([u(24), i * u(6), 0]) beam(5 - i, h = u(2));
}
translate([0, 0, 0]) tile_1x1();
translate([u(6), 0, 0]) plate_1x1();
translate([u(12), 0, 0]) brick_1x1();
translate([u(18), 0, 0]) brick_2x1();

translate([0, 0, u(12)]) {
  brick(2, 2);
  translate([0, u(12), 0]) brick(4, 2);
  translate([0, u(24), 0]) brick(4, 1);
  translate([0, u(31), 0]) brick(1, 4);
  translate([u(10), u(31), 0]) brick(2, 3);
}
