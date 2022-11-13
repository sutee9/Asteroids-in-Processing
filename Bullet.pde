class Bullet {
  float speed = 10;

  //State
  PVector position;
  float angle;
  float remainingLifetime;
  boolean alive = true;

  Bullet(float x, float y, float angle) {
    position = new PVector(x, y);
    this.angle=angle;
    remainingLifetime = 200;
  }

  void update() {
    remainingLifetime--;
    if (remainingLifetime<0){
       alive=false; 
    }
    position.x += speed*cos(angle);
    position.y += speed*sin(angle);
  }

  void drawToScreen() {
    if (alive){
      strokeWeight(2);
      stroke(255);
      point(position.x, position.y);
    }
  }
}
