/*
  Arduino Micro model
  Aaron Ciuffo

*/


use <../libraries/tactile_switch.scad>
use <../libraries/header_pins.scad>
use <../libraries/micro_usb.scad>

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

module arduinoMicro(center = true, locate = false, centerV = false) {

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
        headerPins(2, 3, locate = locate);

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
  echo ("micro board dimensions:", microBoard);
}

arduinoMicro();

