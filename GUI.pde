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