class PauseMenu extends Entity {

  float centerBarHeight;

  PauseMenu() {
    groups = new group[] {group.menu, group.pauseMenu};

    size = new PVector(width, height);
    drawLayer = layer.menu;
    centerBarHeight = center.x/4;
  }

  void draw() {
    fill(0, 100);
    rect(center.x, center.y, width, height         );
    rect(center.x, center.y, width, centerBarHeight);

    fill(250);
    textFont(resources.fonts.get("pauseLabel"), 48);
    text("Paused", center.x, center.y);
  }
}
