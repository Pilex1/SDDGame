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