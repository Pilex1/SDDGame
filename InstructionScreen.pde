class InstructionScreen extends GUI {

  InstructionScreen() {

    // label that says Instructions in big font
    Label lbl = new Label(new PVector(100, 100), "Instructions");
    lbl.textSize = 48;
    lbl.hAlign = LEFT;
    components.add(lbl);
    
    // actual instructions contents
    Label lblText = new Label(new PVector(100, 200), "");
    lblText.hAlign = LEFT;
    components.add(lblText);

    // button to go back to title screen
    components.add(new Button(new PVector(100, 550), new PVector(frameWidth/2, 100), "Back", new IAction() {
      public void action() {
        instructionScreen.setActive(false);
        titleScreen.setActive(true);
        titleScreen.resetButtonCooldowns();
      }
    }
    ));
  }
  
  void onRender() {
     background(backgroundColor); 
  }
}