Spaceship ship;
ArrayList<Bullet> bullets;
ArrayList<Asteroid> asteroids;

boolean left=false;
boolean right=false;
boolean forward = false;
boolean shoot = false;

int score = 0;
int lives = 3;

void setup() {
  size(600, 600);
  frameRate(60);
  ship = new Spaceship(width/2, height/2);
  bullets = new ArrayList<Bullet>();
  asteroids = new ArrayList<Asteroid>();
}

void draw() {
  background(0);
  stroke(255);
  noFill();

  //Perform all update operatiions
  ship.update();

  for (int i= bullets.size()-1; i >= 0; i--) {
    Bullet bullet = bullets.get(i);
    bullet.update();
    if (!bullet.alive) {
      bullets.remove(i);
    }
  }

  //Update Asteroids and check if they collided with bullets
  for (int i= asteroids.size()-1; i >= 0; i--) {
    Asteroid asteroid = asteroids.get(i);
    asteroid.update();
    for (int k= bullets.size()-1; k >= 0; k--) {
      Bullet bullet = bullets.get(k);
      
      if (asteroid.isCollidingWith(bullet)){
         bullets.remove(bullet);
         asteroids.remove(asteroid); //this is wrong, should split!
         score += asteroid.getScore();    
      }
    }
  }

  if (shoot) {
    Bullet bullet = ship.shoot();
    if (bullet != null) {
      bullets.add(bullet);
      asteroids.add(new Asteroid(random(0, width), random(0, height)));
    }
  }

  //draw everything to the screen
  ship.drawToScreen();
  for (Bullet bullet : bullets) {
    bullet.drawToScreen();
  }
  for (Asteroid asteroid : asteroids) {
    asteroid.drawToScreen();
  }
  
  text(score, 100, 100);
}

void keyPressed() {
  if (keyCode == LEFT) {
    left=true;
  }
  if (keyCode == RIGHT) {
    right=true;
  }
  if (keyCode == UP) {
    forward = true;
  }
  if (key == ' ') {
    shoot = true;
  }
}

void keyReleased() {
  if (keyCode == LEFT) {
    left=false;
  }
  if (keyCode == RIGHT) {
    right=false;
  }
  if (keyCode == UP) {
    forward = false;
  }
  if (key == ' ') {
    shoot = false;
  }
}
