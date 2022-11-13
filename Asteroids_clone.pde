Spaceship ship;
ArrayList<Shot> bullets;

boolean left=false;
boolean right=false;
boolean forward = false;
boolean shoot = false;

void setup(){
  size(600, 600);
  frameRate(30);
  ship = new Spaceship(width/2, height/2);
  bullets = new ArrayList<Shot>();
}

void draw(){
   background(0);
   stroke(255);
   noFill();
   
   //Perform all update operatiions
   ship.update();

   for (int i= bullets.size()-1; i >= 0; i--) {
      Shot bullet = bullets.get(i);
      bullet.update();
      if (!bullet.alive){
          bullets.remove(i);
      }
   }
   
   if (shoot){
     Shot bullet = ship.shoot();
     if (bullet != null){
         bullets.add(bullet);
     }
   }
   
   //draw everything to the screen
   ship.drawToScreen();
   for (Shot bullet : bullets){
      bullet.drawToScreen(); 
   }
   
}

void keyPressed(){
    if (keyCode == LEFT){
       left=true; 
    }
    if (keyCode == RIGHT){
       right=true; 
    }
    if (keyCode == UP){
       forward = true; 
    }
    if (key == ' '){
       shoot = true; 
    }
}

void keyReleased(){
    if (keyCode == LEFT){
       left=false; 
    }
    if (keyCode == RIGHT){
       right=false;
    }
    if (keyCode == UP){
       forward = false;
    }
    if (key == ' '){
       shoot = false; 
    }
}
