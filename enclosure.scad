/*
  Laser cut enclosure for arduino based RFID reader
  21 December 2015
  Aaron Ciuffo (txoof)

  TODO:
    X move buttons etc to library
    * remove button code from this 
    * model trim pot better
*/
/* [Box Dimensions] */
boxX = 45; //width
boxY = 60; //depth
boxZ = 30; //height
thick = 3; // material thickness

include <../libraries/nuts_and_bolts.scad>
use <../libraries/tactile_switch.scad>
use <../libraries/trim_pot.scad>

/* [Box Dimensions] */

/* [Dimensions] */
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

trimPotLocation = [[75.4, 10.4, bZ]];

module lcdDisplay(center = false) {
  trans = center == false ? [0, 0, lcdDisplayDim[2]/2] : [0, 0, 0];

  translate(trans)
    color("gray")
    cube(lcdDisplayDim, center = true);
}


module lcdShieldModel(locate = false) {
//  translate([-lcdBoard[0]/2, -lcdBoard[1]/2], -lcdBoard[2]/2)
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
      for (j = trimPotLocation) {
        translate(j)
          trimPot(locate = locate);
      
      // LCD screen
      translate(lcdDispLocation)
        lcdDisplay();
      } // end for trim pot
    } // end union
  
    for (k = lcdHoleLocations) {
      translate(k)
        cylinder(r = lcdHoleDia/2, h = bZ*10, center = true, $fn = 36);
    } // end for lcd hole locations


  } // end diff
  if (locate) { // add location spikes for holes
    for (l = lcdHoleLocations) {
      translate(l)
        color("red")
        cylinder(r = .1, h = bZ*20, center = true);
    } // end for lcd hole locations
  } 
}


lcdShieldModel(locate = false);
