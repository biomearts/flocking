// The Boid class

class Boid {
  Flock flock;
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  color c;
  // maxspeed and maxforce are now universally controlled by Flock

  Boid(float x, float y, Flock f) {
    flock = f;
    location = new PVector(x, y);
    //float angle = random(TWO_PI);
    //velocity = new PVector(cos(angle), sin(angle)); // will work in Processing.js
    velocity = PVector.random2D();
    acceleration = PVector.random2D();//new PVector(0, 0);
    r = flock.default_size + random(-flock.default_size*0.5, flock.default_size*0.5);
    c = lerpColor(color(0,255,255), color(0,0,255), random(0,1));
    // 2nd color: color(0,145,255) more subtle
    //            color(0,0,255)   more variation
  }

  void run() {
    flock();
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock() {
    PVector sep = separate();   // Separation
    PVector ali = align();      // Alignment
    PVector coh = cohesion();   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
    applyForce(flock.flow_dir);
    
    // Apply human control
    acceleration.mult(1 + flock.flow_speed + flock.additional_speed);
  }

  // Method to update location
  void update() {
    velocity.add(acceleration); // a -> v; Update velocity
    velocity.limit(flock.maxspeed); // Limit speed
    location.add(velocity); // v -> x
    acceleration.mult(0); // Reset accelertion to 0 each cycle
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    // Scale to maximum speed
    //desired.normalize();
    //desired.mult(flock.maxspeed); // will work in Processing.js
    desired.setMag(flock.maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(flock.maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    //float theta = velocity.heading2D() + radians(90); // will work in Processing.js
    float theta = velocity.heading() + radians(90);
    
    fill(c);
    noStroke();
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    if(flock.shape == 0) {
      beginShape(TRIANGLES);
      vertex(0, -r*flock.size_multiplier*2);
      vertex(-r*flock.size_multiplier*0.5, 0);
      vertex(r*flock.size_multiplier*0.5, 0);
      endShape();
    }
    else if(flock.shape == 1) {
      ellipse(0, 0, r*flock.size_multiplier, r*flock.size_multiplier);
    }
    else if(flock.shape == 2) {
      shape(bird0, 0, 0, 64, 64);
    }
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (location.x < -r*flock.size_multiplier) location.x = width+r*flock.size_multiplier;
    if (location.y < -r*flock.size_multiplier) location.y = height+r*flock.size_multiplier;
    if (location.x > width+r*flock.size_multiplier) location.x = -r*flock.size_multiplier;
    if (location.y > height+r*flock.size_multiplier) location.y = -r*flock.size_multiplier;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate() {
    float desiredseparation = r*flock.size_multiplier*flock.seperation_multiplier;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : flock.boids) {
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      //steer.normalize();
      //steer.mult(flock.maxspeed); // will work in Processing.js
      steer.setMag(flock.maxspeed);
      steer.sub(velocity);
      steer.limit(flock.maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align() {
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : flock.boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < flock.neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      //sum.normalize();
      //sum.mult(flock.maxspeed);
      sum.setMag(flock.maxspeed); // will work in Processing.js
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(flock.maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  PVector cohesion() {
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : flock.boids) {
      float d = PVector.dist(location, other.location);
      if ((d > 0) && (d < flock.neighbordist)) {
        sum.add(other.location); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the location
    } 
    else {
      return new PVector(0, 0);
    }
  }
}