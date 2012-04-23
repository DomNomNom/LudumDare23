class HelpMenu extends Entity {

  float centerBarHeight;

  HelpMenu() {
    groups = new group[] {group.menu, group.pauseMenu};

    size = new PVector(width, height);
    drawLayer = layer.menu;
    centerBarHeight = center.x/4;
    
    engine.debug = ""; // remove "press h for help"
  }

  void draw() {

    fill(0, 100);
    rect(center.x, center.y, width, height         );
    rect(center.x, 0.3*center.y, width, centerBarHeight);

    fill(250);
    textFont(resources.fonts.get("pauseLabel"), 48);
    text("Help:", center.x, 0.3*center.y);
    
    textFont(resources.fonts.get("pauseLabel"), 26);
    text("Use arrow keys to move", center.x, 0.8*center.y);
    text("Use r to restart your universe", center.x, 1.0*center.y);
    text("Use p to pause the game", center.x, 1.2*center.y);
    text("Use h to toggle this screen", center.x, 1.4*center.y);
  }
}
