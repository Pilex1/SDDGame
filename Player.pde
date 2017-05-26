class Player {
 
  Paddle paddle;
  
  // number of lives of the player
  int lives;
  
  // current number of lives of the player
  int curLives;
  
  Player(Paddle paddle) {
   this.paddle = paddle; 
   
   lives = 3;
   restoreAllLives();
  }
  
  void restoreAllLives() {
   curLives = lives; 
  }
  
}