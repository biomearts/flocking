// The Flock (a list of Boid objects)

class Flock {
  ArrayList<Boid> boids; // An ArrayList for all the boids
  PVector flow_dir; // environmental air flow
  float flow_rad;
  float flow_speed;
  float additional_speed; // human control
  
  // system parameters
  float N = 85;
  float default_size = 10;
  float size_multiplier = 1.0;
  float minspeed = 0.1;
  float maxspeed = 2;
  float maxforce = 0.03;
  int shape = 0;
  
  float neighbordist = 50;
  float seperation_multiplier = 1.75;

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
    flow_dir = new PVector(0,0);
    flow_rad = 0;
    flow_speed = 0;
    additional_speed = 0;
    
    for(int i = 0; i < N; i++) {
      addBoid(0, 0);
    }
  }
  void addBoid(float x, float y) {
    boids.add(new Boid(x, y, this));
  }
  void run() {
    // draw wind direction
    if(draw_flow_dir) {
      pushStyle();
      noFill();
      strokeWeight(2);
      stroke(0, 255, 0);
      pushMatrix();
        translate(width/2, height/2);
        rotate(flow_rad);
        line(-flow_dir_stem_len, 0, flow_dir_stem_len, 0);
        translate(flow_dir_stem_len, 0);
        rotate(PI/4);
        line(0, 0, 0, flow_dir_tick_len);
        rotate(PI/2);
        line(0, 0, 0, flow_dir_tick_len);
      popMatrix();
      popStyle();
    }
    
    for(Boid b : this.boids) {
      b.run();
    }
  }
  
  void changeShape() {
    shape = (shape + 1)%3;
    println("[Flock] shape", shape);
  }
  void controlSize(float z) {
    if(size_multiplier + z > 0) {
      size_multiplier += z;
      println("[Flock] size", size_multiplier);
    }
  }
  void controlNeighbor(int n) {
    if(neighbordist + n > 0) {
      neighbordist += n;
      println("[Flock] neighbor dist", neighbordist);
    }
  }
  void controlSpeed(float s) {
    maxspeed = (maxspeed + s < minspeed ? minspeed : maxspeed + s);
    additional_speed += s;
    println("[Flock] maxspeed", maxspeed);
    println("[Flock] flow speed", flow_speed, "additional speed", additional_speed);
  }
  void updateFlowSpeed(float s) {
    if(s > 0) {
      flow_speed = s*0.01;
      println("[Flock] flow speed", flow_speed);
    }
  }
  void updateFlowDirection(int d) {
    if(d > 0) {
      d = d + NORTH;
      flow_rad = radians(d);
      flow_dir.x = cos(flow_rad);
      flow_dir.y = sin(flow_rad);
      flow_dir.mult(0.01);
      println("[Flock] flow rad", flow_rad, "dir", flow_dir);
    }
  }
}