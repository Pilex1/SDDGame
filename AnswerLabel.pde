class AnswerLabel extends Label {

  float borderWidth;

  color borderCorrectColor;
  color borderIncorrectColor;
  color borderNeitherColor;

  AnswerStatus status;

  AnswerLabel(PVector pos, PVector size, String text) {
    super(pos, size, text);

    status = AnswerStatus.None;

    borderCorrectColor = color(20, 255, 0);
    borderIncorrectColor = color(255, 0, 20);
    borderNeitherColor = color(0, 0, 0);

    borderWidth = 3;
  }

  void setStatus(AnswerStatus status) {
    this.status = status;
  }

  void onRender() {
    super.onRender(); 
    
    if (status == AnswerStatus.None) {
      stroke(borderNeitherColor);
    } else if (status == AnswerStatus.Correct) {
      stroke(borderCorrectColor);
    } else if (status == AnswerStatus.Incorrect) {
      stroke(borderIncorrectColor);
    } else {
     assert false; 
    }
    strokeWeight(borderWidth);
    
    fill(0, 0, 0, 0);
    rect(pos.x + borderWidth, pos.y + borderWidth, size.x - borderWidth*2, size.y - borderWidth*2);
  }
}

enum AnswerStatus {
 None, Correct, Incorrect 
}