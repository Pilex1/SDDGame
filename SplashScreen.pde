class SplashScreen extends GUI {

  color backgroundColor;

  // displays splash screen for 4 seconds, then transitions over the course of 2 seconds
  int displayTime;
  int transitionTime;

  int curTime;
  
  Label copyright;

  SplashScreen() {
    backgroundColor = color(53, 70, 92);

    displayTime = 2 * 60;
    transitionTime = 2 * 60;
    curTime = 0;

    Label title = new Label(new PVector(frameWidth/2, 100), "Latin Pong");
    title.textSize = 72;
    title.textColor = color(195, 190, 222);

    Label name = new Label(new PVector(frameWidth/2, 300), "By Alex Tan");

    Label classInfo = new Label(new PVector(frameWidth/2, 400), "11SDD3");

    copyright = new Label(new PVector(frameWidth, frameHeight), new PVector(0, 0), "Copyright Alex Tan 2017");
    copyright.textSize = 24;
    copyright.hAlign = RIGHT;
    copyright.vAlign = BOTTOM;

    components.add(title);
    components.add(name);
    components.add(classInfo);
    components.add(copyright);
  }

  void onRender() {
    if (curTime < displayTime) {
      background(backgroundColor);
    } else if (curTime < displayTime + transitionTime) {
      // transition the background color
      float offset = 30;
      float factor = (float)(curTime - displayTime-offset)/(transitionTime-offset);
      color c = lerpColor(backgroundColor, game.backgroundColor, factor);
      background(c);
    }
  }

  void onUpdate() {

    if (curTime < displayTime) {
      // splash screen display for 4 seconds
      setActive(true);
    } else if (curTime < displayTime + transitionTime) {     
      // moves all the labels leftwards
      float movement = frameWidth / transitionTime;
      for (GraphicsComponent g : components) {
        if (g == copyright) continue;
        g.pos.x -= movement;
      }
    } else {
      setActive(false);
      titleScreen.setActive(true);
    }


    curTime++;
  }
}