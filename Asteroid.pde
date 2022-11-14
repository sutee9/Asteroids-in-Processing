class Asteroid {
  float speed = 10;

  //State
  PVector position;
  float angle;

  int sizeClass = 3; //3 for a big asteroid, 2 = medium, 1 = small, and 0 = disappear.

  //
  Asteroid(float x, float y, float angle, int sizeClass, float speed) {
    this.position = new PVector(x, y);
    this.angle=angle;
    this.sizeClass=sizeClass;
    this.speed=speed;
  }

  //A big Asteroid, with random angle, random speed
  Asteroid(float x, float y) {
    this.position = new PVector(x, y);
    this.angle=random(0, TWO_PI);
    this.sizeClass=3;
    this.speed=random(0.2, 3);
  }

  void update() {
    position.x += speed*cos(angle);
    position.y += speed*sin(angle);
  }

  void drawToScreen() {
    pushMatrix();
    translate(position.x, position.y);

    rotate(angle);
    strokeWeight(1);
    stroke(255);
    rectMode(CENTER);
    rect(0, 0, sizeClass*20, sizeClass * 20);

    popMatrix();
  }

  //Score differs depending on Size
  int getScore() {
    switch(sizeClass) {
    case 3:
      return 20;
    case 2:
      return 50;
    case 1:
      return 100;
    default:
      return 20;
    }
  }
  
  //Splits the asteroid in two parts and returns the new one
  Asteroid split(){
      return new Asteroid(position.x, position.y);
  }

  boolean isCollidingWith(Bullet b) {
    //Generously collide with bullets (sizeClass * 20)
    if (dist(b.position.x, b.position.y, this.position.x, this.position.y) < sizeClass*20) {
      return true;
    } else {
      return false;
    }
  }

  boolean isCollidingWith(Spaceship ship) {
    //Be very generous when it comes to player collisions.
    if (dist(ship.position.x, ship.position.y, this.position.x, this.position.y) < sizeClass*15) {
      return true;
    } else {
      return false;
    }
  }
}
