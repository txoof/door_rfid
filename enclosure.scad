/*
  RFID Arduino Enclosure


*/


use <./finger_joint_box.scad>
use <./lcd_shield.scad>
use <../edge_cutter.scad>

module bottom(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];
  
  color("green")
  faceB(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid, lid = false, bolt = bolt);

}

module top(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("lime")
  faceB(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid, lid = false, bolt = bolt);

}

module front(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("darkred")
  difference() {
    faceA(size = size, finger = finger, material = material, lidFinger = lidFinger,
         usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);
    
    boltDia = 3;

    // Screen and button opening - curved rectangle
    lcdDispDim = [71.37, 26.42, 5];
    opening = [81, 54-boltDia*2]; // decrease the size of the opening to cover board
    cRad = 3; 
    
    translate([0, -boltDia, 0]) // shift the opening down one bolt diameter
    hull() {
      for (i = [-1, 1]){
        for (j = [-1, 1]) {
          translate([i*(opening[0]/2-cRad), j*(opening[1]/2-cRad), 0])
            circle(r = cRad, center = true, $fn = 36);
        } // end j
      } // end i
    } // end hull
  } // end diff

}

module back(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("red")
  faceA(size = size, finger = finger, material = material, lidFinger = lidFinger,
       usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

}


module right(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("blue")
  faceC(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid);

}

module left(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("darkblue")
  faceC(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid);

}



module myLayout3D(size, finger, lidFinger, material, usableDiv, usableDivLid,
                alpha, bolt = 10) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  // amount to shift to account for thickness of material
  D = material/2;


  color("green", alpha = alpha)
    translate([])
    linear_extrude(height = material, center = true)
    bottom(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt);


  color("lime", alpha = alpha)
    translate([0, 0, boxZ-material])
    linear_extrude(height = material, center = true)
    top(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt);

/*
  color("red", alpha = alpha)
    translate([0, boxY/2-D, boxZ/2-D])
    rotate([90, 0, 0])
    linear_extrude(height = material, center = true)
    back(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt);


  translate([-finger*floor(usableDiv[0]/2), boxY/2-D, bolt/2-D])
    rotate([180, 0, 0])
    addBolts(length = boxY, finger = finger, cutD = material,
            uDiv = usableDiv[0], bolt = bolt);

  translate([-lidFinger*floor(usableDivLid[0]/2), boxY/2-D, boxZ-bolt/2-D])
    addBolts(length = boxY, finger = lidFinger, cutD = material,
            uDiv = usableDivLid[0], bolt = bolt);
*/

  color("darkred", alpha = alpha)
    translate([0, -boxY/2+D, boxZ/2-D])
    rotate([90, 0, 0])
    linear_extrude(height = material, center = true)
    front(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt);

  translate([-finger*floor(usableDiv[0]/2), -boxY/2+D, bolt/2-D])
    rotate([180, 0, 0])
    addBolts(length = boxY, finger = finger, cutD = material,
            uDiv = usableDiv[0], bolt = bolt);

  translate([-lidFinger*floor(usableDivLid[0]/2), -boxY/2+D, boxZ-bolt/2-D])
    addBolts(length = boxY, finger = lidFinger, cutD = material,
            uDiv = usableDivLid[0], bolt = bolt);

/*
  color("blue", alpha = alpha)
    translate([boxX/2-D, 0, boxZ/2-D])
    rotate([90, 0, 90])
    linear_extrude(height = material, center = true)
    right(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt);

  // lid bolts
  translate([boxX/2-bolt/2, -lidFinger*floor(usableDivLid[1]/2), boxZ-D*2])
    rotate([90, 0, 90])
    addBolts(length = boxX, finger = lidFinger, cutD = material,
            uDiv = usableDivLid[1], bolt = bolt);

  // base bolts
  translate([boxX/2-bolt/2, -finger*floor(usableDiv[1]/2), -D/2])
    rotate([90, 0, 90])
    addBolts(length = boxX, finger = finger, cutD = material,
            uDiv = usableDiv[1], bolt = bolt);

  // +Y on Z axis bolts
  translate([boxX/2-bolt/2, boxY/2-D, boxZ/2+finger*floor(usableDiv[2]/2)-D])
    rotate([0, 90, 0])
    addBolts(length = boxZ, finger = finger, cutD = material,
            uDiv = usableDiv[2], bolt = bolt);

  // -Y on Z axis bolts
  translate([boxX/2-bolt/2, -1*(boxY/2-D), boxZ/2+finger*floor(usableDiv[2]/2)-D])
    rotate([0, 90, 0])
    addBolts(length = boxZ, finger = finger, cutD = material,
            uDiv = usableDiv[2], bolt = bolt);
*/

  color("darkblue", alpha = alpha)
    translate([-boxX/2+D, 0, boxZ/2-D])
    rotate([90, 0, 90])
    linear_extrude(height = material, center = true)
    left(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt);

  // lid bolts
  translate([-1*(boxX/2-bolt/2), -lidFinger*floor(usableDivLid[1]/2), boxZ-D*2])
    rotate([-90, 0, 90])
    addBolts(length = boxX, finger = lidFinger, cutD = material,
            uDiv = usableDivLid[1], bolt = bolt);

  // base bolts
  translate([-1*(boxX/2-bolt/2), -finger*floor(usableDiv[1]/2), -D/2])
    rotate([-90, 0, 90])
    addBolts(length = boxX, finger = finger, cutD = material,
            uDiv = usableDiv[1], bolt = bolt);

  // +Y on Z axis bolts
  translate([-1*(boxX/2-bolt/2), boxY/2-D, boxZ/2+finger*floor(usableDiv[2]/2)-D])
    rotate([0, 90, 180])
    addBolts(length = boxZ, finger = finger, cutD = material,
            uDiv = usableDiv[2], bolt = bolt);

  // -Y on Z axis bolts
  translate([-1*(boxX/2-bolt/2), -1*(boxY/2-D), boxZ/2+finger*floor(usableDiv[2]/2)-D])
    rotate([0, 90, 180])
    addBolts(length = boxZ, finger = finger, cutD = material,
            uDiv = usableDiv[2], bolt = bolt);

  // Lay out additional parts for dimensioning 
  partsLayout(size, material);


}

