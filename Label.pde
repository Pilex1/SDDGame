class Label extends GraphicsComponent {

  PFont font;
  int size;
  String text;
  color textColor;

  int hAlign;
  int vAlign;

  Label(PVector pos, String text) {
    super(pos);
    font = createFont("Calibri", 1);
    size = 32;
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
    textSize(size);
    text(text, pos.x, pos.y);
  }
}