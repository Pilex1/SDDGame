class Paddle extends GraphicsComponent {

  // keys required to move the paddle up and down
  char upKey;
  char downKey;

  // width and height
  // the x value should remain constant
  // however the y value should be constantly diminshing - players will have to correctly answer questions to grow the size of the paddle
  PVector size;
  
  float minimumY;

  color paddleColor;

  Paddle(char upKey, char downKey, PVector pos, PVector size) {
    super(pos);
    this.upKey = upKey;
    this.downKey = downKey;
    this.pos = new PVector(pos.x, pos.y);
    this.size = new PVector(size.x, size.y);
    minimumY = 5;

    paddleColor = color(141, 168, 206);

    active = true;
  }

  // gets called when an answer has been answered correctly; increases paddls size
  void increaseSize() {
    size.y += 30;
  }

  // gets called when an answer has been answered incorrectly; decreases paddle size
  void decreaseSize() {
    size.y -= 5;
    if (size.y < minimumY) {
      size.y = minimumY;
    }
  }

  void onUpdate() {

    // gradually decrease paddle size
    size.y -= 0.02;
    if (size.y < minimumY) {
      size.y = minimumY;
    }

    float speed = 10;
    if (keys[upKey]) {
      pos.y -= speed;
    }
    if (keys[downKey]) {
      pos.y += speed;
    }

    // boundary checking
    // prevent the paddles from going outside the screen
    if (pos.y - size.y/2 < game.heightOffset) {
      pos.y = size.y/2 + game.heightOffset;
    }
    if (pos.y + size.y/2 > game.heightOffset + game.gameHeight) {
      pos.y = game.heightOffset + game.gameHeight - size.y/2;
    }
  }

  void onRender() {
    fill(paddleColor);
    strokeWeight(0);
    rect(pos.x - size.x / 2, pos.y - size.y / 2, size.x, size.y);
  }
}