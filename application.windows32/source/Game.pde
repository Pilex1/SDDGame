class Game extends GUI {

  boolean paused;

  boolean launched;

  // delay before successive pauses
  // this is to prevent causing down the ESC key causing epilepsy
  int pausedCooldown;
  int curPausedCooldown;

  // cooldown when a player dies before the ball is put in to the game again
  int countdown = 60;
  int curCountdown;

  int gameWidth;
  int gameHeight;

  // height offset for the questions GUI
  int heightOffset = 250;
  // height offset for the display GUI i.e. lives and time countdown
  int displayOffset = 150;

  Player player1;
  Player player2;

  Ball ball;

  GameOption gameOption;

  QuestionBank questionsEasy;
  QuestionBank questionsHard;

  color backgroundColor;

  Game() {

    curCountdown = 0;
    pausedCooldown = 30;

    backgroundColor = color(38, 23, 84);


    gameWidth = frameWidth;
    gameHeight = frameHeight-heightOffset;

    PVector paddleSize = new PVector(20, 150);

    Paddle paddle1 = new Paddle('w', 's', new PVector(paddleSize.x/2, gameHeight/2 + heightOffset), paddleSize);
    Paddle paddle2 = new Paddle('i', 'k', new PVector(gameWidth - paddleSize.x/2, gameHeight/2 + heightOffset), paddleSize);

    player1 = new Player(paddle1);
    player2 = new Player(paddle2);

    ball = new Ball(new PVector(gameWidth/2, gameHeight/2 + heightOffset));

    components.add(paddle1);
    components.add(paddle2);
    components.add(ball);

    gameOption = null;

    questionsEasy = new QuestionBank("vocabEasy1.txt");
    questionsHard = new QuestionBank("vocabHard1.txt");
  }

  // resets the game
  void reset() {

    player1.paddle.pos = new PVector(player1.paddle.size.x/2, gameHeight/2 + heightOffset);
    player1.paddle.size = player1.paddle.originalSize.copy();

    player2.paddle.pos = new PVector(gameWidth - player1.paddle.size.x/2, gameHeight/2 + heightOffset);
    player2.paddle.size = player2.paddle.originalSize.copy();
    
    player1.curLives = player1.lives;
    player2.curLives = player2.lives;

    ball.resetBall();
    questionsScreen.reset();

    paused = true;
    launched = false;

    curCountdown = 0;

    gameOption = null;
  }

  // pauses or unpauses the game
  void toggleState() {
    paused = !paused;
    if (paused) {
      pausedOverlay.setActive(true);
    } else {
      pausedOverlay.setActive(false);
    }
  }

  void launchGame() {

    assert gameOption != null;

    // disable all title screen GUIs
    for (GUI gui : guis) {
      gui.setActive(false);
    }

    setActive(true);
    questionsScreen.setActive(true);
    gameDisplayScreen.setActive(true);

    questionsScreen.generateQuestion();

    launched = true;
    paused = false;
  }

  void onUpdate() {

    if (!launched) return;

    if (curCountdown == 1) {

      if (player1.curLives == 0) {
        deathOverlay.setActive(true);
        game.paused = true;
        deathOverlay.description.text = "Player 2 has won!";
      } else if (player2.curLives == 0) {
        deathOverlay.setActive(true);
        game.paused = true;
        deathOverlay.description.text = "Player 1 has won!";
      } else {
                
        game.ball.active = true;
        game.ball.resetBall();
        
        questionsScreen.elapsedQuestionTime = 0;
      }
    }

    if (curCountdown == countdown) {
     questionsScreen.nextQuestion(); 
    }
    if (curCountdown > 0) {
      curCountdown--;
    }



    if (curPausedCooldown > 0) {
      curPausedCooldown--;
    }

    if (keyEscape && curPausedCooldown == 0) {
      toggleState();
      curPausedCooldown = pausedCooldown;
    }
  }

  void onRender() {
    background(backgroundColor);

    if (paused) {
      pausedOverlay.onRender();
    }
  }
}

enum GameOption {
  Easy, Hard
}