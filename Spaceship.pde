class Spaceship {
  //Config
  float rotSpeed=0.09;
  float accel = 0.046;
  //float decay = 0.004; //Not working, the logic is wrong, remove it for now
  int gunCooldownTime = 16;//frames
  float gunOrigin = 14; //Pixels in X from center

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
  
  Bullet shoot(){
    if (gunCooldown <= 0){
      gunCooldown = gunCooldownTime;
      return new Bullet(position.x+cos(angle)*gunOrigin, position.y+sin(angle)*gunOrigin, angle);
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
    line(-15, -10, 15, 0);
    line(-15, 10, 15, 0);
    ellipseMode(CENTER);
    arc(-44, 0, 60, 60, -0.34, 0.34);
    
    if(accelerating){
      translate(-15, 0);
      line(0, -6, -11-2*sin(frameCount*2), 0);
      line(0, 6, -11-2*sin(frameCount*2), 0);
    }
    popMatrix(); 
  }
}
