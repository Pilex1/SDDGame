int titleSize = 72;
float titleY = 70;
int headingSize = 48;
float headingY = 140;
float backY = 560;

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

    components.add(new Button(new PVector(posX, posY), size, "Singleplayer", new IAction() {
      public void action() {
        // show the difficulty selection screen and set game option to Singleplayer
        difficultyScreen.setActive(true);
        setActive(false);
        difficultyScreen.lblPlayerMode.text = "Singleplayer";
        game.gameOption.playerOption = PlayerOption.Singleplayer;
      }
    }
    ));

    posY += spacingY + size.y;
    components.add(new Button(new PVector(posX, posY), size, "Multiplayer", new IAction() {
      public void action() {
        // show the difficulty selection screen and set game option to Multiplayer
        difficultyScreen.setActive(true);
        setActive(false);
        difficultyScreen.lblPlayerMode.text = "Multiplayer";
        game.gameOption.playerOption = PlayerOption.Multiplayer;
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

    // displays the player mode i.e. Singleplayer or multiplayer
    lblPlayerMode = new Label(new PVector(posX + size.x / 2, headingY), "");
    lblPlayerMode.textSize = headingSize;
    components.add(lblPlayerMode);

    // displays "Select a difficulty"
    components.add(new Label(new PVector(posX + size.x / 2, posY-50), "Select a difficulty"));

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
        setActive(false);
        titleScreen.setActive(true);
        game.gameOption.playerOption = null;
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
    TextArea instructions = new TextArea("Two players battle in an epic game of Pong. Each player has two paddles which are used to reflect a moving ball. Over time, the size of the paddle shrinks, making it more and more difficulty to reflect the ball. Once the ball reaches the edge of the screen, the current round is considered over, and the losing player will lose one life. Each player starts with 3 lives, and when one player reaches 0 lives, then that player is considered the loser, and the other player wins.\n\nQuestions will regularly appear at the top of the screen, which consist of a Latin word and 4 possible English translations. Players must answer these questions correctly to increase their paddle size. However, answering a question incorrectly will incur a penalty. Furthermore, questions must also be answered within the specified time limit, otherwise this will be considered as answering incorrectly. For each question, a player may only answer once. ", 
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

    float spacingY = 30;
    float headingSpacingY = 50;
    int subheadingSize = 38;

    float y = headingY;
    Label lblUniversal = new Label(new PVector(frameWidth/2, y), "Universal"); 
    lblUniversal.textSize = subheadingSize;
    components.add(lblUniversal);
    y += spacingY;
    components.add(new Label(new PVector(frameWidth/2, y), "Esc - Pause game"));

    y += headingSpacingY;
    Label lblPlayer1 = new Label(new PVector(frameWidth/2, y), "Player 1");
    components.add(lblPlayer1);
    y += spacingY;
    components.add(new Label(new PVector(frameWidth/2, y), "W/S - Move paddle up/down"));
    y += spacingY;
    components.add(new Label(new PVector(frameWidth/2, y), "1/2/3/4 - Select multiple choice answer"));

    y += headingSpacingY;
    Label lblPlayer2 = new Label(new PVector(frameWidth/2, y), "Player 2 (Multiplayer only)");
    components.add(lblPlayer2);
    y += spacingY;
    components.add(new Label(new PVector(frameWidth/2, y), "I/K - Move paddle up/down"));
    y += spacingY;
    components.add(new Label(new PVector(frameWidth/2, y), "1/2/3/4 - Select multiple choice answer"));

    // button to go back to the instructions screen
    components.add(new Button(new PVector(frameWidth/4, backY), new PVector(frameWidth/2, 80), "Back", new IAction() {
      public void action() {
        controlsScreen.setActive(false);
        instructionScreen.setActive(true);
      }
    }
    ));
  }
}

// in game screen that displays the question and 4 multiple choice answers
class QuestionsScreen extends GUI {

  // after a question is answered, the questions get faded out for this amount of time
  int fadeTime;
  // after the questions are faded out, the questions screen remains black for this amount of time, before a new question gets released
  int waitTime;

  int curCooldown;

  // label for the question
  Label question;

  // labels for displaying the four possible answers
  AnswerLabel answerA;
  AnswerLabel answerB;
  AnswerLabel answerC;
  AnswerLabel answerD;

  // should point to either answerA, answerB, answerC or answerD
  // not actually rendered to the screen
  // just used to keep track of which label contains the correct answer
  AnswerLabel correctAnswer;

  QuestionsScreen() {

    fadeTime = 40;
    waitTime = 50;

    question = new Label(new PVector(frameWidth/2, 50), "Question");

    int incrX = frameWidth/4;
    int yPos = 100;
    int curX = 0;

    answerA = new AnswerLabel(new PVector(curX, yPos), new PVector(incrX, 100), "A");
    curX += incrX;

    answerB = new AnswerLabel(new PVector(curX, yPos), new PVector(incrX, 100), "B");
    curX += incrX;

    answerC = new AnswerLabel(new PVector(curX, yPos), new PVector(incrX, 100), "C");
    curX += incrX;

    answerD = new AnswerLabel(new PVector(curX, yPos), new PVector(incrX, 100), "D");

    components.add(question);
    components.add(answerA);
    components.add(answerB);
    components.add(answerC);
    components.add(answerD);
  }

  void reset() {
    answerA.status = AnswerStatus.None;
    answerB.status = AnswerStatus.None;
    answerC.status = AnswerStatus.None;
    answerD.status = AnswerStatus.None;
    curCooldown = 1;
  }

  void nextQuestion() {
    curCooldown = fadeTime + waitTime;
  }

  // generates a new question and updates the display accordingly
  void generateQuestion() {

    assert question != null;
    assert answerA != null;
    assert answerB != null;
    assert answerC != null;
    assert answerD != null;
    QuestionBank bank = game.gameOption.difficulty == DifficultyOption.Easy ? game.questionsEasy : game.questionsHard;
    assert bank != null;

    QuestionAnswerChoice choice = bank.generate();
    question.text = choice.question;

    answerA.text = choice.answerA;
    answerB.text = choice.answerB;
    answerC.text = choice.answerC;
    answerD.text = choice.answerD;

    if (answerA.text == choice.correctAnswer) {
      correctAnswer = answerA;
    } else if (answerB.text == choice.correctAnswer) {
      correctAnswer = answerB;
    } else if (answerC.text == choice.correctAnswer) {
      correctAnswer = answerC;
    } else if (answerD.text == choice.correctAnswer) {
      correctAnswer = answerD;
    } else {
      // one of the answers should be the correct answer
      assert false;
    }
  }

  void onUpdate() {

    if (game.paused) return;

    if (curCooldown > waitTime) {
      // fading out
      setActive(true);

      curCooldown--;
    } else if (curCooldown > 1) {
      // empty questions, blank screen, waiting
      setComponentsActive(false);

      curCooldown--;
    } else if (curCooldown == 1) {
      // load new questions
      generateQuestion();
      setComponentsActive(true);
      answerA.setStatus(AnswerStatus.None);
      answerB.setStatus(AnswerStatus.None);
      answerC.setStatus(AnswerStatus.None);
      answerD.setStatus(AnswerStatus.None);

      game.player1.setAnswered(false);
      game.player2.setAnswered(false);

      curCooldown--;
    } else {
      setActive(true); 

      // player 1
      if (!game.player1.answered) {
        if (keys['1'] && answerA.status != AnswerStatus.Incorrect) {
          if (correctAnswer == answerA) {
            answerA.setStatus(AnswerStatus.Correct);
            game.player1.paddle.increaseSize();
          } else {
            answerA.setStatus(AnswerStatus.Incorrect);
            game.player1.paddle.decreaseSize();
          }
          game.player1.setAnswered(true);
        }
        if (keys['2'] && answerB.status != AnswerStatus.Incorrect) {
          if (correctAnswer == answerB) {
            answerB.setStatus(AnswerStatus.Correct);
            game.player1.paddle.increaseSize();
          } else {
            answerB.setStatus(AnswerStatus.Incorrect);
            game.player1.paddle.decreaseSize();
          }
          game.player1.setAnswered(true);
        }
        if (keys['3'] && answerC.status != AnswerStatus.Incorrect) {
          if (correctAnswer == answerC) {
            answerC.setStatus(AnswerStatus.Correct);
            game.player1.paddle.increaseSize();
          } else {
            answerC.setStatus(AnswerStatus.Incorrect);
            game.player1.paddle.decreaseSize();
          }
          game.player1.setAnswered(true);
        }
        if (keys['4'] && answerD.status != AnswerStatus.Incorrect) {
          if (correctAnswer == answerD) {
            answerD.setStatus(AnswerStatus.Correct);
            game.player1.paddle.increaseSize();
          } else {
            answerD.setStatus(AnswerStatus.Incorrect);
            game.player1.paddle.decreaseSize();
          }
          game.player1.setAnswered(true);
        }
      }


      // player 2
      if (!game.player2.answered) {
        if (keys['7'] && answerA.status != AnswerStatus.Incorrect) {
          if (correctAnswer == answerA) {
            answerA.setStatus(AnswerStatus.Correct);
            game.player2.paddle.increaseSize();
          } else {
            answerA.setStatus(AnswerStatus.Incorrect);
            game.player2.paddle.decreaseSize();
          }
          game.player2.setAnswered(true);
        }
        if (keys['8'] && answerB.status != AnswerStatus.Incorrect) {
          if (correctAnswer == answerB) {
            answerB.setStatus(AnswerStatus.Correct);
            game.player2.paddle.increaseSize();
          } else {
            answerB.setStatus(AnswerStatus.Incorrect);
            game.player2.paddle.decreaseSize();
          }
          game.player2.setAnswered(true);
        }
        if (keys['9'] && answerC.status != AnswerStatus.Incorrect) {
          if (correctAnswer == answerC) {
            answerC.setStatus(AnswerStatus.Correct);
            game.player2.paddle.increaseSize();
          } else {
            answerC.setStatus(AnswerStatus.Incorrect);
            game.player2.paddle.decreaseSize();
          }
          game.player2.setAnswered(true);
        }
        if (keys['0'] && answerD.status != AnswerStatus.Incorrect) {
          if (correctAnswer == answerD) {
            answerD.setStatus(AnswerStatus.Correct);
            game.player2.paddle.increaseSize();
          } else {
            answerD.setStatus(AnswerStatus.Incorrect);
            game.player2.paddle.decreaseSize();
          }
          game.player2.setAnswered(true);
        }
      }

      if (answerA.status == AnswerStatus.Correct || answerB.status == AnswerStatus.Correct || answerC.status == AnswerStatus.Correct || answerD.status == AnswerStatus.Correct) {
        nextQuestion();
      }
      if (game.player1.answered == true && game.player2.answered == true) {
        nextQuestion();
      }
    }
  }

  void onRender() {
    fill(0, 0, 0);
    strokeWeight(0);
    rect(0, 0, frameWidth, game.heightOffset);
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