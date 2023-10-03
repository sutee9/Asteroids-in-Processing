class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l, PVector v, PVector a, int lifespan) {
    location = l.copy();
    velocity = v.copy();
    acceleration = a.copy();
    this.lifespan = lifespan;
  }

  void update() {
    //println("life=" +lifespan+ ", loc="+location+", vel="+velocity);
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
  }
  
  boolean isDead(){
     return lifespan < 0.0; 
  }

  void display() {
    pushMatrix();
    stroke(255);
    strokeWeight(2);
    line(location.x, location.y, location.x+velocity.x, location.y+velocity.y);
    popMatrix();
  }
}
