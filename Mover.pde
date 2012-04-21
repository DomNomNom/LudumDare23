class Mover extends Entity {
  Mover(float x, float y) {
    pos = new PVector( x,  y);
    vel = new PVector(.1, .0);
    drawLayer = layer.enemy;
    groups = new group[] {group.game, group.enemy};
  }

  boolean collidesWith(PVector point) {
    if (abs(point.x - pos.x) > size.x/2) return false;
    if (abs(point.y - pos.y) > size.y/2) return false;
    return true;
  }
}
