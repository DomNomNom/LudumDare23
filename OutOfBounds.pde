// A small physics class to test whether a point is out of bounds

class OutOfBounds extends Entity {
  OutOfBounds() {
    pos  = center;
    size = new PVector(width, height);
    groups = new group[]{ group.levelBounds };
    drawLayer = layer.invisible;
  }
  
  boolean collidesWith(PVector point) {
    return (
      abs(point.x - pos.x) > size.x/2  ||
      abs(point.y - pos.y) > size.y/2
    );
  }
}
