// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run() {
    for (Boid b : this.boids) {
      b.run(this.boids);  // Passing the entire list of boids to each boid individually
    }
  }
  
  void updateMaxSpeed(float s) {
    for(Boid b : this.boids) {
      b.maxspeed = s; 
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }
}