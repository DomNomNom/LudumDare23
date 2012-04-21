// sound library
import ddf.minim.*;
/* unused
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
*/

PVector center; // the center coordinate of the window. just a handy thing to have around.
Minim minim;    // audio
Resources resources;
Engine engine;

void setup() {
  // graphics options
  size(500, 500, P2D);
  smooth();
  fill(200);
  noStroke();
  rectMode(CENTER); // Note: entity.pos is the middle of the object. this will affect collision detection.
  ellipseMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  
  // ===== init global variables =====
  center = new PVector(width/2, height/2);
  minim = new Minim(this);
  resources = new Resources();
  input = new Input();
  engine = new Engine();
}

void draw() {
  engine.run();
}

void stop() {
  resources.stop();
  minim.stop();
  super.stop();
}
