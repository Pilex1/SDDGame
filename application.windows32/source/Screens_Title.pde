int titleSize = 72;
float titleY = 70;
int headingSize = 48;
float headingY = 140;
float backY = 560;

color questionsBackground = color(30, 22, 64, 255);
color gameDisplayBackground = color(46, 70, 90);

class SplashScreen extends GUI {

  color backgroundColor;

  // displays splash screen for a certain amount of time, then transitions over to the title screen
  float displayTime;
  float transitionTime;

  int curTime;

  Label title;

  SplashScreen() {
    backgroundColor = color(53, 70, 92);

    displayTime = 2 * 60;
    transitionTime = 1 * 60;
    curTime = 0;

    title = new Label(new PVector(frameWidth/2, titleY), "Latin Pong");
    title.textSize = titleSize;
    title.textColor = color(195, 190, 222);

    Label info = new Label(new PVector(frameWidth/2, 250), "Pong with twice the fun!");

    Label name = new Label(new PVector(frameWidth/2, 400), "Alex Tan");
    name.textSize = headingSize;

    Label classInfo = new Label(new PVector(frameWidth/2, 500), "11SDD3");
    classInfo.textSize = headingSize;

    components.add(title);
    components.add(info);
    components.add(name);
    components.add(classInfo);
  }

  void onRender() {
    if (curTime < displayTime) {
      background(backgroundColor);
    } else if (curTime < displayTime + transitionTime) {
      // transition the background color
      float offset = 5;
      float factor = (float)(curTime - displayTime-offset)/(transitionTime-offset);
      color c = lerpColor(backgroundColor, game.backgroundColor, factor);
      background(c);
    }
  }

  void onUpdate() {

    if (curTime < displayTime) {
      // splash screen display for 4 seconds
      setActive(true);
    } else if (curTime < displayTime + transitionTime) {     
      // moves all the labels leftwards
      float movement = frameWidth / transitionTime;
      for (GraphicsComponent g : components) {
        if (g == title) {
          continue;
        }
        g.pos.x -= movement;
      }
    } else {
      setActive(false);
      titleScreen.setActive(true);
    }

    curTime++;
  }
}



class TitleScreen extends GUI {

  TitleScreen() {
    super();

    // size of each button
    PVector size = new PVector(frameWidth/2, 80);
    // vertical spacing between each button
    int spacingY = 30;

    float posX = frameWidth/2-size.x/2;
    float posY = 200;

    Label title = new Label(new PVector(frameWidth/2, titleY), "Latin Pong");
    title.textSize = titleSize;
    title.textColor = color(195, 190, 222);
    components.add(title);
    
    Label info = new Label(new PVector(frameWidth/2, posY), "Pong with twice the fun!");
    components.add(info);

    posY += spacingY + size.y;
    components.add(new Button(new PVector(posX, posY), size, "Play", new IAction() {
      public void action() {
        // show the difficulty selection screen and set game option to Multiplayer
        difficultyScreen.setActive(true);
        setActive(false);
      }
    }
    ));

    posY += spacingY + size.y;
    components.add(new Button(new PVector(posX, posY), size, "Instructions", new IAction() {
      public void action() {
        // hides the title screen
        // shows the instruction screen
        titleScreen.setActive(false);
        instructionScreen.setActive(true);
      }
    }
    ));

    posY += spacingY + size.y;
    components.add(new Button(new PVector(posX, posY), size, "Exit", new IAction() {
      public void action() {
        exit();
      }
    }
    ));
  }

  void onRender() {
    background(game.backgroundColor);
  }
}



class DifficultyScreen extends GUI {

  Label lblPlayerMode;

  DifficultyScreen() {
    super(); 

    Label title = new Label(new PVector(frameWidth/2, titleY), "Latin Pong");
    title.textSize = titleSize;
    title.textColor = color(195, 190, 222);
    components.add(title);

    // size of each button
    PVector size = new PVector(frameWidth/2, 80);
    // vertical spacing between each button
    int spacingY = 30;

    float posX = frameWidth/2-size.x/2;
    float posY = 280;


    // displays "Select a difficulty"
    components.add(new Label(new PVector(posX + size.x / 2, posY-50), "Select a difficulty"));

    // Button for easy difficulty
    components.add(new Button(new PVector(posX, posY), size, "Easy", new IAction() {
      public void action() {
        game.gameOption = GameOption.Easy;
        game.launchGame();
      }
    }
    ));
    posY += size.y + spacingY;

    // Button for hard difficulty
    components.add(new Button(new PVector(posX, posY), size, "Hard", new IAction() {
      public void action() {
        game.gameOption = GameOption.Hard;
        game.launchGame();
      }
    }
    ));
    posY += size.y + spacingY;

    // Button for cancelling difficulty selection (hides the difficulty screen)
    components.add(new Button(new PVector(posX, posY), size, "Cancel", new IAction() {
      public void action() {
        setActive(false);
        titleScreen.setActive(true);
        game.gameOption = null;
      }
    }
    ));
  }

