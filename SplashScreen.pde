class SplashScreen extends GUI {
  
  int time;
  
  SplashScreen() {
    time = 0;
  }
  
  void onUpdate() {
   
    // displays splash screen for 4 seconds, then fades away over the course of 2 seconds
   int displayTime = 4 * 60;
   int fadeTime = 2 * 60;
   
   if (time < displayTime) {
     
   } else if (time < fadeTime) {
     
   } else {
    active = false; 
   }
   
    
    time++;
    
  }
  
}