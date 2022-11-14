class Bullet {
  float baseSpeed = 10;
  float baseLifetime = 60;

  //State
  PVector position;
  float angle;
  float remainingLifetime;
  boolean alive = true;
  float speed;

  Bullet(float x, float y, float angle) {
    position = new PVector(x, y);
    this.angle=angle;
    remainingLifetime = baseLifetime;
    speed = baseSpeed;
  }

  void update() {
    remainingLifetime--;
    if (remainingLifetime<0){
       alive=false; 
    }
    position.x += speed*cos(angle);
    position.y += speed*sin(angle);
    position.x = position.x%width;
    position.y = position.y%height;
    if (position.x < 0) {
      position.x = width + position.x;
    }
    if (position.y < 0) {
      position.y = height + position.y;
    }
  }

  void drawToScreen() {
    if (alive){
      strokeWeight(3);
      stroke(255);
      point(position.x, position.y);
    }
  }
}
