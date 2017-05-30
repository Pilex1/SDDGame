final int frameWidth = 1280;
final int frameHeight = 720;

ArrayList<GUI> guis;
TitleScreen titleScreen;
DifficultyScreen difficultyScreen;
InstructionScreen instructionScreen;
QuestionsScreen questionsScreen;
Game game;

color backgroundColor;

// storing if the respective keys are pressed
boolean keys[];

void settings() {
  size(frameWidth, frameHeight);
}

void setup() {
  guis = new ArrayList<GUI>();

  game = new Game();
  guis.add(game);

  titleScreen = new TitleScreen();
  titleScreen.setActive(true);
  difficultyScreen = new DifficultyScreen();
  instructionScreen = new InstructionScreen();
  questionsScreen = new QuestionsScreen();

  guis.add(titleScreen);
  guis.add(difficultyScreen);
  guis.add(instructionScreen);
  guis.add(questionsScreen);

  backgroundColor = color(38, 23, 84);

  keys = new boolean[255];
}

void draw() {

  if (frameCount % 60 == 0) {
    surface.setTitle("SDD Game - Copyright Alex Tan 2017 | FPS: " + int(frameRate));
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
}