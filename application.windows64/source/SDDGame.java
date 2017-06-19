import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class SDDGame extends PApplet {

final int frameWidth = 1280;
final int frameHeight = 720;

ArrayList<GUI> guis;
TitleScreen titleScreen;
DifficultyScreen difficultyScreen;
InstructionScreen instructionScreen;
ControlsScreen controlsScreen;
QuestionsScreen questionsScreen;
GameDisplayScreen gameDisplayScreen;
SplashScreen splashScreen;
PausedOverlay pausedOverlay;
DeathOverlay deathOverlay;
Game game;

Label copyright;

// storing if the respective keys are pressed
boolean keys[];
boolean keyEscape;

public void settings() {
  size(frameWidth, frameHeight);
}

public void setup() {
  guis = new ArrayList<GUI>();

  game = new Game();
  guis.add(game);

  titleScreen = new TitleScreen();
  difficultyScreen = new DifficultyScreen();
  instructionScreen = new InstructionScreen();
  controlsScreen = new ControlsScreen();
  questionsScreen = new QuestionsScreen();
  gameDisplayScreen = new GameDisplayScreen();
  splashScreen = new SplashScreen();
  splashScreen.setActive(true);
  pausedOverlay = new PausedOverlay();
  deathOverlay = new DeathOverlay();

  guis.add(splashScreen);
  guis.add(titleScreen);
  guis.add(difficultyScreen);
  guis.add(instructionScreen);
  guis.add(controlsScreen);
  guis.add(questionsScreen);
  guis.add(gameDisplayScreen);
  guis.add(pausedOverlay);
  guis.add(deathOverlay);

  copyright = new Label(new PVector(frameWidth, frameHeight), new PVector(0, 0), "Copyright Alex Tan 2017");
  copyright.textSize = 24;
  copyright.hAlign = RIGHT;
  copyright.vAlign = BOTTOM;

  keys = new boolean[255];
}

public void draw() {

  if (frameCount % 60 == 1) {
    surface.setTitle("Latin Pong - Copyright Alex Tan 2017 | FPS: " + PApplet.parseInt(frameRate));
  }

  background(0, 0, 0);
  for (GUI gui : guis) {
    gui.update();
  }

  for (GUI gui : guis) {
    gui.render();
  }

  if (!game.launched) {
    copyright.onRender();
  }
}

public void keyPressed() {
  if (key >= 0 && key <= 255) {
    keys[key] = true;
  }
  if (keyCode == ESC) {
    keyEscape = true;
    key = 0;
  }
}

public void keyReleased() {
  if (key >= 0 && key <= 255) {
    keys[key] = false;
  }
  if (keyCode == ESC) {
    keyEscape = false;
  }
}
class Ball extends GraphicsComponent {
  
  // initial starting position of the ball
  // when a player loses, the ball also gets reset to this position
  PVector startingPos;

  // initial starting angle range for the ball
  // when a player loses, the ball's angle gets set a number between this range
  float thetaMin;
  float thetaMax;
  // angle that the ball is facing in radians
  float theta;

  // speed of the ball
  // should remain constant
  float speed;

  int ballColor;

  // diameter of the ball
  float size;

  // determines if the ball is past the bounds of the game, in which case one of the players have lost
  boolean outOfBounds;

  Ball(PVector pos) {
    super(pos);
    startingPos = new PVector(pos.x, pos.y);
    speed = 5;

    thetaMin = -PI/8;
    thetaMax = PI/8;

    ballColor = color(191, 99, 99);
    size = 32;
    active = true;
    outOfBounds = false;

    resetBall();
  }

  public void resetBall() {
    pos.x = startingPos.x;
    pos.y = startingPos.y;

    theta = random(thetaMin, thetaMax);
    
    if (random(1) < 0.5f) {
     theta += PI; 
    }

    outOfBounds = false;
  }

  public void onUpdate() {

    if (game.paused) return;

    // for debugging purposes
    /*float v = 5;
    if (keys['f']) {
      pos.x -= v;
    }
    if (keys['h']) {
      pos.x += v;
    }
    if (keys['t']) {
      pos.y -= v;
    }
    if (keys['g']) {
      pos.y += v;
    }

    if (keys['b']) {
      speed = 0;
    }*/
    // end debugging code



    // default position updating
    pos.x += speed * cos(theta);
    pos.y += speed * sin(theta);

    // collision with top wall
    // bounce the ball
    if (pos.y - size/2 < game.heightOffset) {
      theta = -1 * theta + 2 * PI;
      while (pos.y - size/2 < game.heightOffset) {
        pos.x += speed * cos(theta);
        pos.y += speed * sin(theta);
      }
      
      speed += 0.1f;
    }

    // collision with bottom wall
    // bounce the ball
    if (pos.y + size/2 > frameHeight) {
      theta = -1 * theta + 2 * PI;
      while (pos.y + size/2 > frameHeight) {
        pos.x += speed * cos(theta);
        pos.y += speed * sin(theta);
      }
    }


    Paddle paddle1 = game.player1.paddle;
    Paddle paddle2 = game.player2.paddle;
    
    float maxAngle = PI/4;

    if (outOfBounds) {
      if (pos.x+size/2 < 0) {
        game.player1.die();
      }
      if (pos.x-size/2 >= frameWidth) {
        game.player2.die();
      }
    } else {
      // collision with player 1 paddle (on the left of the screen)
      // bounce the ball
      if (pos.x - size/2 <= paddle1.pos.x + paddle1.size.x/2) {
        if (pos.y + size/2 >= paddle1.pos.y - paddle1.size.y/2 && pos.y - size/2 <= paddle1.pos.y + paddle1.size.y/2) {

          // calculating angle trajectory on rebound
          float ry = pos.y - paddle1.pos.y;

          float rebound = ry / paddle1.size.y;
          //assert(abs(rebound)<=1);
          rebound *= 0.2f;

          theta = rebound;
          if (theta < -maxAngle) {
           theta = maxAngle; 
          }
          if (theta > maxAngle) {
           theta = maxAngle; 
          }
          
          
          pos.x = paddle1.pos.x + paddle1.size.x/2 + size/2;

          /*while (pos.x - size/2 <= paddle1.pos.x + paddle1.size.x/2) {
            pos.x += speed * cos(theta);
            pos.y += speed * sin(theta);
          }*/
        } else {
          // ball has gone out of bounds
          outOfBounds = true;
        }
      }

      // collision with player 2 paddle (on the right of the screen)
      // bounce the ball
      if (pos.x + size/2 >= paddle2.pos.x - paddle2.size.x/2) {
        if (pos.y + size/2 >= paddle2.pos.y - paddle2.size.y/2 && pos.y - size/2 <= paddle2.pos.y + paddle2.size.y/2) {

          // calculating angle trajectory on rebound
          float ry = pos.y - paddle1.pos.y;

          float rebound = ry / paddle1.size.y;
          //assert(abs(rebound)<=1);
          rebound *= -0.3f;

          theta = rebound;
          if (theta < -maxAngle) {
           theta = -maxAngle; 
          }
          if (theta > maxAngle) {
           theta = maxAngle; 
          }
          
          theta+=PI;
          
          pos.x = paddle2.pos.x - paddle2.size.x/2 - size/2;

          /*while (pos.x + size/2 >= paddle2.pos.x - paddle2.size.x/2) {
            pos.x += speed * cos(theta);
            pos.y += speed * sin(theta);
          }*/
        } else {
          // ball has gone out of bounds
          outOfBounds = true;
        }
      }
    }
  }

  public void onRender() {
    fill(ballColor);
    strokeWeight(0);
    ellipse(pos.x, pos.y, size, size);
  }
}
// represents a screen/display on which GraphicsComponents can be added
abstract class GUI {

  boolean active;
  ArrayList<GraphicsComponent> components;

  GUI() {
    active = false;
    components = new ArrayList<GraphicsComponent>();
  }

  // can be overriden in sub-classes for additional functionality when the GUI is set active
  public void onSetActive() {
  }
  // can be overriden in sub-classes for additional functionality when the GUI is set inactive
  public void onSetInactive() {
  }
  public final void setComponentsActive(boolean active) {
    for (GraphicsComponent b : components) {
      assert b != null;
      b.active = active;
    }
  }
  public final void setActive(boolean active) {
    this.active = active;

    setComponentsActive(active);

    // reset button cooldowns i.e. prevent the user from clicking a button immediately after entering a new screen
    resetButtonCooldowns();

    if (active) {
      onSetActive();
    } else {
      onSetInactive();
    }
  }

  // can be overriden in sub-classes for additional functionality when the GUI is updating
  public void onUpdate() {
  }
  // by default, everything in the components list is updated
  public final void update() {
    if (!active) return;
    onUpdate();
    for (GraphicsComponent b : components) {
      assert b != null;
      b.update();
    }
  }

  // can be overriden in sub-classes for additional functionality when the GUI is rendering e.g. change the background color
  public void onRender() {
  }
  // by default, the GUI renders everything in the components list
  public final void render() {    
    if (!active) return;
    onRender();
    for (GraphicsComponent b : components) {   
      assert b != null;
      b.render();
    }
  }

  public void resetButtonCooldowns() {
    for (GraphicsComponent g : components) {
      if (g instanceof Button) {
        ((Button)g).resetCooldown();
      }
    }
  }
}

// all graphical elements extend this class
abstract class GraphicsComponent {

  PVector pos;
  boolean active;

  GraphicsComponent(PVector pos) {
    this.pos = pos;
    active = false;
  }

  public abstract void onUpdate();
  public void update() {
    if (!active) return;
    onUpdate();
  }

  public abstract void onRender();
  public void render() {
    if (!active) return;
    onRender();
  }
}

interface IAction {
  public void action();
}

class Button extends GraphicsComponent {

  PVector size;

  int backgroundColor;
  int backgroundHoverColor;
  int textColor;

  PFont font;
  String text;

  IAction onPress;
  IAction onHover;

  boolean hoveredOver;
  boolean active;

  // cooldown time before the button can be pressed again
  int cooldown;
  // if curCooldown == 0, then the button can be pressed again - positive numbers indicate cooldown time remaining
  int curCooldown;

  Button(PVector pos, PVector size, String text, IAction onAction) {
    super(pos);
    this.size = size;

    backgroundColor = color(75, 45, 143);
    backgroundHoverColor = color(119, 90, 186);
    textColor = color(255, 255, 255);

    font = createFont("Calibri", 32);
    this.text = text;

    this.onPress = onAction; 
    onHover = new IAction() {
      public void action() {
      }
    };

    hoveredOver = false;
    active = false;

    cooldown = 15;
    curCooldown = 0;
  }

  public void onRender() {
    noStroke();
    fill(hoveredOver ? backgroundHoverColor : backgroundColor);
    rect(pos.x, pos.y, size.x, size.y);

    textFont(font);
    textAlign(CENTER, CENTER);
    fill(textColor);
    PVector textPos = new PVector(pos.x + size.x / 2, pos.y + size.y / 2);
    text(this.text, textPos.x, textPos.y);
  }

  public void resetCooldown() {
    curCooldown = cooldown;
  }

  public void onUpdate() {

    if (curCooldown > 0) {
      curCooldown--;
    }

    hoveredOver = (mouseX >= pos.x && mouseX <= pos.x + size.x && mouseY >= pos.y && mouseY <= pos.y + size.y);

    if (curCooldown > 0) return;

    if (hoveredOver) {
      onHover.action();
      if (mousePressed) {
        onPress.action();
      }
    }
  }
}



class Label extends GraphicsComponent {

  int backgroundColor;
  // size of the label rectangle
  PVector size;

  PFont font;
  int textSize;
  int textColor;

  String text;

  int hAlign;
  int vAlign;
  
  Label(PVector pos, int textSize, String text) {
   super(pos);
   backgroundColor = color(0, 0, 0, 0);
    this.size = new PVector(0, 0);
    font = createFont("Calibri", 1);
    this.textSize = textSize;
    this.text = text;
    textColor = color(255, 255, 255);
    hAlign = CENTER;
    vAlign = CENTER;
  }
  
  Label(PVector pos, String text) {
    this(pos, new PVector(0, 0), text);
  }

  Label(PVector pos, PVector size, String text) {
    super(pos);
    this.size = size;
    font = createFont("Calibri", 1);
    textSize = 32;
    this.text = text;
    textColor = color(255, 255, 255);
    hAlign = CENTER;
    vAlign = CENTER;
  }

  public void onUpdate() {
  }

  public void onRender() {
    fill(backgroundColor);
    //rect(pos.x-size.x/2, pos.y-size.y/2, size.x, size.y);
    noStroke();
    textAlign(hAlign, vAlign);
    fill(textColor);
    textFont(font);
    textSize(textSize);
    text(text, pos.x + size.x/2, pos.y + size.y/2);
  }
}

class AnswerLabel extends Label {

  float borderWidth;

  int borderCorrectColor;
  int borderIncorrectColor;

  AnswerStatus status;

  AnswerLabel(PVector pos, PVector size, String text) {
    super(pos, size, text);

    status = AnswerStatus.None;

    borderCorrectColor = color(0, 255, 80);
    borderIncorrectColor = color(255, 0, 20);

    borderWidth = 4;
  }

  public void setStatus(AnswerStatus status) {
    this.status = status;
  }

  public void onRender() {
    if (status == AnswerStatus.None) {
    noStroke();
    } else if (status == AnswerStatus.Correct) {
      stroke(borderCorrectColor);
    } else if (status == AnswerStatus.Incorrect) {
      stroke(borderIncorrectColor);
    } else {
      assert false;
    }
    strokeWeight(borderWidth);
    fill(39, 59, 62);
    rect(pos.x + borderWidth, pos.y + borderWidth, size.x - borderWidth*2, size.y - borderWidth*2);
    
      super.onRender(); 
  }
}

enum AnswerStatus {
  None, Correct, Incorrect
}


// multi line label
class TextArea extends GraphicsComponent {

  String text;
  PFont font;
  int textSize;
  int textColor;

  PVector pos;
  PVector size;

  TextArea(String text, PVector pos, PVector size) {
    super(pos);
    this.text = text;
    font = createFont("Calibri", 1);
    textSize = 32;
    textColor = color(255, 255, 255);
    this.pos = pos;
    this.size = size;
  }
  
  public void onUpdate() {
    
  }

  public void onRender() {
    textAlign(CENTER, CENTER);
    textFont(font);
    textSize(textSize);
    fill(textColor);
    
    text(text, pos.x, pos.y, size.x, size.y);
  }
}
class Game extends GUI {

  boolean paused;

  boolean launched;

  // delay before successive pauses
  // this is to prevent causing down the ESC key causing epilepsy
  int pausedCooldown;
  int curPausedCooldown;

  // cooldown when a player dies before the ball is put in to the game again
  int countdown = 60;
  int curCountdown;

  int gameWidth;
  int gameHeight;

  // height offset for the questions GUI
  int heightOffset = 250;
  // height offset for the display GUI i.e. lives and time countdown
  int displayOffset = 150;

  Player player1;
  Player player2;

  Ball ball;

  GameOption gameOption;

  QuestionBank questionsEasy;
  QuestionBank questionsHard;

  int backgroundColor;

  Game() {

    curCountdown = 0;
    pausedCooldown = 30;

    backgroundColor = color(38, 23, 84);


    gameWidth = frameWidth;
    gameHeight = frameHeight-heightOffset;

    PVector paddleSize = new PVector(20, 150);

    Paddle paddle1 = new Paddle('w', 's', new PVector(paddleSize.x/2, gameHeight/2 + heightOffset), paddleSize);
    Paddle paddle2 = new Paddle('i', 'k', new PVector(gameWidth - paddleSize.x/2, gameHeight/2 + heightOffset), paddleSize);

    player1 = new Player(paddle1);
    player2 = new Player(paddle2);

    ball = new Ball(new PVector(gameWidth/2, gameHeight/2 + heightOffset));

    components.add(paddle1);
    components.add(paddle2);
    components.add(ball);

    gameOption = null;

    questionsEasy = new QuestionBank("vocabEasy1.txt");
    questionsHard = new QuestionBank("vocabHard1.txt");
  }

  // resets the game
  public void reset() {

    player1.paddle.pos = new PVector(player1.paddle.size.x/2, gameHeight/2 + heightOffset);
    player1.paddle.size = player1.paddle.originalSize.copy();

    player2.paddle.pos = new PVector(gameWidth - player1.paddle.size.x/2, gameHeight/2 + heightOffset);
    player2.paddle.size = player2.paddle.originalSize.copy();
    
    player1.curLives = player1.lives;
    player2.curLives = player2.lives;

    ball.resetBall();
    questionsScreen.reset();

    paused = true;
    launched = false;

    curCountdown = 0;

    gameOption = null;
  }

  // pauses or unpauses the game
  public void toggleState() {
    paused = !paused;
    if (paused) {
      pausedOverlay.setActive(true);
    } else {
      pausedOverlay.setActive(false);
    }
  }

  public void launchGame() {

    assert gameOption != null;

    // disable all title screen GUIs
    for (GUI gui : guis) {
      gui.setActive(false);
    }

    setActive(true);
    questionsScreen.setActive(true);
    gameDisplayScreen.setActive(true);

    questionsScreen.generateQuestion();

    launched = true;
    paused = false;
  }

  public void onUpdate() {

    if (!launched) return;

    if (curCountdown == 1) {

      if (player1.curLives == 0) {
        deathOverlay.setActive(true);
        game.paused = true;
        deathOverlay.description.text = "Player 2 has won!";
      } else if (player2.curLives == 0) {
        deathOverlay.setActive(true);
        game.paused = true;
        deathOverlay.description.text = "Player 1 has won!";
      } else {
                
        game.ball.active = true;
        game.ball.resetBall();
        
        questionsScreen.elapsedQuestionTime = 0;
      }
    }

    if (curCountdown == countdown) {
     questionsScreen.nextQuestion(); 
    }
    if (curCountdown > 0) {
      curCountdown--;
    }



    if (curPausedCooldown > 0) {
      curPausedCooldown--;
    }

    if (keyEscape && curPausedCooldown == 0) {
      toggleState();
      curPausedCooldown = pausedCooldown;
    }
  }

  public void onRender() {
    background(backgroundColor);

    if (paused) {
      pausedOverlay.onRender();
    }
  }
}

enum GameOption {
  Easy, Hard
}
class Paddle extends GraphicsComponent {

  // keys required to move the paddle up and down
  char upKey;
  char downKey;

  // width and height
  // the x value should remain constant
  // however the y value should be constantly diminshing - players will have to correctly answer questions to grow the size of the paddle
  PVector size;
  
  PVector originalSize;
  
  float minimumY;

  int paddleColor;

  Paddle(char upKey, char downKey, PVector pos, PVector size) {
    super(pos);
    this.upKey = upKey;
    this.downKey = downKey;
    this.originalSize = size.copy();
    this.pos = new PVector(pos.x, pos.y);
    this.size = size.copy();
    minimumY = 0;

    paddleColor = color(141, 168, 206);

    active = true;
  }

  // gets called when an answer has been answered correctly; increases paddls size
  public void increaseSize() {
    
    if (game.paused) return;
    
    size.y += 30;
  }

  // gets called when an answer has been answered incorrectly; decreases paddle size
  public void decreaseSize() {
    
    if (game.paused) return;
    
    size.y -= 30;
    if (size.y < minimumY) {
      size.y = minimumY;
    }
  }

  public void onUpdate() {
    
    if (game.paused) return;

    // gradually decrease paddle size
    size.y -= 0.04f;
    if (size.y < minimumY) {
      size.y = minimumY;
    }

    float speed = 10;
    if (keys[upKey]) {
      pos.y -= speed;
    }
    if (keys[downKey]) {
      pos.y += speed;
    }

    // boundary checking
    // prevent the paddles from going outside the screen
    if (pos.y - size.y/2 < game.heightOffset) {
      pos.y = size.y/2 + game.heightOffset;
    }
    if (pos.y + size.y/2 > game.heightOffset + game.gameHeight) {
      pos.y = game.heightOffset + game.gameHeight - size.y/2;
    }
  }

  public void onRender() {
    fill(paddleColor);
    strokeWeight(0);
    rect(pos.x - size.x / 2, pos.y - size.y / 2, size.x, size.y);
  }
}
class Player {

  Paddle paddle;

  // stores whether the player has already answered this round
  // players can only answer once per round
  boolean answered;

  // number of lives of the player
  int lives;

  // current number of lives of the player
  int curLives;

  Player(Paddle paddle) {
    this.paddle = paddle; 

    answered = false;
    lives = 3;
    restoreAllLives();
  }

  public void die() {
   curLives--;
   game.curCountdown = game.countdown;
   game.ball.active = false;
  }

  public void setAnswered(boolean answered) {
    this.answered = answered;
  }

  public void restoreAllLives() {
    curLives = lives;
  }
}
  

class QuestionBank {

  ShuffledList<LatinEnglishPair> questions;
  ShuffledList<LatinEnglishPair> incorrectAnswers;

  QuestionBank(String textFile) {

    // hashset for making sure we do not get duplicate entries for latin vocab
    // all latin vocab that has been loaded is stored here
    // just for error checking - not actually important
    HashSet set = new HashSet();

    ArrayList<LatinEnglishPair> l = new ArrayList<LatinEnglishPair>();
    BufferedReader reader = createReader(textFile);  
    String line;
    try {
      while ((line = reader.readLine()) != null) {
        // parses input string

        // check that the string is in the correct format first
        if (isValid(line)) {
          String[] arr = line.split(";");
          String latin = arr[0];
          String[] english = arr[1].split(",");

          // assert that we do not have a duplicate entry for latin vocab
          assert set.contains(latin) == false : latin;
          set.add(latin);

          LatinEnglishPair pair = new LatinEnglishPair(latin, english);
          l.add(pair);
        }
      }
      questions = new ShuffledList<LatinEnglishPair>(l);
      incorrectAnswers = new ShuffledList<LatinEnglishPair>(l);
    } 
    catch (IOException e) {
      println(e);
      assert false;
    }
  }

  // returns whether the given line is in the correct format to be parsed for Latin to ENglish translations
  public boolean isValid(String line) {
    String[] arr = line.split(";");
    if (arr.length != 2) return false;
    return true;
  }

  // generates a random multiple choice question and answers
  public QuestionAnswerChoice generate() {
    LatinEnglishPair[] answers = new LatinEnglishPair[4];

    // generate the question and answer
    LatinEnglishPair questionPair = questions.getNext();
    answers[0] = questionPair;
    String question = questionPair.latin;
    String correctAnswer = questionPair.englishTranslations[PApplet.parseInt(random(questionPair.englishTranslations.length))];

    // generate 3 incorrect answers
    LatinEnglishPair incorrectPair1 = generateIncorrectAnswer(answers);
    answers[1] = incorrectPair1;
    String incorrect1 = incorrectPair1.englishTranslations[PApplet.parseInt(random(incorrectPair1.englishTranslations.length))];

    LatinEnglishPair incorrectPair2 = generateIncorrectAnswer(answers);
    answers[2] = incorrectPair2;
    String incorrect2 = incorrectPair2.englishTranslations[PApplet.parseInt(random(incorrectPair2.englishTranslations.length))];

    LatinEnglishPair incorrectPair3 = generateIncorrectAnswer(answers);
    answers[3] = incorrectPair3;
    String incorrect3 = incorrectPair3.englishTranslations[PApplet.parseInt(random(incorrectPair3.englishTranslations.length))];
    
    QuestionAnswerChoice choice = new QuestionAnswerChoice(question, correctAnswer, incorrect1, incorrect2, incorrect3);
    return choice;
  }

  // private method for generating an incorrect answer
  // the generated answer is guaranteed to not be an element in the input array
  public LatinEnglishPair generateIncorrectAnswer(LatinEnglishPair[] excluding) {
    while (true) {    
      LatinEnglishPair pair = incorrectAnswers.getNext();

      // find a latinEnglish pair not in the excluded array
      for (LatinEnglishPair exclude : excluding) {
        if (exclude == pair) {
          // the exclude array contains the randomised element
          continue;
        }
      }
      
      boolean flag = false;
      
      // make sure that any of the English translations in the selected pair are not the same as any in the excluding array
      for (String english : pair.englishTranslations) {
        for (LatinEnglishPair p : excluding) {
          if (p == null) continue;
         for (String pEnglish : p.englishTranslations) {
          if (pEnglish.equals(english)) {
           flag = true; 
          }
         }
        }
      }
      
      if (flag) continue;
      
      return pair;
    }
  }
}

// represents a multiple choice question and answer option
// contains the question, four possible answers, and a reference to the correct answer
class QuestionAnswerChoice {

  String question;

  String answerA;
  String answerB;
  String answerC;
  String answerD;

  String correctAnswer;

  QuestionAnswerChoice(String question, String correctAnswer, String incorrect1, String incorrect2, String incorrect3) {
    this.question = question;
    this.correctAnswer = correctAnswer;
    ArrayList<String> l = new ArrayList<String>();
    l.add(correctAnswer);
    l.add(incorrect1);
    l.add(incorrect2);
    l.add(incorrect3);
    Collections.shuffle(l);

    answerA = l.get(0);
    answerB = l.get(1);
    answerC = l.get(2);
    answerD = l.get(3);
  }
}

class LatinEnglishPair {

  String latin;
  String[] englishTranslations;

  LatinEnglishPair(String latin, String[] englishTranslations) {
    this.latin = latin;
    this.englishTranslations = englishTranslations;
  }
}
class GameDisplayScreen extends GUI {
  
  Label lblLives;
  Label lblTime;

  GameDisplayScreen() {
    lblLives = new Label(new PVector(0,0), "Lives");
    components.add(lblLives);
  }

  public void onRender() {
    
    int timeY = 45;

    // display the amount of time left as a rectangle
    
    int full = color(0, 255, 80);
    int empty = color(255, 0, 20);
    
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
    
     int heartColor = color(255, 20, 40);
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

  public void onRender() {
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

  public void onRender() {
    fill(48, 48, 48, 240);
    rect(0, 0, frameWidth, frameHeight);
  }
}
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

  public void reset() {
    answerA.status = AnswerStatus.None;
    answerB.status = AnswerStatus.None;
    answerC.status = AnswerStatus.None;
    answerD.status = AnswerStatus.None;
    curCooldown = 1;
  }

  public void nextQuestion() {
    curCooldown = fadeTime + waitTime;
  }

  // generates a new question and updates the display accordingly
  public void generateQuestion() {

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

  public void onUpdate() {

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

  public void onRender() {
    // fill(questionsBackground);
    //strokeWeight(0);
    /// rect(0, 0, frameWidth, game.displayOffset);
  }
}
int titleSize = 72;
float titleY = 70;
int headingSize = 48;
float headingY = 140;
float backY = 560;

int questionsBackground = color(30, 22, 64, 255);
int gameDisplayBackground = color(46, 70, 90);

class SplashScreen extends GUI {

  int backgroundColor;

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

  public void onRender() {
    if (curTime < displayTime) {
      background(backgroundColor);
    } else if (curTime < displayTime + transitionTime) {
      // transition the background colorx
      float offset = 5;
      float factor = (float)(curTime - displayTime-offset)/(transitionTime-offset);
      int c = lerpColor(backgroundColor, game.backgroundColor, factor);
      background(c);
    }
  }

  public void onUpdate() {

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

  public void onRender() {
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

  public void onRender() {
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
    TextArea instructions = new TextArea("Two players battle in an epic game of Pong. Each player has a paddle which is used to reflect a moving ball. Over time, the size of the paddle shrinks, making it more and more difficulty to reflect the ball. Once the ball reaches the edge of the screen, the current round is considered over, and the losing player will lose one life. Each player starts with three lives, and when one player reaches zero lives, then that player is considered the loser, and the other player wins.\n\nQuestions will regularly appear at the top of the screen, which consist of a Latin word and 4 possible English translations. Players must answer these questions correctly to increase their paddle size. However, answering a question incorrectly will incur a penalty. Furthermore, questions must also be answered within the specified time limit, otherwise this will be considered as answering incorrectly. For each question, a player may only answer once. ", 
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

  public void onRender() {
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
    components.add(new Label(new PVector(frameWidth/2, y), subheadingSize, "Player 2"));
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

  public void onRender() {
    background(game.backgroundColor);
  }
}
// represents a data structure where the distribution of elements in a list seem "more random" by making it less random

// IMPLEMENTATION
// initialisation: 
//   the original list is divided into two halves
// 
// runtime: 
//   shuffle each of the two halves
//   all the elements in the first half are iterated through first, then the elements in the second half are iterated
//   process repeats again - i.e. shuffle two halves, iterate through first then second

// this ensure that given a list of length n, the same element k will not be iterated through until at least n/2 other elements have been iterated

class ShuffledList<T> {

  ArrayList<T> firstHalf;
  ArrayList<T> secondHalf;
  
  // stores where we are up to in each of the halves
  int firstIndex;
  int secondIndex;
  
  ShuffledList() {
    this(new ArrayList<T>());
  }

  ShuffledList(ArrayList<T> originalList) {
    
    firstHalf = new ArrayList<T>();
    secondHalf = new ArrayList<T>();
    
    Collections.shuffle(originalList);
    
    // adding elements
    for (T t : originalList) {
      add(t);
    }
    
    shuffle();
  }
  
  // size of the shuffled list
  public int size() {
    return firstHalf.size() + secondHalf.size();
  }

  // shuffles both halves.
  public void shuffle() {
    Collections.shuffle(firstHalf);
    Collections.shuffle(secondHalf);
  }
  
  // adds an element to the shuffled list
  public void add(T t) {
    if (firstHalf.size() <= secondHalf.size()) {
     firstHalf.add(t); 
    }else{
     secondHalf.add(t); 
    }
  }
  
  // gets a random element
  public T getRandom() {
    T result;
    if (random(0, 1) < 0.5f) {
      int index = PApplet.parseInt(random(firstHalf.size()));
      result = firstHalf.get(index);
    } else {
      int index = PApplet.parseInt(random(secondHalf.size()));
      result = secondHalf.get(index);
    }
    return result;
  }

  public T getNext() {
    T result = null;
    if (firstIndex < firstHalf.size()) {
      result = firstHalf.get(firstIndex);
      firstIndex++;
    } else if (secondIndex < secondHalf.size()) {
      result = secondHalf.get(secondIndex);
      secondIndex++;
    } else {
     assert false; 
    }
    assert result != null;
    
    if (secondIndex == secondHalf.size()) {
      firstIndex = 0;
      secondIndex = 0;
      shuffle();
    }
    return result;
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "SDDGame" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
