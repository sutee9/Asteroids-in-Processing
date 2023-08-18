class Asteroid {
  float speed;
  
  final float SPEED_3 = 1;
  final float SPEED_2 = 2;
  final float SPEED_1 = 3;
  final float SPEED_RND_FACTOR = 0.2; //value of speed is random by plus/minus SPEED_RND_FACTOR percent (i.e. 0.2 => +- 20%)
  final float SIZE_MULTIPLIER = 10;
  //State
  PVector position;
  float angle;

  int sizeClass = 3; //3 for a big asteroid, 2 = medium, 1 = small, and 0 = disappear.

  float[] points = new float[8];
  
  //
  Asteroid(float x, float y, float angle, int sizeClass) {
    this.position = new PVector(x, y);
    this.angle=angle;
    setSizeClass(sizeClass);
    adjustSpeed();
  }

  //A big Asteroid, with random angle, random speed
  Asteroid(float x, float y) {
    this.position = new PVector(x, y);
    this.angle=random(0, TWO_PI);
    setSizeClass(sizeClass);
    adjustSpeed();
  }
  
  void setSizeClass(int newSizeClass){
      this.sizeClass = newSizeClass;

      //Create a random outline of the rock (points measures the distance from the center of the rock)
      for (int i = 0; i < points.length; i++){
         points[i] = random(0.7, 1);
         println(points[i]);
      }
      points[0]=random(0.2, 0.6); //makes the form a bit more interesting
  }

  void update() {
    position.x = (position.x + speed*cos(angle)) % width;
    position.y = (position.y + speed*sin(angle)) % height;
    if (position.x < 0) {
      position.x = width + position.x;
    }
    if (position.y < 0) {
      position.y = height + position.y;
    }
  }

  void drawToScreen() {
    //println("x="+position.x+", y="+position.y);
    pushMatrix();
    translate(position.x, position.y);
    rotate(angle);
    strokeWeight(1);
    stroke(255);
    beginShape();
    float angleIncrement = TWO_PI/(float)points.length;
    float a=0;
    for (int i=0; i < points.length; i++){
      a+=angleIncrement;
      //println("angle"+i+"="+a);
      vertex(sizeClass*SIZE_MULTIPLIER*cos(a)*points[i], sizeClass*SIZE_MULTIPLIER*sin(a)*points[i]);
    }
    endShape(CLOSE);
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
  
  //Can this Android be split? If not, it would be destroyed upon shooting it.
  boolean isSplittable(){
     return sizeClass > 1;
  }
  
  //Splits the asteroid in two parts and returns the new one
  Asteroid split(){
      //Create a new Asteroid
      Asteroid newRoid = new Asteroid(position.x, position.y, this.angle+0.55, sizeClass-1); //about 30° change in movement direction.
      
      //Deviate the old one
      this.angle = angle - 0.55;
      setSizeClass(sizeClass - 1);
      adjustSpeed();
      
      return newRoid;
  }

  //Change the speed to match the size class.
  //Note: If called without previously changing size class, the speed will change within the range 
  //of a random factor.
  void adjustSpeed(){
    switch(sizeClass) {
    case 3:
      speed = SPEED_3;
    case 2:
      speed = SPEED_2;
    case 1:
      speed = SPEED_1;
    default:
      speed = SPEED_3;
    }
    //randomize Speed a bit
    speed = speed * random(1-SPEED_RND_FACTOR, 1+SPEED_RND_FACTOR);
  }

  boolean isCollidingWith(Bullet b) {
    //Generously collide with bullets)
    if (dist(b.position.x, b.position.y, this.position.x, this.position.y) < sizeClass*SIZE_MULTIPLIER*1.8) {
      return true;
    } else {
      return false;
    }
  }

  boolean isCollidingWith(Spaceship ship) {
    if (ship.isInvulnerable()){
       return false; 
    }
    else {
      //Be very generous when it comes to player collisions.
      if (dist(ship.position.x, ship.position.y, this.position.x, this.position.y) < sizeClass*SIZE_MULTIPLIER*1.5) {
        return true;
      } else {
        return false;
      }
    }
  }
}
