class AnswerLabel extends Label {

  float borderWidth;

  color borderCorrectColor;
  color borderIncorrectColor;
  color borderNeitherColor;

  color borderCurrentColor;

  int incorrectCooldown;
  int curIncorrectCooldown;

  AnswerLabel(PVector pos, PVector size, String text) {
    super(pos, size, text);

    borderCorrectColor = color(20, 255, 0);
    borderIncorrectColor = color(255, 0, 20);
    borderNeitherColor = color(0, 0, 0);

    borderWidth = 3;

    incorrectCooldown = 20;
  }

  // call this to set the correct state
  void setCorrect() {
    borderCurrentColor = borderCorrectColor;
  }

  // call this to set the incorrect state
  void setIncorrect() {
    curIncorrectCooldown = incorrectCooldown;
  }

  // call this to set the state to neither
  void setNone() {
    borderCurrentColor = borderNeitherColor;
  }

  void onUpdate() {
    if (curIncorrectCooldown > 0) {
      curIncorrectCooldown--;
      
      float ratio = (float)curIncorrectCooldown / incorrectCooldown;
      borderCurrentColor = color(ratio * red(borderIncorrectColor), ratio * green(borderIncorrectColor), ratio * blue(borderIncorrectColor));
    } 
  }

  void onRender() {
    super.onRender(); 
    stroke(borderCurrentColor);
    strokeWeight(borderWidth);
    fill(0, 0, 0, 0);
    rect(pos.x + borderWidth, pos.y + borderWidth, size.x - borderWidth*2, size.y - borderWidth*2);
  }
}