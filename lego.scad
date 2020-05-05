// https://bricks.stackexchange.com/questions/288/what-are-the-dimensions-of-a-lego-brick

$fn = 20;

// 1 Lego Unit = 1.6mm
u = 1.6;
function u(n) = u * n;

module stud() {
  cylinder(d = u(3), h = u, center = true);
}

module tile_1x1() {
  difference() {
    cube([u(5), u(5), u(2)]);
    union() {
      epsilon = 0.1;
      translate([u, u, -epsilon]) cube([u(3), u(3), u + epsilon]);
    }
  }
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

module beam(n, h = u(6)) {
  w = u(5);  // width
  e = 0.1;   // small epsilon overlap to help rendering
  difference() {
    union() {
      // Basic rectangular solid
      cube([n * w, w, h]);
      // Studs on top
      for(i = [0 : n - 1]) {
        translate([(i * w) + (w / 2), w / 2, h]) stud();
      }
    }
    union() {
      // Interior cavity
      translate([u, u, -e])
        cube([(n * w) - u(2), w - u(2), (h - u) + e]);
      // Interior dimples underneath studs
      for(i = [0 : n - 1]) {
        translate([(i * w) + (w / 2), w / 2, (h - u) - e])
          cylinder(d = u(1.5), h = u + e);
      }
    }
  }
  // Posts on bottom
  if (n > 1) {
    for(i = [0 : n - 2]) {
      translate([(i * w) + w, w / 2, 0]) cylinder(d = u(2), h = h);
    }
  }
}

for (i = [1 : 4]) {
  translate([0, i * u(6), 0]) beam(5 - i);
  translate([u(24), i * u(6), 0]) beam(5 - i, h = u(2));
}
translate([0, 0, 0]) tile_1x1();
translate([u(6), 0, 0]) plate_1x1();
translate([u(12), 0, 0]) brick_1x1();
translate([u(18), 0, 0]) brick_2x1();
