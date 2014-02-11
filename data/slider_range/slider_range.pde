/*

 Based in the range example from Spacebrew.
 
*/

import spacebrew.*;

String server="sandbox.spacebrew.cc";
String name="Bernardo range";
String description ="Controls the noise of our tri partite sketch";


Spacebrew sb;

int sendNoiseRange = 512;

void setup() {
  size(1044, 150);
  background(0);

  sb = new Spacebrew( this );

  sb.addPublish( "sendNoiseRange", "range", sendNoiseRange ); 

  sb.connect(server, name, description );
}

void draw() {
  background(0);
  noStroke(); 

  fill(255);
  text("Send Noise Range: " + sendNoiseRange, 30, 30);
  
  fill(255, 255, 0);
  rect(sendNoiseRange, 5, 40, height-10);

}

void mouseDragged() {
  // Leaving 20 pixels at the end prevents the slider from going off the screen
  if (mouseX >= 0 && mouseX <= width - 40) {
    sendNoiseRange = mouseX;
    sb.send("sendNoiseRange", sendNoiseRange);
  }
}