module myLayout2D(size, finger, lidFinger, material, usableDiv, usableDivLid,
                bolt = 10) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  //separation of pieces
  separation = material*2;
  // calculate the most efficient layout
  yDisplace = boxY > boxZ ? boxY : boxZ + separation;

  translate([])
    back(size = size, finger = finger, material = material, lidFinger = lidFinger,
         usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

  translate([boxX+separation+boxY+separation, 0, 0])
    front(size = size, finger = finger, material = material, lidFinger = lidFinger,
          usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

  translate([boxX/2+boxY/2+separation, 0, 0])
    right(size = size, finger = finger, material = material, lidFinger = lidFinger,
          usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);

  translate([boxX/2+boxY/2+separation, -yDisplace, 0])
    left(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);


  translate([0, -boxZ/2-yDisplace/2-separation, 0])
    top(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid,
        lid = false, bolt = bolt);

  translate([boxX+separation+boxY+separation, -boxZ/2-yDisplace/2-separation, 0])
    bottom(size = size, finger = finger, material = material, lidFinger = lidFinger,
        usableDiv = usableDiv, usableDivLid = usableDivLid,
        lid = false, bolt = bolt); 


}

module partsLayout(size, material) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  D = material/2; // displace by this much to account for thickness of material

  translate([0, -boxY/2+D+8, boxZ/2-D])
    rotate([90, 0, 0])
    lcdShield(center = true, v = true, locate = true, locateDia = 3.3);
}


module myEnclosure(
  size = [110, 50, 82],
  finger = 16.6,
  lidFinger = 10,
  material = 3,
  2D = true, 
  alpha = 0.5) {

  // set finger and lid finger equal
  lidFinger = finger;


  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  // calculate the maximum number of fingers and cuts possible
  maxDivX = floor(boxX/finger);
  maxDivY = floor(boxY/finger);
  maxDivZ = floor(boxZ/finger);

  // calculate the maximum number of fingers and cuts for the lid
  maxDivLX = floor(boxX/lidFinger);
  maxDivLY = floor(boxY/lidFinger);

  // the usable divisions value must be odd for this layout
  uDivX = (maxDivX%2)==0 ? maxDivX-3 : maxDivX-2;
  uDivY = (maxDivY%2)==0 ? maxDivY-3 : maxDivY-2;
  uDivZ = (maxDivZ%2)==0 ? maxDivZ-3 : maxDivZ-2;
  usableDiv = [uDivX, uDivY, uDivZ];

  uDivLX= (maxDivLX%2)==0 ? maxDivLX-3 : maxDivLX-2;
  uDivLY= (maxDivLY%2)==0 ? maxDivLY-3 : maxDivLY-2;
  usableDivLid = [uDivLX, uDivLY];

  if (2D) {
    myLayout2D(size = size, finger = finger, lidFinger = lidFinger, material = material,
            usableDiv = usableDiv, usableDivLid = usableDivLid);
  } else {
    myLayout3D(size = size, finger = finger, lidFinger = lidFinger, material = material,
            usableDiv = usableDiv, usableDivLid = usableDivLid, alpha = alpha);
  }

}
myBolt = 20;

//myEnclosure(size = [88, 99, 66]);
2D = true;
2D = false;
myEnclosure(2D = 2D);
