class Player {

  Paddle paddle;

  // stores whether the player has already answered this round
  // players can only answer once per round
  boolean answered;

  // number of lives of the player
  int lives;

  // current number of lives of the player
  int curLives;

  Player(Paddle paddle) {
    this.paddle = paddle; 

    answered = false;
    lives = 3;
    restoreAllLives();
  }


  void setAnswered(boolean answered) {
    this.answered = answered;
  }

  void restoreAllLives() {
    curLives = lives;
  }
}