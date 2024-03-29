Spaceship ship;
ArrayList<Bullet> bullets;
ArrayList<Asteroid> asteroids;

boolean left=false;
boolean right=false;
boolean forward = false;
boolean shoot = false;

//Configuration

int defaultNumLives = 3;
float waveAsteroidCount = 2; //How many asteroids are there in the wave
float waveMultiplier = 1.2; //how many more asteroids will be spawned each time.

//Game State
int score = 0;
int lives = defaultNumLives;
int currentWave = 0; //Which wave are we in

final int STATE_TITLESCREEN = 1;
final int STATE_GAME = 2;
final int STATE_GAMEOVER = 3;
int state;

boolean blinkState = true;
float timer1; //used in title for blinking, and gameover to drive returning to title. Also used in game for wait time after a wave is complete.
float timer2;
boolean displayWave = false;

AudioManager audioMgr;

//ParticleSystem p = new ParticleSystem();

void setup() {
  size(600, 600);
  frameRate(60);
  audioMgr= new AudioManager(this);
  
  ship = new Spaceship(width/2, height/2);
  
  bullets = new ArrayList<Bullet>();
  asteroids = new ArrayList<Asteroid>();

  setState(STATE_TITLESCREEN);
}

void draw() {


  switch(state) {
  case STATE_TITLESCREEN:
    drawTitleScreen();
    break;
  case STATE_GAME:
    updateGame();
    drawGame();
    break;
  case STATE_GAMEOVER:
    drawGameOver();
    break;
  }
}

void drawTitleScreen() {
  //Update
  if (keyPressed) {
    setState(STATE_GAME);
  }

  if (timer1 > 0) { //timer1 is used for blinking the button text
    timer1 = timer1-1/(float)frameRate;
  } else {
    blinkState = !blinkState;
    timer1 = 1.0;
  }

  //Draw the screen
  background(0);
  fill(255);
  textSize(30);
  text("Asteroids", (width-textWidth("Asteroids"))/2, 200);
  if (blinkState) {
    textSize(20);
    text("Press any button to start", (width-textWidth("Press any button to start"))/2, 300);
  }
  //p.run();
}

void updateGame() {
  //Initialize with first wave when game starts (wave==0)
  if (currentWave == 0 && asteroids.size() == 0) {
    if (timer1 > 0) {
      timer1 -= 1/(float)frameRate;
      displayWave=true;
    } else {
      displayWave=false;
      currentWave=1;
      for (int i = 0; i < waveAsteroidCount; i++) {

        asteroids.add(new Asteroid(random(0, width), random(0, height)));
      }
      timer1 = 2.0;
    }
  }

  //PERFORM ALL UPDATE OPERATIONS
  //If no andoids are left, go to next wave
  else if (currentWave > 0 && asteroids.size() == 0) {
    if (timer1 > 0) {
      timer1 -= 1/(float)frameRate;
      displayWave=true;
    } else if (timer1 < 0 && timer1 > -1) { //Timer has expired, start a new wave
      displayWave=false;
      currentWave++;
      waveAsteroidCount=waveAsteroidCount*waveMultiplier;
      int currentWaveAsteroids = floor(waveAsteroidCount);
      for (int a=0; a < currentWaveAsteroids; a++) {
        asteroids.add(new Asteroid(random(0, width), random(0, height)));
      }
      timer1=2.0;
    }
  }

  //Check level
  if (lives <= 0) {
    setState(STATE_GAMEOVER);
  }
  ship.update();

  for (int i= bullets.size()-1; i >= 0; i--) {
    Bullet bullet = bullets.get(i);
    bullet.update();
    if (!bullet.alive) {
      bullets.remove(i);
    }
  }

  //Update Asteroids and check if they collided with bullets or the ship
  for (int i= asteroids.size()-1; i >= 0; i--) {
    Asteroid asteroid = asteroids.get(i);
    asteroid.update();

    //Check if collided with bullets
    for (int k= bullets.size()-1; k >= 0; k--) {
      Bullet bullet = bullets.get(k);

      if (asteroid.isCollidingWith(bullet)) {

        //remove the bullet and add the score.
        bullets.remove(bullet);
        score += asteroid.getScore();

        //Split or destroy the asteroid
        if (asteroid.isSplittable()) {
          Asteroid newRoid = asteroid.split();
          asteroids.add(newRoid);
        } else {
          asteroids.remove(asteroid.destroy());
        }
      }
    }

    //Check if collision with ship
    if (asteroid.isCollidingWith(ship)) {
      lives--;
      ship.destroy();
    }
  }
  if (shoot) {
    Bullet bullet = ship.shoot();
    if (bullet != null) {
      bullets.add(bullet);
    }
  }
}

void drawGame() {
  //DRAW EVERYTHING TO THE SCREEN
  background(0);
  stroke(255);
  noFill();

  ship.drawToScreen();
  for (Bullet bullet : bullets) {
    bullet.drawToScreen();
  }
  for (Asteroid asteroid : asteroids) {
    asteroid.drawToScreen();
  }
  textSize(20);
  text(score, 80, 80);
  displayLives();

  if (displayWave) {
    displayWave();
  }
}

void displayWave() {
  fill(255);
  textSize(20);

  text("WAVE " + (currentWave+1), width/2-textWidth("WAVE " + currentWave)/2.0, (height-100)/2.0);
}

/**
 * Displays as many space ships in the
 * uppper left corner as I have lives.
 */
void displayLives() {
  pushMatrix();
  translate(87, 110);
  noFill();
  float spacing = 17.0;

  for (int i = 0; i < lives; i++) {
    strokeWeight(1);

    line(i*spacing -7, 12, i*spacing, -12);
    line(i*spacing + 7, 12, i*spacing, -12);
    ellipseMode(CENTER);
    arc(i*spacing, 34, 45, 45, PI+HALF_PI-0.29, PI+HALF_PI+0.29);
  }
  popMatrix();
}

void drawGameOver() {
  timer1 = timer1 - 1.0/(float)frameRate; //frame independent countdown
  if (timer1 < 0) {
    setState(STATE_TITLESCREEN);
  }
  background(0);
  fill(255);
  textSize(20);

  text("Game Over", width/2-textWidth("Game Over")/2.0, 200);
}

/**
 * Use this function to initialise and clean up all
 * variables when switching into a new state
 */
void setState(int newState) {
  //Only change state if it's different from the current state
  if (newState == state) {
    return;
  }

  //Set the new state
  println("Setting new State="+newState);
  state = newState;
  switch(newState) {
  case STATE_TITLESCREEN:
    timer1=1.0;
    break;
  case STATE_GAME:
    timer1= 2;
    lives = defaultNumLives;
    break;
  case STATE_GAMEOVER:
    timer1 = 3.0; //3 seconds
    break;
  }
}
