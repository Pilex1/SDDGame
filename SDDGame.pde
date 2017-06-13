final int frameWidth = 1280;
final int frameHeight = 720;

ArrayList<GUI> guis;
TitleScreen titleScreen;
DifficultyOverlay difficultyScreen;
InstructionScreen instructionScreen;
QuestionsScreen questionsScreen;
SplashScreen splashScreen;
Game game;

Label copyright;

// storing if the respective keys are pressed
boolean keys[];
boolean keyEscape;

void settings() {
  size(frameWidth, frameHeight);
}

void setup() {
  guis = new ArrayList<GUI>();

  game = new Game();
  guis.add(game);

  titleScreen = new TitleScreen();
  difficultyScreen = new DifficultyOverlay();
  instructionScreen = new InstructionScreen();
  questionsScreen = new QuestionsScreen();
  splashScreen = new SplashScreen();
  splashScreen.setActive(true);

  guis.add(splashScreen);
  guis.add(titleScreen);
  guis.add(difficultyScreen);
  guis.add(instructionScreen);
  guis.add(questionsScreen);
  
  copyright = 

  keys = new boolean[255];
}

void draw() {

  if (frameCount % 60 == 0) {
    surface.setTitle("Latin Pong - Copyright Alex Tan 2017 | FPS: " + int(frameRate));
  }

  background(0, 0, 0);
  for (GUI gui : guis) {
    gui.update();
  }
  
  for (GUI gui : guis) {
    gui.render();
  }
}

void keyPressed() {
  if (key >= 0 && key <= 255) {
    keys[key] = true;
  }
}

void keyReleased() {
  if (key >= 0 && key <= 255) {
    keys[key] = false;
  }
  if (keyCode == ESC) {
    keyEscape = true;
    key = 0;
  }
}