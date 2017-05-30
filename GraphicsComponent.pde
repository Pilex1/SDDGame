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