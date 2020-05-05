// https://bricks.stackexchange.com/questions/288/what-are-the-dimensions-of-a-lego-brick

$fn = 20;

// 1 Lego Unit = 1.6mm
u = 1.6;

module stud() {
  cylinder(d = 3 * u, h = u, center = true);
}

module tile_1x1() {
  difference() {
    cube([5 * u, 5 * u, 2 * u]);
    union() {
      epsilon = 0.1;
      translate([u, u, -epsilon]) cube([3 * u, 3 * u, u + epsilon]);
    }
  }
}

module plate_1x1() {
  difference() {
    cube([5 * u, 5 * u, 2 * u]);
    union() {
      epsilon = 0.1;
      translate([u, u, -epsilon]) cube([3 * u, 3 * u, u + epsilon]);
      translate([(5 * u) / 2, (5 * u) / 2, u - epsilon])
        cylinder(d = u, h = u + epsilon);
    }
  }
  translate([(5 * u) / 2, (5 * u) / 2, 2 * u]) stud();
}

module brick_1x1() {
  difference() {
    cube([5 * u, 5 * u, 6 * u]);
    union() {
      epsilon = 0.1;
      translate([u, u, -epsilon]) cube([3 * u, 3 * u, (5 * u) + epsilon]);
      translate([(5 * u) / 2, (5 * u) / 2, (5 * u) - epsilon])
        cylinder(d = u, h = u + epsilon);
    }
  }
  translate([(5 * u) / 2, (5 * u) / 2, 6 * u]) stud();
}

module brick_2x1() {
  difference() {
    cube([10 * u, 5 * u, 6 * u]);
    union() {
      epsilon = 0.1;
      translate([u, u, -epsilon]) cube([8 * u, 3 * u, (5 * u) + epsilon]);
      translate([(5 * u) / 2, (5 * u) / 2, (5 * u) - epsilon])
        cylinder(d = u, h = u + epsilon);
      translate([(10 * u) - ((5 * u) / 2), (5 * u) / 2, (5 * u) - epsilon])
        cylinder(d = u, h = u + epsilon);
    }
  }
  translate([(5 * u) / 2, (5 * u) / 2, 6 * u]) stud();
  translate([(10 * u) / 2, (5 * u) / 2, 0]) cylinder(d = 2 * u, h = 6 * u);
  translate([(10 * u) - ((5 * u) / 2), (5 * u) / 2, 6 * u]) stud();
}

module beam(n) {
  w = 5 * u;  // width
  h = 6 * u;  // height without stud
  e = 0.1;    // small epsilon overlap to help rendering
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
        cube([(n * w) - (2 * u), w - (2 * u), (h - u) + e]);
      // Interior dimples underneath studs
      for(i = [0 : n - 1]) {
        translate([(i * w) + (w / 2), w / 2, (h - u) - e])
          cylinder(d = 1.5 * u, h = u + e);
      }
    }
  }
  // Posts on bottom
  if (n > 1) {
    for(i = [0 : n - 2]) {
      translate([(i * w) + w, w / 2, 0]) cylinder(d = 2 * u, h = h);
    }
  }
}

for (i = [1 : 4]) {
  translate([0, i * 6 * u, 0]) beam(5 - i);
}
translate([0, 0, 0]) tile_1x1();
translate([6 * u, 0, 0]) plate_1x1();
translate([12 * u, 0, 0]) brick_1x1();
translate([18 * u, 0, 0]) brick_2x1();
