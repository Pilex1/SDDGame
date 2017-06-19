class Ball extends GraphicsComponent {
  
  // initial starting position of the ball
  // when a player loses, the ball also gets reset to this position
  PVector startingPos;

  // initial starting angle range for the ball
  // when a player loses, the ball's angle gets set a number between this range
  float thetaMin;
  float thetaMax;
  // angle that the ball is facing in radians
  float theta;

  // speed of the ball
  // should remain constant
  float speed;

  color ballColor;

  // diameter of the ball
  float size;

  // determines if the ball is past the bounds of the game, in which case one of the players have lost
  boolean outOfBounds;

  Ball(PVector pos) {
    super(pos);
    startingPos = new PVector(pos.x, pos.y);
    speed = 5;

    thetaMin = -PI/8;
    thetaMax = PI/8;

    ballColor = color(191, 99, 99);
    size = 32;
    active = true;
    outOfBounds = false;

    resetBall();
  }

  void resetBall() {
    pos.x = startingPos.x;
    pos.y = startingPos.y;

    theta = random(thetaMin, thetaMax);
    
    if (random(1) < 0.5) {
     theta += PI; 
    }

    outOfBounds = false;
  }

  void onUpdate() {

    if (game.paused) return;

    // for debugging purposes
    /*float v = 5;
    if (keys['f']) {
      pos.x -= v;
    }
    if (keys['h']) {
      pos.x += v;
    }
    if (keys['t']) {
      pos.y -= v;
    }
    if (keys['g']) {
      pos.y += v;
    }

    if (keys['b']) {
      speed = 0;
    }*/
    // end debugging code



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
      
      speed += 0.1;
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


    Paddle paddle1 = game.player1.paddle;
    Paddle paddle2 = game.player2.paddle;
    
    float maxAngle = PI/4;

    if (outOfBounds) {
      if (pos.x+size/2 < 0) {
        game.player1.die();
      }
      if (pos.x-size/2 >= frameWidth) {
        game.player2.die();
      }
    } else {
      // collision with player 1 paddle (on the left of the screen)
      // bounce the ball
      if (pos.x - size/2 <= paddle1.pos.x + paddle1.size.x/2) {
        if (pos.y + size/2 >= paddle1.pos.y - paddle1.size.y/2 && pos.y - size/2 <= paddle1.pos.y + paddle1.size.y/2) {

          // calculating angle trajectory on rebound
          float ry = pos.y - paddle1.pos.y;

          float rebound = ry / paddle1.size.y;
          //assert(abs(rebound)<=1);
          rebound *= 0.2;

          theta = rebound;
          if (theta < -maxAngle) {
           theta = maxAngle; 
          }
          if (theta > maxAngle) {
           theta = maxAngle; 
          }
          
          
          pos.x = paddle1.pos.x + paddle1.size.x/2 + size/2;

          /*while (pos.x - size/2 <= paddle1.pos.x + paddle1.size.x/2) {
            pos.x += speed * cos(theta);
            pos.y += speed * sin(theta);
          }*/
        } else {
          // ball has gone out of bounds
          outOfBounds = true;
        }
      }

      // collision with player 2 paddle (on the right of the screen)
      // bounce the ball
      if (pos.x + size/2 >= paddle2.pos.x - paddle2.size.x/2) {
        if (pos.y + size/2 >= paddle2.pos.y - paddle2.size.y/2 && pos.y - size/2 <= paddle2.pos.y + paddle2.size.y/2) {

          // calculating angle trajectory on rebound
          float ry = pos.y - paddle1.pos.y;

          float rebound = ry / paddle1.size.y;
          //assert(abs(rebound)<=1);
          rebound *= -0.3;

          theta = rebound;
          if (theta < -maxAngle) {
           theta = -maxAngle; 
          }
          if (theta > maxAngle) {
           theta = maxAngle; 
          }
          
          theta+=PI;
          
          pos.x = paddle2.pos.x - paddle2.size.x/2 - size/2;

          /*while (pos.x + size/2 >= paddle2.pos.x - paddle2.size.x/2) {
            pos.x += speed * cos(theta);
            pos.y += speed * sin(theta);
          }*/
        } else {
          // ball has gone out of bounds
          outOfBounds = true;
        }
      }
    }
  }

  void onRender() {
    fill(ballColor);
    strokeWeight(0);
    ellipse(pos.x, pos.y, size, size);
  }
}