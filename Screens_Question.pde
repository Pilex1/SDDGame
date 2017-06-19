// in game screen that displays the question and 4 multiple choice answers
class QuestionsScreen extends GUI {

  // amount of time given for each question - if the time limit is exceeded before the question is answered, then we move on to the next question and both players are penalised
  int questionTime = 8 * 60;
  int elapsedQuestionTime;

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
    waitTime = 20;

    question = new Label(new PVector(frameWidth/2, 30), "");

    int incrX = frameWidth/4;
    int yPos = 70;
    int curX = 0;

    answerA = new AnswerLabel(new PVector(curX, yPos), new PVector(incrX, yPos), "A");
    curX += incrX;

    answerB = new AnswerLabel(new PVector(curX, yPos), new PVector(incrX, yPos), "B");
    curX += incrX;

    answerC = new AnswerLabel(new PVector(curX, yPos), new PVector(incrX, yPos), "C");
    curX += incrX;

    answerD = new AnswerLabel(new PVector(curX, yPos), new PVector(incrX, yPos), "D");

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
    QuestionBank bank = game.gameOption == GameOption.Easy ? game.questionsEasy : game.questionsHard;
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
      
      elapsedQuestionTime = 0;

      curCooldown--;
    } else {
      setActive(true); 

      elapsedQuestionTime++;

      if (elapsedQuestionTime>questionTime) {
        // time limit reached, both players incur a penalty
        if (!game.player1.answered) {
          game.player1.paddle.decreaseSize();
        }
        if (!game.player2.answered) {
          game.player2.paddle.decreaseSize();
        }
        nextQuestion();
      } else {

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
  }

  void onRender() {
    // fill(questionsBackground);
    //strokeWeight(0);
    /// rect(0, 0, frameWidth, game.displayOffset);
  }
}