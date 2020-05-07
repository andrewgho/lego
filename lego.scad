// lego.scad - OpenSCAD models for LEGO bricks
// Andrew Ho (andrew@zeuscat.com)

// 1 Lego Unit = 1.6mm
u = 1.6;

// Other useful dimensions
stud_height = u;
brick_height = u(6);
plate_height = brick_height / 3;
base_width = u(5);
half_width = base_width / 2;

// Helper functions to make expressions with units less verbose
function u(n) = u * n;
function base_width(n) = base_width * n;

// Create a brick with given dimensions
module brick(width = 4, depth = 2, height = brick_height, studs = true, posts = true) {
  aw = base_width(width);  // absolute width in mm
  ad = base_width(depth);  // absolute depth in mm
  e = 0.1;                 // small epsilon overlap to help rendering

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
          ax = base_width(x);
          ay = base_width(y);
          if (width > 1 && depth > 1) {
            od = ((5 * sqrt(2)) - 3) * u;
            id = 4.80;
            translate([ax + base_width, ay + base_width, 0]) {
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
        translate([base_width(x + 1), half_width, 0])
          cylinder(d = u(2), h = height);
      }
    } else if (depth > 1) {
      // Small solid posts between two linearly contiguous studs (y-axis)
      for(y = [0 : depth - 2]) {
        translate([half_width, base_width(y + 1), 0])
          cylinder(d = u(2), h = height);
      }
    }
  }

  // Studs on top
  module studs() {
    for(x = [0 : width - 1]) {
      for(y = [0 : depth - 1]) {
        ax = base_width(x);
        ay = base_width(y);
        translate([ax + half_width, ay + half_width, height])
          cylinder(d = u(3), h = stud_height, center = true);
      }
    }
  }

  // Cutouts for interior dimples underneath studs
  module stud_dimples() {
    for(x = [0 : width - 1]) {
      for(y = [0 : depth - 1]) {
        ax = base_width(x);
        ay = base_width(y);
        translate([ax + half_width, ay + half_width, (height - u) - e])
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
module tile(width, depth, posts = undef, groove = true) {
  // Special case of 1x2 tile has no post, larger tiles have posts
  function set_default(p) = posts == undef ?
    !((width == 2 && depth == 1) || (width == 1 && depth == 2)) : posts;

  // Cutouts for grooves around edges
  // https://rebrickable.com/parts/3069a/tile-1-x-2-without-groove/
  module grooves(width, depth) {
    aw = base_width(width);  // absolute width in mm
    ad = base_width(depth);  // absolute depth in mm
    gw = 0.25;               // groove width
    e = 0.1;                 // small epsilon overlap to help rendering
    translate([-e, -e, -e]) {
      cube([e + aw + e, e + gw, e + gw]);
      cube([e + gw, e + ad + e, e + gw]);
    }
    translate([-e, ad - gw, -e]) cube([e + aw + e, e + gw, e + gw]);
    translate([aw - gw, -e, -e]) cube([e + gw, e + ad + e, e + gw]);
  }

  if (groove) {
    difference() {
      plate(width, depth, studs = false, posts = set_default(posts));
      grooves(width, depth);
    }
  } else {
    plate(width, depth, studs = false, posts = set_default(posts));
  }
}
