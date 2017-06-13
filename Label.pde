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
  
  // size is not the actual size of the text (this is textSize), but the size of the imaginary "box" surrounding the label
  // it is used in calculations for the positioning of the text
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