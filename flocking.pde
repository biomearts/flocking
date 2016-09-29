/**
 * Flocking0
 * modified from Flocking by Daniel Shiffman. Craig Reynold's boids on rules of avoidance, alignment, and coherence.
 */

Loader loader;
void refresh() {
  loader.refresh();
}

Flock flock;

void setup() {
  size(640, 360);
  pixelDensity(2);
  
  loader = new Loader();
  thread("refresh");
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 150; i++) {
    flock.addBoid(new Boid(0,0));
  }
}

void draw() {
  background(50);
  flock.run();
  
  if(millis() > loader.lastTime + loader.interval) {
    thread("refresh");
  }
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}