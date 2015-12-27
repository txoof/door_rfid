/*
  Arduino Micro model
  Aaron Ciuffo

*/


use <../libraries/tactile_switch.scad>
use <../libraries/header_pins.scad>
use <../libraries/micro_usb.scad>
include <../libraries/nuts_and_bolts.scad>

/*[Board Dimensions]*/
microBoard = [17.78, 48.26, 1.5];
bZ = microBoard[2]; // Z height - thickness of board PCB

buttonLocation = [6.22, 43.05, bZ];


boardHoleLocations = [[1.2, 46.99, 0],
                [1.2, 1.45, 0],
                [16.5, 1.45],
                [16.5, 46.99]];

boardHoleDia = 1.2;

headerPinLocation = [12.7, 43.18, bZ];

usbMicroLocation = [8.89, 1.45, bZ];

module arduinoMicro(center = true, locate = false, centerV = false, v = false) {

  // vertically center (z axis)
  transV = centerV == false ?
    0 : -microBoard[2]/2;

  // center board at origin 
  trans = center == false ? 
    [0, 0, transV] : [-microBoard[0]/2, -microBoard[1]/2, transV];


  translate(trans)
  difference() {
    union() {
      color("Teal")
        cube(microBoard);
      translate(buttonLocation)
        tactileSwitch(locate = locate);    

      //add header pins
      translate(headerPinLocation)
        headerPins(2, 3, locate = locate, v = v);

      // add micro USB
      translate(usbMicroLocation)
        usbMicro(locate = locate);

    } // end union

    for (i = boardHoleLocations) {
      translate(i)
        cylinder(r = boardHoleDia/2, h = bZ*3, center = true, $fn = 36);
    }


  } // end difference

  translate(trans)
  if (locate) {
    for (j = boardHoleLocations) {
      translate(j)
        color("red")
        cylinder(r = 0.1, h = bZ*20, center = true); 
    }
  }
  if (v) {
    echo ("micro board dimensions:", microBoard);
  }
}


// this is a trainwreck
module microMount(clipX = 4, clipY = 5, base = 4, v = false, 2D = false) {
  
  slotDepth = 1.5;
  slotHeight = 3;
  boardDim =  [17.78, 48.26, 1.5, 15];
  o = .001; // overage to make cuts cleaner
  
  if (2D) {
    for (k = [-1, 1]) {
      translate([0, boardDim[1]/3*k, 0])
        circle(r = 1.6, center = true, $fn = 36);
    }
  } else {
  translate([0, 0, base])
  union() {
    for ( i = [-1, 1]) {
      for ( j = [-1, 1]) {
        translate([i*(boardDim[0]/2*1.07), j*(boardDim[1]/2-clipY/2/.5), boardDim[3]/2])
        difference() {
          union() {
            cube([clipX, clipY, boardDim[3]], center =true);
            cube([], center = true);
          }
          translate([-i*(clipX/2-slotDepth/2+o), 0, boardDim[3]/2-slotHeight])
          hull() {
            translate([])
              cube([slotDepth, clipY+o, boardDim[2]*1.2], center = true);
            translate([slotDepth/2, 0, 0])
              cube([.0001, clipY+o, slotHeight], center = true);
          } // end hull
        } // end difference
      } // end for i
    } // end for j

    //base
    if (2D==false) {
      difference() {
        translate([0, 0, -base/2])
          cube([boardDim[0]*1.07+clipX, boardDim[1]-clipY/2/.5, base], center = true);
        for (k = [-1, 1]) {
          translate([0, boardDim[1]/3*k, 0])
            mBolt(size = m3, center = true, tolerance = 0.2);
        } // end for
      } // end difference
    } // end if 

  } // end union
  }
}

microMount(2D = false);
translate([0, 0, 12+4])
rotate([0, 0, 0])
arduinoMicro(v = true, centerV = true);


