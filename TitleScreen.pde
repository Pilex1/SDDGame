class TitleScreen extends GUI {

  TitleScreen() {
    super();

    // size of each button
    PVector size = new PVector(frameWidth/2, 100);
    // vertical spacing between each button
    int spacingY = 50;

    int posX = 100;
    int posY = 100;

    super.components.add(new Button(new PVector(posX, posY), size, "Singleplayer", new IAction() {
      public void action() {
        // show the difficulty selection screen and set game option to Singleplayer
        difficultyScreen.setActive(true);
        difficultyScreen.lblPlayerMode.text = "Singleplayer";
        game.gameOption.playerOption = PlayerOption.Singleplayer;
      }
    }
    ));

    posY += spacingY + size.y;
    super.components.add(new Button(new PVector(posX, posY), size, "Multiplayer", new IAction() {
      public void action() {
        // show the difficulty selection screen and set game option to Multiplayer
        difficultyScreen.setActive(true);
        difficultyScreen.lblPlayerMode.text = "Multiplayer";
        game.gameOption.playerOption = PlayerOption.Multiplayer;
      }
    }
    ));

    posY += spacingY + size.y;
    super.components.add(new Button(new PVector(posX, posY), size, "Instructions", new IAction() {
      public void action() {
        // hides the difficulty selection screen (if open) and hides the title screen
        // shows the instruction screen
        titleScreen.setActive(false);
        difficultyScreen.setActive(false);
        instructionScreen.setActive(true);
      }
    }
    ));

    posY += spacingY + size.y;
    super.components.add(new Button(new PVector(posX, posY), size, "Exit", new IAction() {
      public void action() {
        exit();
      }
    }
    ));
  }

  void onRender() {
    background(backgroundColor);
  }
}