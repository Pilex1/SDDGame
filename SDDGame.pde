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

void settings() {
  size(frameWidth, frameHeight);
}

void setup() {
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

void draw() {

  if (frameCount % 60 == 1) {
    surface.setTitle("Latin Pong - Copyright Alex Tan 2017 | FPS: " + int(frameRate));
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

void keyPressed() {
  if (key >= 0 && key <= 255) {
    keys[key] = true;
  }
  if (keyCode == ESC) {
    keyEscape = true;
    key = 0;
  }
}

void keyReleased() {
  if (key >= 0 && key <= 255) {
    keys[key] = false;
  }
  if (keyCode == ESC) {
    keyEscape = false;
  }
}