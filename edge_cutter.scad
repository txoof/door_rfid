/*
  cut finger joints at edge of 2D shape and matching holes inside 2D shapes
*/


module edgeCut(finger = 5, material = 3, numFingers = 4, edgeLen = 100, center = true) {

  fingerSpan = (numFingers*2-1)*finger;
  edgeCut = (edgeLen - fingerSpan)/2;

  o = .001;
  // remember to add the edge cut into the center calculation
  trans = center == true ? 
    [-edgeLen/2, -material/2, 0] : [0, 0, 0];

  translate(trans)
  union() {  // treat this as one object to make translation easier
    
    square([edgeCut, material+o]); // first cut

    //fingers
    for (i = [0:numFingers-2]) {
      translate([edgeCut+finger+i*finger*2, 0, 0])
        square([finger, material+o]);
    }

    translate([edgeCut+fingerSpan, 0, 0])
      square([edgeCut, material+o]); // last cut
  }
  
}


module holeCut(finger = 5, material = 3, numFingers = 4, edgeLen = 100, center = true) {

  trans = center == true ? 
    [-(numFingers*2-1)/2*finger, -material/2, 0] : [0, 0, 0];

  translate(trans)
  for (i = [0:numFingers-1]) {
    translate([i*finger*2, 0, 0])
      square([finger, material]);
  }
  
}

module edgeDemo() {
  board = [100, 80];
  material = 3;

  difference() {
    square(board, center = true);
    for (i = [-1, 1]) {
      rotate([0, 0, -90])
      translate([0, i*(board[0]/2-material/2), 0])
        edgeCut(edgeLen = 80, center = true, material = material, 
                numFingers = 3, finger = 10);
    }
  }
}

module holeDemo() {
  board = [100, 80];
  material = 3;

  difference() {
    square(board, center = true);
    rotate([0, 0, -90])
      holeCut(edgeLen = 100, center = true, material = material,
              numFingers = 3, finger = 10);
  }
}

module demo3D() {
  material = 3;

  color("blue")
    linear_extrude(height = 3, center = true)
    holeDemo();

  translate([0, 0, 100/2-material/2])
  rotate([0, 90, 0])
    color("yellow")
    linear_extrude(height = 3, center = true)
    edgeDemo();
}

//edgeDemo();
//holeDemo();
//edgeCut(numFingers = 4, center = false);
//holeCut(numFingers = 4, center = false);
demo3D();
