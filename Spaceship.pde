class Spaceship {
  //Config
  float rotSpeed=0.11;
  float accel = 0.091;
  //float decay = 0.004; //Not working, the logic is wrong, remove it for now
  int gunCooldownTime = 10;//frames
  float gunOrigin = 20; //Pixels in X from center

  //shipState
  PVector position;
  PVector force;
  float angle;
  float speed;
  boolean accelerating = false;
  float gunCooldown = gunCooldownTime;

  Spaceship(float x, float y) {
    position = new PVector(x, y);
    force = new PVector();
  }

  void update() {
    if (gunCooldown > 0){
       gunCooldown--; 
    }
    
    //Process Movement
    if (forward) {
      force.x += accel*cos(angle);
      force.y += accel*sin(angle);
      accelerating = true;
    } else {
      //develerate when no input, but avoid moving backwards 
      //This doesn't work properly: It accelerates the ship towards right and bottom
      //force.x = force.x - decay*cos(angle);
      //force.y = force.y - decay*sin(angle);
      //if (force.x < 0) {
      //  force.x = 0;
      //}
      //if (force.x < 0) {
      //  force.y = 0;
      ////}
      accelerating=false;
    }
    //Position
    position.x += force.x;
    position.y += force.y;
    position.x = position.x%width;
    position.y = position.y%height;
    if (position.x < 0) {
      position.x = width + position.x;
    }
    if (position.y < 0) {
      position.y = height + position.y;
    }

    //Rotation
    if (left) {
      angle += rotSpeed;
    }
    if (right) {
      angle -= rotSpeed;
    }
  }
  
  Shot shoot(){
    if (gunCooldown <= 0){
      gunCooldown = gunCooldownTime;
      return new Shot(position.x+cos(angle)*gunOrigin, position.y+sin(angle)*gunOrigin, angle);
    }
    else {
       return null; 
    }
  }

  void drawToScreen() {
    pushMatrix();
    translate(position.x, position.y);
    
    rotate(angle);
    strokeWeight(1);
    triangle(-20, -20, -20, 20, 20, 0);
    popMatrix();

    //Todo: If accelating, draw exhaust
  }
}
