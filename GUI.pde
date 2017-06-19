// represents a screen/display on which GraphicsComponents can be added
abstract class GUI {

  boolean active;
  ArrayList<GraphicsComponent> components;

  GUI() {
    active = false;
    components = new ArrayList<GraphicsComponent>();
  }

  // can be overriden in sub-classes for additional functionality when the GUI is set active
  void onSetActive() {
  }
  // can be overriden in sub-classes for additional functionality when the GUI is set inactive
  void onSetInactive() {
  }
  final void setComponentsActive(boolean active) {
    for (GraphicsComponent b : components) {
      assert b != null;
      b.active = active;
    }
  }
  final void setActive(boolean active) {
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
  void onUpdate() {
  }
  // by default, everything in the components list is updated
  final void update() {
    if (!active) return;
    onUpdate();
    for (GraphicsComponent b : components) {
      assert b != null;
      b.update();
    }
  }

  // can be overriden in sub-classes for additional functionality when the GUI is rendering e.g. change the background color
  void onRender() {
  }
  // by default, the GUI renders everything in the components list
  final void render() {    
    if (!active) return;
    onRender();
    for (GraphicsComponent b : components) {   
      assert b != null;
      b.render();
    }
  }

  void resetButtonCooldowns() {
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

  abstract void onUpdate();
  void update() {
    if (!active) return;
    onUpdate();
  }

  abstract void onRender();
  void render() {
    if (!active) return;
    onRender();
  }
}

interface IAction {
  void action();
}

class Button extends GraphicsComponent {

  PVector size;

  color backgroundColor;
  color backgroundHoverColor;
  color textColor;

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

    cooldown = 30;
    curCooldown = 0;
  }

  void onRender() {
    noStroke();
    fill(hoveredOver ? backgroundHoverColor : backgroundColor);
    rect(pos.x, pos.y, size.x, size.y);

    textFont(font);
    textAlign(CENTER, CENTER);
    fill(textColor);
    PVector textPos = new PVector(pos.x + size.x / 2, pos.y + size.y / 2);
    text(this.text, textPos.x, textPos.y);
  }

  void resetCooldown() {
    curCooldown = cooldown;
  }

  void onUpdate() {

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

  // size of the label rectangle
  PVector size;

  PFont font;
  int textSize;
  color textColor;

  String text;

  int hAlign;
  int vAlign;

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

  void onUpdate() {
  }

  void onRender() {
    textAlign(hAlign, vAlign);
    fill(textColor);
    textFont(font);
    textSize(textSize);
    text(text, pos.x + size.x/2, pos.y + size.y/2);
  }
}

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


// multi line label
class TextArea extends GraphicsComponent {

  String text;
  PFont font;
  int textSize;
  color textColor;

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
  
  void onUpdate() {
    
  }

  void onRender() {
    textAlign(CENTER, CENTER);
    textFont(font);
    textSize(textSize);
    fill(textColor);
    
    text(text, pos.x, pos.y, size.x, size.y);
  }
}