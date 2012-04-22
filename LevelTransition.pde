class LevelTransition extends Entity {
  int level;
  boolean success;

  LevelTransition(int changeToLevel, boolean success) {
    this.level = changeToLevel;
    this.success = success;
    size = new PVector(width, height);
    groups = new group[] {group.menu};
    drawLayer = layer.menu;
  }
  
  void draw() {
    fill(250);
    
    if (success) {
      textFont(resources.fonts.get("pauseLabel"), 48);
      text("Universe " +(level-1)+" Completed", center.x, .8*center.y);
    }
    
    textFont(resources.fonts.get("pauseLabel"), 26);
    text("Press spacebar to start universe " + level, center.x, center.y);
    
    if (!success) {
      String levelHint;
      switch (level) {
               case 1:  levelHint = "Bigger ones eat smaller ones";
        break; case 2:  levelHint = "Sometimes you have to explore a little";
        break; case 3:  levelHint = "Going too fast may hurt you";
        break; default: levelHint = "No hints for this level";
      }
      text("hint: " + levelHint, center.x, 1.6*center.y);
    }
  }
}