  void onRender() {
    background(game.backgroundColor);
  }
}


class InstructionScreen extends GUI {

  InstructionScreen() {

    Label title = new Label(new PVector(frameWidth/2, titleY), "Latin Pong");
    title.textSize = titleSize;
    title.textColor = color(195, 190, 222);
    components.add(title);

    // label that says Instructions in big font
    Label lbl = new Label(new PVector(frameWidth/2, headingY), "Instructions");  
    lbl.textSize = headingSize;
    components.add(lbl);

    // actual instructions contents
    float margin = 100;
    float y = 70;
    TextArea instructions = new TextArea("Two players battle in an epic game of Pong. Each player has a paddle which is used to reflect a moving ball. Over time, the size of the paddle shrinks, making it more and more difficulty to reflect the ball. Once the ball reaches the edge of the screen, the current round is considered over, and the losing player will lose one life. Each player starts with 3 lives, and when one player reaches 0 lives, then that player is considered the loser, and the other player wins.\n\nQuestions will regularly appear at the top of the screen, which consist of a Latin word and 4 possible English translations. Players must answer these questions correctly to increase their paddle size. However, answering a question incorrectly will incur a penalty. Furthermore, questions must also be answered within the specified time limit, otherwise this will be considered as answering incorrectly. For each question, a player may only answer once. ", 
      new PVector(margin, y), new PVector(frameWidth-2*margin, 560-y));
    instructions.textSize = 20;
    components.add(instructions);

    components.add(new Button(new PVector(frameWidth/4, backY - 110), new PVector(frameWidth/2, 80), "Controls", new IAction() {
      public void action() {
        instructionScreen.setActive(false);
        controlsScreen.setActive(true);
      }
    }
    ));

    // button to go back to title screen
    components.add(new Button(new PVector(frameWidth/4, backY), new PVector(frameWidth/2, 80), "Back", new IAction() {
      public void action() {
        instructionScreen.setActive(false);

        if (game.launched) {
          pausedOverlay.setActive(true);
          questionsScreen.setActive(true);
          gameDisplayScreen.setActive(true);
        } else {
          titleScreen.setActive(true);
        }
      }
    }
    ));
  }

  void onRender() {
    background(game.backgroundColor);
  }
}

class ControlsScreen extends GUI {

  ControlsScreen() {

    Label title = new Label(new PVector(frameWidth/2, titleY), "Latin Pong");
    title.textSize = titleSize;
    title.textColor = color(195, 190, 222);
    components.add(title);

    // label that says Instructions in big font
    Label lbl = new Label(new PVector(frameWidth/2, headingY), "Controls");  
    lbl.textSize = headingSize;
    components.add(lbl);

    float spacingY = 35;
    float headingSpacingY = 70;
    int subheadingSize = 32;
    int normalSize = 24;

    float y = headingY+70;
    components.add(new Label(new PVector(frameWidth/2, y), normalSize, "Esc - Pause game"));

    y += headingSpacingY;
    components.add(new Label(new PVector(frameWidth/2, y), subheadingSize, "Player 1"));
    y += spacingY;
    components.add(new Label(new PVector(frameWidth/2, y), normalSize, "W/S - Move paddle up/down"));
    y += spacingY;
    components.add(new Label(new PVector(frameWidth/2, y), normalSize, "1/2/3/4 - Select multiple choice answer"));

    y += headingSpacingY;
    components.add(new Label(new PVector(frameWidth/2, y), subheadingSize, "Player 2 (Multiplayer only)"));
    y += spacingY;
    components.add(new Label(new PVector(frameWidth/2, y), normalSize, "I/K - Move paddle up/down"));
    y += spacingY;
    components.add(new Label(new PVector(frameWidth/2, y), normalSize, "1/2/3/4 - Select multiple choice answer"));

    // button to go back to the instructions screen
    components.add(new Button(new PVector(frameWidth/4, backY), new PVector(frameWidth/2, 80), "Back", new IAction() {
      public void action() {
        controlsScreen.setActive(false);
        instructionScreen.setActive(true);
      }
    }
    ));
  }

  void onRender() {
    background(game.backgroundColor);
  }
}