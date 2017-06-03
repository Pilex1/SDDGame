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
    
    fadeTime = 100;
    waitTime = 200;
    
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

  void nextQuestion() {
    curCooldown = fadeTime + waitTime;
  }

  void generateQuestion() {

    assert question != null;

    assert answerA != null;
    assert answerB != null;
    assert answerC != null;
    assert answerD != null;

    QuestionBank bank = game.gameOption.difficulty == DifficultyOption.Easy ? game.questionsEasy : game.questionsHard;
    assert bank != null;

    int numQuestions = bank.questions.size();

    // generates a random question from the question bank
    int correctID = int(random(numQuestions));
    LatinEnglishPair pair = bank.questions.get(correctID);
    String latinQuestion = pair.latin;
    question.text = latinQuestion;
    String englishAnswer = pair.englishTranslations[int(random(pair.englishTranslations.length))];


    // IDs of the questions already used, so as to avoid duplicates
    int[] used = new int[] {-1, -1, -1, -1};
    // four possible multiple choice answers
    String[] answers = new String[4];

    // correct answer stored in index 0
    answers[0] = englishAnswer;
    used[0] = correctID;



    for (int i = 0; i < 3; i++) {
      // find a random question that has not already been used for incorrect answers
      int questionID = genRandomExcluding(numQuestions, used);

      // add the questionID to the used array
      used[i+1] = questionID;

      LatinEnglishPair incorrectPair = bank.questions.get(questionID);

      String incorrectAnswer = incorrectPair.englishTranslations[int(random(incorrectPair.englishTranslations.length))];

      // store the incorrect answers;
      answers[i+1] = incorrectAnswer;
    }

    // shuffle the answers
    durstenfeldShuffle(answers);


    answerA.text = answers[0];
    answerB.text = answers[1];
    answerC.text = answers[2];
    answerD.text = answers[3];

    if (answers[0] == englishAnswer) {
      correctAnswer = answerA;
    } else if (answers[1] == englishAnswer) {
      correctAnswer = answerB;
    } else if (answers[2] == englishAnswer) {
      correctAnswer = answerC;
    } else if (answers[3] == englishAnswer) {
      correctAnswer = answerD;
    } else {
      // one of the answers should be the correct answer
      assert false;
    }
    assert correctAnswer != null;
  }

  // shuffles the array using the Durstenfeld algorithm
  void durstenfeldShuffle(String[] arr) {
    Random rnd = new Random();
    for (int i = arr.length - 1; i > 0; i--) {
      int index = rnd.nextInt(i + 1);

      String a = arr[index];
      arr[index] = arr[i];
      arr[i] = a;
    }
  }

  // returns if arr contains x
  boolean contains(int[] arr, int x) {
    for (int i = 0; i < arr.length; i++) {
      if (arr[i] == x) {
        return true;
      }
    }
    return false;
  }

  // generates a random integer from 0 to n (exclusive), excluding those in int[] excluding
  int genRandomExcluding(int n, int[] excluding) {
    int result = 0;
    boolean flag = true;
    while (flag) {
      result = int(random(n));
      if (!contains(excluding, result)) break;
    }
    return result;
  }

  void onUpdate() {
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
      answerA.setNone();
      answerB.setNone();
      answerC.setNone();
      answerD.setNone();
      
      curCooldown--;
    } else {
      setActive(true);      

      // player 1
      if (keys['1']) {
        if (correctAnswer == answerA) {
          answerA.setCorrect();
          nextQuestion();
        } else {
          answerA.setIncorrect();
        }
      }
      if (keys['2']) {
        if (correctAnswer == answerB) {
          answerB.setCorrect();
          nextQuestion();
        } else {
          answerB.setIncorrect();
        }
      }
      if (keys['3']) {
        if (correctAnswer == answerC) {
          answerC.setCorrect();
          nextQuestion();
        } else {
          answerC.setIncorrect();
        }
      }
      if (keys['4']) {
        if (correctAnswer == answerD) {
          answerD.setCorrect();
          nextQuestion();
        } else {
          answerD.setIncorrect();
        }
      }

      // player 2
      if (keys['7']) {
        if (correctAnswer == answerA) {
          answerA.setCorrect();
          nextQuestion();
        } else {
          answerA.setIncorrect();
        }
      }
      if (keys['8']) {
        if (correctAnswer == answerB) {
         answerB.setCorrect();
         nextQuestion();
        } else {
          answerB.setIncorrect();
        }
      }
      if (keys['9']) {
        if (correctAnswer == answerC) {
         answerC.setCorrect();
         nextQuestion();
        } else {
          answerC.setIncorrect();
        }
      }
      if (keys['0']) {
        if (correctAnswer == answerD) {
         answerD.setCorrect();
         nextQuestion();
        } else {
          answerD.setIncorrect();
        }
      }
    }
  }

  void onRender() {
    fill(0, 0, 0);
    strokeWeight(0);
    rect(0, 0, frameWidth, game.heightOffset);
  }
}