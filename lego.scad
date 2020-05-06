// lego.scad - OpenSCAD models for LEGO bricks
// Andrew Ho (andrew@zeuscat.com)

// 1 Lego Unit = 1.6mm
u = 1.6;

// Helper function to make expressions with units less verbose
function u(n) = u * n;

// Other useful dimensions
stud_height = u;
brick_height = u(6);
plate_height = brick_height / 3;
unit_width = u(5);
half_width = unit_width / 2;

// Create a brick with given dimensions
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

// Create a plate with given dimensions
module plate(width, depth, studs = true, posts = true) {
  brick(width, depth, height = plate_height, studs = studs, posts = posts);
}

// Create a tile with given dimensions
module tile(width, depth, posts = undef) {
  function set_default(p) = posts == undef ?
    !((width == 2 && depth == 1) || (width == 1 && depth == 2)) : posts;
  plate(width, depth, studs = false, posts = set_default(posts));
  // TODO: add tiny bottom bevels around edge
}
