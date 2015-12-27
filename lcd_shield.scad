/*
  Model of Adafruit LCD Sheild w/ LCD
  21 December 2015
  Aaron Ciuffo (txoof)

  TODO:
    * model trim pot better
*/

use <../libraries/tactile_switch.scad>
use <../libraries/trim_pot.scad>

/* [Board Dimensions] */
// z dimensions are all guesses unless otherwise noted
lcdBoard = [80.77, 53.34, 2]; // outside dimensions of PCB
bZ = lcdBoard[2]; // Z height - thickness of shield PCB
lcdHoleLocations = [[2.92, 48.01, 0],
                    [2.92, 17.02, 0],
                    [77.85, 48.01, 0],
                    [77.84, 17.02]];

lcdHoleDia = 3.3; // mounting hole diameter

lcdDisplayDim = [71.37, 26.42, 5];
lcdDispLocation = [40.39, 32.51, bZ]; //center of lcd display

// z dimensions based on drawings, not on actual board
//Locations relative to origin
buttonLocations = [ [3.81, 6.99, bZ], 
                    [11.43, 3.56, bZ],
                    [11.43, 10.16, bZ], 
                    [19.05, 6.99, bZ], 
                    [27.94, 10.16, bZ], 
                    [75.4, 3.3, bZ] ];

trimPotLocation = [75.4, 10.4, bZ];

module lcdDisplay(center = false) {
  trans = center == false ? [0, 0, lcdDisplayDim[2]/2] : [0, 0, 0];

  translate(trans)
    color("gray")
    cube(lcdDisplayDim, center = true);
}


module lcdShield(center = true, centerV = false, locate = false, 
                locateDia = 0.1, v = false, 2D = false) {
  if (v) {
    echo ("LCD Sheild");
    echo ("shield dimensions:", lcdBoard);
    echo ("mounting hole locations:", lcdHoleLocations);
    echo ("display dimenions:", lcdDisplayDim);
    echo ("display location:", lcdDispLocation);
    echo ("display height + board:", lcdBoard[2]+lcdDisplayDim[2]);
  }

  transV = centerV == true ?
    -lcdBoard[2]/2 : 0; 

  trans = center == true ?
    [-lcdBoard[0]/2, -lcdBoard[1]/2, transV] : [0, 0, transV];

  if (2D == false) {
  translate(trans)
  difference() {
    union() {
      color("lightblue")
      cube(lcdBoard);

      // tactile buttons
      for (i = buttonLocations) {
        translate(i)
          //button(locate = locate);
          tactileSwitch(locate = locate);
      } // end for buttions

    // Trim Pot(s)
      translate(trimPotLocation)
        trimPot(locate = locate);
      
    // LCD screen
      translate(lcdDispLocation)
        lcdDisplay();
    } // end union
  
    for (k = lcdHoleLocations) {
      translate(k)
        cylinder(r = lcdHoleDia/2, h = bZ*10, center = true, $fn = 36);
    } // end for lcd hole locations


  } // end diff
  } // end if 2D
  if (locate) { // add location spikes for holes
    for (l = lcdHoleLocations) {
      translate(trans)
      translate(l)
        color("red")
        if (2D == false) {
          cylinder(r = locateDia/2, h = bZ*40, center = true, $fn =36);
        } else {
          circle(r = locateDia/2, center = true, $fn = 36);
        }
    } // end for lcd hole locations
  } 
}

lcdShield(locate = true, locateDia = 3.3, 2D = false);

