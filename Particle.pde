class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l, PVector v, PVector a) {
    location = l.copy();
    acceleration = a.copy();
    velocity = v.copy();
    lifespan = 50;
  }

  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 4.0;
  }
  
  boolean isDead(){
     return lifespan < 0.0; 
  }

  void display() {
    stroke(255);
    fill(175);
    line(location.x, location.y, location.x+velocity.x, location.y+velocity.y);
  }
}
