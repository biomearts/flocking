/**
 * Flocking0
 * modified from Flocking by Daniel Shiffman. Craig Reynold's boids on rules of avoidance, alignment, and coherence.
 */

// class encapsulation
Loader loader;
// threading
void load_data() {
  try {
    loader.refresh();
  }
  catch (Exception e) {
    //e.printStackTrace();
    println(e);
  }
}

PShape bird0;

int NORTH = -90; // north is UP by default
Flock flock;
int N = 85;

boolean draw_axes = false;
boolean draw_flow_dir = false;
int axis_len, flow_dir_stem_len, flow_dir_tick_len;

int tail = 94;

void setup() {
  //fullScreen();
  size(900,600);
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
  
  fill(0, 100-tail);
  rect(0, 0, width, height); // make boids leave trail
  flock.run();
  
  if(millis() > loader.lastTime + loader.interval) {
    thread("load_data");
  }
}

void mousePressed() {
  flock.addBoid(mouseX, mouseY);
}

void controlTail(int i) {
  if(tail + i >= 0 && tail + i <= 100) {
    tail += i;
    println("[global] tail", tail);
  }
}

String MODE = "speed";
void keyPressed() {
  if(key == '[') {
    if(MODE == "speed") {
      flock.controlSpeed(-0.1);
    }
    else if(MODE == "size") {
      flock.controlSize(-0.1);
    }
    else if(MODE == "neighbor") {
      flock.controlNeighbor(-2);
    }
    else if(MODE == "tail") {
      controlTail(-1);
    }
  }
  else if(key == ']') {
    if(MODE == "speed") {
      flock.controlSpeed(+0.1);
    }
    else if(MODE == "size") {
      flock.controlSize(+0.1);
    }
    else if(MODE == "neighbor") {
      flock.controlNeighbor(+2);
    }
    else if(MODE == "tail") {
      controlTail(+1);
    }
  }
  else if(keyCode == 83) { // S
    MODE = "speed";
    println("[global] mode speed");
  }
  else if(keyCode == 90) { // Z
    MODE = "size";
    println("[global] mode size");
  }
  else if(keyCode == 78) { // N
    MODE = "neighbor";
    println("[global] mode neighbor");
  }
  else if(keyCode == 84) { // T
    MODE = "tail";
    println("[global] mode tail");
  }
  else if(keyCode == 66) { // B
    flock.changeShape();
  }
  else if(keyCode == 68) { // D
    draw_axes = !draw_axes;
    draw_flow_dir = !draw_flow_dir;
  }
}