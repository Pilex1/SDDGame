class DifficultyScreen extends GUI {
  
  Label lblPlayerMode;

  DifficultyScreen() {
    super(); 
    PVector size = new PVector(frameWidth / 4, 100);
    int spacingY = 50;
    int posX = frameWidth - 100 - (int)size.x;
    int posY = 100;
    
    // displays the player mode i.e. Singleplayer or multiplayer
    lblPlayerMode = new Label(new PVector(posX + size.x / 2, posY), "");
    components.add(lblPlayerMode);
    posY += spacingY;
    
    // displays "Select a difficulty"
    components.add(new Label(new PVector(posX + size.x / 2, posY), "Select a difficulty"));
    posY += spacingY;
    
    // Button for easy difficulty
    components.add(new Button(new PVector(posX, posY), size, "Easy", new IAction() {
      public void action() {
        game.gameOption.difficulty = DifficultyOption.Easy;
        game.launchGame();
      }
    }
    ));
    posY += size.y + spacingY;
    
    // Button for hard difficulty
    components.add(new Button(new PVector(posX, posY), size, "Hard", new IAction() {
      public void action() {
        game.gameOption.difficulty = DifficultyOption.Hard;
        game.launchGame();
      }
    }
    ));
    posY += size.y + spacingY;
    
    // Button for cancelling difficulty selection (hides the difficulty screen)
    components.add(new Button(new PVector(posX, posY), size, "Cancel", new IAction() {
      public void action() {
        difficultyScreen.setActive(false);
        game.gameOption.playerOption = null;
      }
    }
    ));
  }
}