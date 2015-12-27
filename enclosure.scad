/*
  RFID Arduino Enclosure


  TO DO:
    * add wire routing for power, door access, RFID, etc.
    * check clearances with real shields
    * rewrite micro holder - train wreck

*/


use <./finger_joint_box.scad>
use <./lcd_shield.scad>
use <./edge_cutter.scad>
use <./arduino_micro.scad>

module bottom(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];
  
  color("green")
  difference() {
    faceB(size = size, finger = finger, material = material, lidFinger = lidFinger,
          usableDiv = usableDiv, usableDivLid = usableDivLid, lid = false, bolt = bolt);
    translate([0, (-boxY/2+material/2+14), 0])
      holeCut(material = material, edgeLen = boxX, finger = 20, numFingers = 2);

    translate([0, 5, 0])
      rotate([0, 0, 90])
      microMount(2D = true);
  }

}

module top(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("lime")
  difference() {
    faceB(size = size, finger = finger, material = material, lidFinger = lidFinger,
          usableDiv = usableDiv, usableDivLid = usableDivLid, lid = false, bolt = bolt);
 
    translate([0, (-boxY/2+material/2+14), 0])
      holeCut(material = material, edgeLen = boxX, finger = 20, numFingers = 2);

  }


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
  difference() {
    faceA(size = size, finger = finger, material = material, lidFinger = lidFinger,
         usableDiv = usableDiv, usableDivLid = usableDivLid, bolt = bolt);
    for (i = [-1, 1]){
      translate([i*boxX/4, boxZ/4, 0])
        keyHole();
    }
    translate([0, -boxX/4, 0])
      keyHole();
  }
}


module right(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("blue")
  difference() {
    faceC(size = size, finger = finger, material = material, lidFinger = lidFinger,
          usableDiv = usableDiv, usableDivLid = usableDivLid);
    translate([-boxY/2+material/2+14, 0, 0])
      rotate([0, 0, -90])
      holeCut(material = material, edgeLen = boxZ, finger = 15, numFingers =2);
  }
}

module left(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("darkblue")
  difference() {
    faceC(size = size, finger = finger, material = material, lidFinger = lidFinger,
          usableDiv = usableDiv, usableDivLid = usableDivLid);

    // holes for lcdSupport
    translate([-boxY/2+material/2+14, 0, 0])
      rotate([0, 0, -90])
      holeCut(material = material, edgeLen = boxZ, finger = 15, numFingers =2);
  }

}

module lcdSupport(size, material) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  color("yellow")
  difference() {
    square([boxX, boxZ], center = true);
    for (i = [-1, 1]) {
      translate([i*(boxX/2-material/2), 0, 0])
        rotate([0, 0, 90])
        edgeCut(material = material, edgeLen = boxZ, finger = 15, numFingers = 2);
      translate([0, i*(boxZ/2-material/2+.001), 0]) //overage fudge for clean cuts
        edgeCut(material = material, edgeLen = boxX, finger = 20, numFingers = 2);
      for (j = [-1, 1]) {
        // make space in corners for bolts and cables
        translate([i*(boxX/2-material/2), j*(boxZ/2-material/2), 0])
          circle(r = boxZ/6, $fn = 36);

      }
    }
   
    // hole for accessing pins on bottom of shield
    translate([0, -boxZ/4, 0])
    hull() {
      for (k = [-1, 1]) {
        for (l = [-1, 1]) {
          translate([k*(boxX/3.5), l*boxZ/10, 0])
          circle(r = 2, center = true);
        }
      }
    }
    // cut bolt holes    
    lcdShield(2D = true, locate = true, locateDia = 3.3, centerV = false);
  }
}

//!lcdSupport(size = [110, 50, 82], material = 3);

module myLayout3D(size, finger, lidFinger, material, usableDiv, usableDivLid,
                alpha, bolt = 10) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  // amount to shift to account for thickness of material
  D = material/2;


///*
  color("green", alpha = alpha)
    translate([])
    linear_extrude(height = material, center = true)
    bottom(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt);


  color("lime", alpha = alpha)
    translate([0, 0, boxZ-material])
    linear_extrude(height = material, center = true)
    top(size, finger, lidFinger, material, usableDiv, usableDivLid, bolt);
//*/

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

module keyHole(screw = 3) {
  translate([0, -screw*1.5/4, 0 ])
  union() {
    circle(r = (screw+2.1)/2, $fn = 36); // head entry 
    translate([0, screw*1.5/2, 0])
      square([screw*1.1, screw*1.5], center = true);
    translate([0, screw*1.5, 0])
      circle(r = screw*1.1/2, $fn = 36);
  }

}

module keyHoleSpacer(screw = 3, len = 15) {
  cRad = 2;
  xLen = len - cRad*2;

  color("orange")
  difference() {
    hull() {
      for (i = [-1, 1]) {
        for (j = [-1, 1]) {
          translate([i*xLen/2, j*xLen/2, 0])
            circle(r = cRad, $fn = 36);
          
        }
      }
    }
    keyHole();
  }
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

  translate([0, boxZ+separation, 0])
  lcdSupport(size = size, material = material);
 
  for (i = [-1:1]) {
  translate([boxX+separation+boxY+separation-20*i, 0, 0])
    keyHoleSpacer();
  }


}

module partsLayout(size, material) {
  boxX = size[0];
  boxY = size[1];
  boxZ = size[2];

  D = material/2; // displace by this much to account for thickness of material

  translate([0, -boxY/2+D+8, boxZ/2-D])
    rotate([90, 0, 0])
    lcdShield(center = true, v = false, locate = false, locateDia = 3.3);


  translate([0, -boxY/2+D+14, boxZ/2-D])
    color("yellow")
    rotate([90 , 0, 0])
    linear_extrude(height = material, center = true)
      lcdSupport(size = size, material = material);

  translate([0, 5, D])
    rotate([0, 0, 90])
    color("purple")
    microMount();

  translate([0, 5, D+16])
    rotate([0, 0, 90])
    arduinoMicro(centerV = true);

  translate([boxX/4, boxY/2+D, boxZ/2+D+boxZ/4-3])
    color("orange")
    rotate([90, 0, 0])
    linear_extrude(height = material, center = true)
    keyHoleSpacer();

  translate([0, boxY/2+D, D+boxZ/2-boxZ/4-10])
    color("orange")
    rotate([90, 0, 0])
    linear_extrude(height = material, center = true)
    keyHoleSpacer();
  echo("check LCD shield thickess! Adjust lcdSupport accordingly!");
}


module myEnclosure(
  size = [110, 55, 82],
  finger = 16.6,
  lidFinger = 10,
  material = 3,
  2D = true, 
  alpha = 0.9) {

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
