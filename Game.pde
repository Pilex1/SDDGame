class Game extends GUI {

  int gameWidth;
  int gameHeight;

  // height offset for the questions GUI
  int heightOffset;

  Player player1;
  Player player2;

  Ball ball;

  GameOption gameOption;
  
  QuestionBank questionsEasy;
  QuestionBank questionsHard;
  
  color backgroundColor;

  Game() {

    backgroundColor = color(38, 23, 84);
    
    heightOffset = 200;

    gameWidth = frameWidth;
    gameHeight = frameHeight-heightOffset;

    PVector paddleSize = new PVector(20, 100);

    Paddle paddle1 = new Paddle('w', 's', new PVector(paddleSize.x/2, gameHeight/2 + heightOffset), paddleSize);
    Paddle paddle2 = new Paddle('i', 'k', new PVector(gameWidth - paddleSize.x/2, gameHeight/2 + heightOffset), paddleSize);
  
    player1 = new Player(paddle1);
    player2 = new Player(paddle2);
  
    ball = new Ball(new PVector(gameWidth/2, gameHeight/2 + heightOffset));

    components.add(paddle1);
    components.add(paddle2);
    components.add(ball);

    gameOption = new GameOption();
    
    questionsEasy = new QuestionBank("vocabEasy1.txt");
    questionsHard = new QuestionBank("vocabHard1.txt");
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
    
    questionsScreen.generateQuestion();

  }

  void onRender() {
    background(backgroundColor);
  }

}

enum PlayerOption {
   Singleplayer, Multiplayer 
}
enum DifficultyOption {
   Easy, Hard 
}

class GameOption {
   PlayerOption playerOption;
   DifficultyOption difficulty;
   
   GameOption() {
    playerOption = null;
    difficulty = null;
   }
}