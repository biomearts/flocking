/**
 * Flocking0
 * modified from Flocking by Daniel Shiffman. Craig Reynold's boids on rules of avoidance, alignment, and coherence.
 */

// class encapsulation
Loader loader;
// threading
void load_data() {
  loader.refresh();
}

PShape bird0;

int NORTH = -90; // north is UP by default
Flock flock;
int N = 85;

boolean draw_axes = true;
boolean draw_flow_dir = true;
int axis_len, flow_dir_stem_len, flow_dir_tick_len;

void setup() {
  fullScreen();
  //size(1200,800);
  pixelDensity(2);
  background(0);
  axis_len = 100;
  flow_dir_stem_len = min(width, height)/2;
  flow_dir_tick_len = 15;
  
  bird0 = loadShape("bird0-01.svg");
  
  flock = new Flock();
  loader = new Loader();
  thread("load_data"); // load data for the first time
}

void draw() {
  // draw axes
  if(draw_axes) {
    pushStyle();
      noFill();
      strokeWeight(5);
      stroke(255, 0, 0);
      line(0, 0, axis_len, 0);
      stroke(0, 255, 0);
      line(0, 0, 0, axis_len);
    popStyle();
  }
  
  fill(0, 12);
  rect(0, 0, width, height); // make boids leave trail
  flock.run();
  
  if(millis() > loader.lastTime + loader.interval) {
    thread("load_data");
  }
}

void mousePressed() {
  flock.addBoid(mouseX, mouseY);
}

void keyPressed() {
  if(key == '[') {
    flock.controlSpeed(-0.1);
  }
  else if(key == ']') {
    flock.controlSpeed(+0.1);
  }
  else if(keyCode == 66) {
    flock.changeShape();
  }
  else if(keyCode == 68) {
    draw_axes = !draw_axes;
    draw_flow_dir = !draw_flow_dir;
  }
}