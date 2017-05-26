class Paddle extends GraphicsComponent {

  // keys required to move the paddle up and down
  char upKey;
  char downKey;

  // width and height
  // the x value should remain constant
  // however the y value should be constantly diminshing - players will have to correctly answer questions to grow the size of the paddle
  PVector size;

  color paddleColor;
 
  Paddle(char upKey, char downKey, PVector pos, PVector size) {
    super(pos);
    this.upKey = upKey;
    this.downKey = downKey;
    this.pos = pos;
    this.size = size;

    paddleColor = color(141, 168, 206);

    active = true;
  }

  void onUpdate() {
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
    rect(pos.x - size.x / 2, pos.y - size.y / 2, size.x, size.y);
  }
}