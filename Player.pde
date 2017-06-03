class Player {

  Paddle paddle;

  // cooldown if a player has answered incorrectly before he can answer again
  int curAnswerCooldown;
  int answerCooldown;

  // number of lives of the player
  int lives;

  // current number of lives of the player
  int curLives;

  Player(Paddle paddle) {
    this.paddle = paddle; 

    answerCooldown = 30;
    curAnswerCooldown = 0;
    lives = 3;
    restoreAllLives();
  }

  void resetCooldown() {
    curAnswerCooldown = 0;
  }

  // should be called when a player has answered a question incorrectly, to signify the start of a cooldown period before he can answer again
  void startCooldown() {
    curAnswerCooldown = answerCooldown;
  }

  void restoreAllLives() {
    curLives = lives;
  }

  void update() {
    if (curAnswerCooldown > 0) {
      curAnswerCooldown--;
    }
  }
}