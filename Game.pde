class Game extends GUI {

  int gameWidth;
  int gameHeight;

  // height offset for the questions GUI
  int heightOffset;

  Paddle paddle1;
  Paddle paddle2;
  Ball ball;

  GameOption gameOption;

  Game() {

    heightOffset = 200;

    gameWidth = frameWidth;
    gameHeight = frameHeight-heightOffset;

    PVector paddleSize = new PVector(20, 100);

    paddle1 = new Paddle('w', 's', new PVector(paddleSize.x/2, gameHeight/2 + heightOffset), paddleSize);
    paddle2 = new Paddle('i', 'k', new PVector(gameWidth - paddleSize.x/2, gameHeight/2 + heightOffset), paddleSize);
    ball = new Ball(new PVector(gameWidth/2, gameHeight/2 + heightOffset), 18, 0.1);

    components.add(paddle1);
    components.add(paddle2);
    components.add(ball);

    gameOption = new GameOption();
  }

  void launchGame() {

    assert gameOption != null;
    assert gameOption.playerOption != null;
    assert gameOption.difficulty != null;

    // disable all title screen GUIs
    for (GUI gui : guis) {
      gui.setActive(false);
    }

    setActive(true);
    questionsScreen.setActive(true);
  }

  void onRender() {
    background(backgroundColor);
  }

  void onUpdate() {

    // DEBUG CODE
    // press space to bring the ball back to the center
    if (keys[' ']) {
      ball.pos.x = width/2;
      ball.pos.y = height/2;
    }
  }
}