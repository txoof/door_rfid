/*
  Aaron Ciuffo
  RFID reader enclosure (electronics)
*/

use <./lcd_sheild.scad>
include <../libraries/nuts_and_bolts.scad>


boltHoles =  [[2.92, 48.01, 0], [2.92, 17.02, 0], [77.85, 48.01, 0], [77.84, 17.02]];



lcdShield(locate = true);

/*
for (i = boltHoles) {
  translate(i)
    color("dimgray")
    mBolt(m3);
  translate(i)
    color("dimgray")
    mNut(m3);
}
*/


