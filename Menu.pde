class Menu extends Entity {

  Menu() {
    size = new PVector(width, height);
    groups = new group[] {group.menu};
    drawLayer = layer.menu;
  }
  
  void draw() {
    // game label
    fill(250);
    textFont(resources.fonts.get("pauseLabel"), 48);
    text("Get Tiny", center.x, .8*center.y);
    
    textFont(resources.fonts.get("pauseLabel"), 26);
    text("The universe needs to get tiny!", center.x, center.y);
    
    text("Press SPACEbar to get tiny", center.x, 1.5*center.y);
  }
}
