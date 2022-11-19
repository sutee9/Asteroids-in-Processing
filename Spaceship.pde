class Spaceship {
  //Config
  float rotSpeed=0.09;
  float accel = 0.046;
  //float decay = 0.004; //Not working, the logic is wrong, remove it for now
  int gunCooldownTime = 16;//frames
  int respawnTime = 120; //frames
  float gunOrigin = 14; //Pixels in X from center

  //shipState
  PVector position;
  PVector force;
  float angle;
  boolean accelerating = false;
  float gunCooldown = gunCooldownTime;
  float respawnTimer = 0;

  Spaceship(float x, float y) {
    position = new PVector(x, y);
    force = new PVector();
  }

  void update() {
    if (gunCooldown > 0){
       gunCooldown--; 
    }
    
    //Check if we have recently died and have to respawn the ship
    if (respawnTimer > 0){
       respawnTimer--;
       if (respawnTimer <= 0){
          respawnShip(); 
       }
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
      angle -= rotSpeed;
    }
    if (right) {
      angle += rotSpeed;
    }
    angle = angle% TWO_PI;
  }
  
  /**
   * Resets all the variables so that the ship returns into neutral position.
   */
  void respawnShip(){
     position.x = width/2;
     position.y = height/2;
     force.x = 0.0;
     force.y = 0.0;
     angle = 0;
  }
  /**
   * Shoots a bullet in the direction the ship is facing and returns it
   */
  Bullet shoot(){
    if (gunCooldown <= 0){
      gunCooldown = gunCooldownTime;
      return new Bullet(position.x+cos(angle)*gunOrigin, position.y+sin(angle)*gunOrigin, angle);
    }
    else {
       return null; 
    }
  }
  
  boolean isInvulnerable(){
    //println("Ship is invulnerable="+ (respawnTimer > 0)); 
    return respawnTimer > 0;
  }

  //Draw the ship to the screen
  void drawToScreen() {
    if (isInvulnerable()){ //Don't draw the ship if it is invulnerable. TODO: This isn't cute. I should show it.
       return; 
    }
    pushMatrix();
    translate(position.x, position.y);
    
    //ship
    rotate(angle);
    strokeWeight(1);
    line(-15, -10, 15, 0);
    line(-15, 10, 15, 0);
    ellipseMode(CENTER);
    arc(-44, 0, 60, 60, -0.34, 0.34);
    
    //flame
    if(accelerating){
      translate(-15, 0);
      line(0, -6, -11-2*sin(frameCount*2), 0);
      line(0, 6, -11-2*sin(frameCount*2), 0);
    }
    popMatrix(); 
  }
  
  void destroy(){
      respawnTimer = respawnTime;
  }
}
