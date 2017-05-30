class Ball extends GraphicsComponent {

  // speed of the ball
  // should remain constant
  float speed;

  // angle that the ball is facing in radians
  float theta;

  color ballColor;

  // diameter of the ball
  float size;

  Ball(PVector pos, float speed, float theta) {
    super(pos);
    this.speed = speed;
    this.theta = theta;

    ballColor = color(191, 99, 99);

    size = 32;

    active = true;
  }

  void onUpdate() {

    // default position updating
    pos.x += speed * cos(theta);
    pos.y += speed * sin(theta);

    // collision with top wall
    // bounce the ball
    if (pos.y - size/2 < game.heightOffset) {
      theta = -1 * theta + 2 * PI;
      while (pos.y - size/2 < game.heightOffset) {
        pos.x += speed * cos(theta);
        pos.y += speed * sin(theta);
      }
    }

    // collision with bottom wall
    // bounce the ball
    if (pos.y + size/2 > frameHeight) {
      theta = -1 * theta + 2 * PI;
      while (pos.y + size/2 > frameHeight) {
        pos.x += speed * cos(theta);
        pos.y += speed * sin(theta);
      }
    }

    // collision with the left side of the screen
    if (pos.x - size/2 <= game.paddle1.pos.x + game.paddle1.size.x/2) {
      if (pos.y + size/2 >= game.paddle1.pos.y - game.paddle1.size.y/2 && pos.y - size/2 <= game.paddle1.pos.y + game.paddle1.size.y/2) {
        // if it collides with the paddle
        // then the ball rebounds
        theta = -1 * theta + PI;
        while (pos.x - size/2 <= game.paddle1.pos.x + game.paddle1.size.x/2) {
          pos.x += speed * cos(theta);
          pos.y += speed * sin(theta);
        }
      } else {
        // else the ball has gone out of the bounds of the screen and the player loses
               game.setActive(false);

      }
    }

    // collision with player 2 paddle (on the right of the screen)
    // bounce the ball
    if (pos.x + size/2 >= game.paddle2.pos.x - game.paddle2.size.x/2) {
      if (pos.y + size/2 >= game.paddle2.pos.y - game.paddle2.size.y/2 && pos.y - size/2 <= game.paddle2.pos.y + game.paddle2.size.y/2) {
        // if it collides with the paddle
        // then the ball rebounds
        theta = -1 * theta + PI;
        while (pos.x + size/2 >= game.paddle2.pos.x - game.paddle2.size.x/2) {
          pos.x += speed * cos(theta);
          pos.y += speed * sin(theta);
        }
      } else {
        // else the ball has gone out of the bounds of the screen and the player loses
        game.setActive(false);
      }
    }

  
  
    // DEBUGGING CODE
    /*
    float temp = 1;
    if (keys['t']) {
      pos.y -= temp;
    }
    if (keys['g']) {
      pos.y += temp;
    }
    if (keys['f']) {
      pos.x -= temp;
    }
    if (keys['h']) {
      pos.x += temp;
    }
    */
    
  }

  void onRender() {
    fill(ballColor);
    ellipse(pos.x, pos.y, size, size);
  }
}