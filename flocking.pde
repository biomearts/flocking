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

Flock flock;
int N = 85;

boolean draw_axes = true;
boolean draw_flow_dir = true;
int axis_len, flow_dir_stem_len, flow_dir_tick_len;

void setup() {
  fullScreen();
  pixelDensity(2);
  background(0);
  axis_len = 100;
  flow_dir_stem_len = min(width, height)/2;
  flow_dir_tick_len = 15;
  
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
    thread("refresh");
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
}