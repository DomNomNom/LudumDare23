class GameOver extends Entity {

  float centerBarHeight;

  GameOver() {
    groups = new group[] {group.menu, group.gameOverMenu};

    size = new PVector(width, height);
    drawLayer = layer.menu;
    centerBarHeight = center.x/4;
  }

  void draw() {
    fill(#D32626, 100);
    rect(center.x, center.y, width, height         );
    
    
    translate(0, -0.3*center.y);
    rect(center.x, center.y, width, centerBarHeight);
    fill(250);
    textFont(resources.fonts.get("pauseLabel"), 48);
    text("You are dead.", center.x, center.y);
    
    textFont(resources.fonts.get("pauseLabel"), 26);
    
    text("Press r to retry", center.x, 1.3*center.y);
    
    text("Press spacebar to return to menu", center.x, 1.6*center.y);
    text("(DISCARDS ALL GAME PROGRESS)", center.x, 1.7*center.y);
  }
}
