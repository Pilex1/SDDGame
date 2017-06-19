class GameDisplayScreen extends GUI {
  
  Label lblLives;
  Label lblTime;

  GameDisplayScreen() {
    lblLives = new Label(new PVector(0,0), "Lives");
    components.add(lblLives);
  }

  void onRender() {
    
    int timeY = 45;

    // display the amount of time left as a rectangle
    
    color full = color(0, 255, 80);
    color empty = color(255, 0, 20);
    
    float ratio = (float)questionsScreen.elapsedQuestionTime/questionsScreen.questionTime;
    if (ratio <=1) {
    fill(lerpColor(full, empty, ratio));
    rect(frameWidth*ratio/2, game.displayOffset, frameWidth*(1-ratio), timeY);
    }

   
   // displays players lives
   
    fill(gameDisplayBackground);
    float curY = game.displayOffset+timeY+10;
    rect(0, curY, frameWidth, game.heightOffset-curY);
    
    lblLives.pos.x = frameWidth/2;
    lblLives.pos.y = curY+15;
    
     color heartColor = color(255, 20, 40);
    fill(heartColor);
    noStroke();

    int offset = 20;

    int heartWidth = 30;
    int heartHeight = 30;

    int spacing = 15;

    float yPos = curY + 5;

    // display Player 1's lives
    int x = offset;
    for (int i = 0; i < game.player1.curLives; i++) {
      rect(x, yPos, heartWidth, heartHeight);
      x += spacing + heartWidth;
    }

    // display Player 2's lives
    x = frameWidth - offset;
    for (int i = 0; i < game.player2.curLives; i++) {
      rect(x, yPos, - heartWidth, heartHeight);
      x -= spacing + heartWidth;
    }

  }
  

  
  
}



// displays when the game ends and someone has won/lost
class DeathOverlay extends GUI {

  Label description;

  DeathOverlay() {
    
    Label gameOver = new Label(new PVector(frameWidth/2, headingY), "Game Over");
    gameOver.textSize = headingSize;
    components.add(gameOver);
    
    description = new Label(new PVector(frameWidth/2, headingY + 300), "");
    components.add(description);

    // size of each button
    PVector size = new PVector(frameWidth/2, 80);

    components.add(new Button(new PVector(frameWidth/4, backY), size, "Exit", new IAction() {
      public void action() {
        deathOverlay.setActive(false);
        pausedOverlay.setActive(false);
        questionsScreen.setActive(false);
        gameDisplayScreen.setActive(false);
        titleScreen.setActive(true);
        game.reset();
      }
    }
    ));
  }

  void onRender() {
    fill(48, 48, 48, 240);
    rect(0, 0, frameWidth, frameHeight);
  }
}

// displays when the user presses the ESC key whilst in game
// pauses the game and brings up a menu for viewing instructions, or going back to the main menu
class PausedOverlay extends GUI {

  PausedOverlay() {
    Label lbl = new Label(new PVector(frameWidth/2, headingY), "Paused");  
    lbl.textSize = headingSize;
    components.add(lbl);

    // size of each button
    PVector size = new PVector(frameWidth/2, 80);
    // vertical spacing between each button
    int spacingY = 30;

    float posX = frameWidth/2-size.x/2;
    float posY = 280;

    components.add(new Button(new PVector(posX, posY), size, "Return to game", new IAction() {
      public void action() {
        game.toggleState();
      }
    }
    ));
    posY += size.y + spacingY;

    // Button for hard difficulty
    components.add(new Button(new PVector(posX, posY), size, "Instructions", new IAction() {
      public void action() {
        questionsScreen.setActive(false);
        gameDisplayScreen.setActive(false);
        pausedOverlay.setActive(false);
        instructionScreen.setActive(true);
      }
    }
    ));
    posY += size.y + spacingY;

    // Button for cancelling difficulty selection (hides the difficulty screen)
    components.add(new Button(new PVector(posX, posY), size, "Quit", new IAction() {
      public void action() {
        pausedOverlay.setActive(false);
        questionsScreen.setActive(false);
        gameDisplayScreen.setActive(false);
        titleScreen.setActive(true);
        game.reset();
      }
    }
    ));
  }

  void onRender() {
    fill(48, 48, 48, 240);
    rect(0, 0, frameWidth, frameHeight);
  }
}