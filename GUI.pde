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
  final void setActive(boolean active) {
    this.active = active;

    for (GraphicsComponent b : components) {
      assert b != null;
      b.active = active;
    }

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

  // can be overriden in sub-classes for additional functionality when the GUI is rendering
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