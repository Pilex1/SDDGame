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