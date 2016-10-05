/**
 * Flocking0
 * modified from Flocking by Daniel Shiffman. Craig Reynold's boids on rules of avoidance, alignment, and coherence.
 */

// class encapsulation
Loader loader;
// threading
void refresh() {
  loader.refresh();
}

Flock flock;
int N = 85;

void setup() {
  fullScreen();
  pixelDensity(2);
  
  loader = new Loader();
  thread("refresh");
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < N; i++) {
    flock.addBoid(new Boid(0,0));
  }
  
  background(0);
}

void draw() {
  fill(0, 12);
  rect(0, 0, width, height); // make boids leave trail
  flock.run();
  
  if(millis() > loader.lastTime + loader.interval) {
    thread("refresh");
  }
}

// Add a new boid into the System
void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}