class Mover extends Creature {

  Mover(float x, float y, float radius) {
    super(radius);
    pos = new PVector( x,  y);
    vel = new PVector(.0, .0);
    drawLayer = layer.enemy;
    groups = new group[] {group.game, group.enemy, group.creature};
  }

  void draw() { // TODO: make a animation for this
    if (engine.player.isBigger(this)) 
      fill(#2F8FC1);
    else
      fill(#C12F2F);

    translate(pos.x, pos.y);
    if (animation == null)
      ellipse(0, 0, radius, radius);
    else
      animation.draw();
  }
}
