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
