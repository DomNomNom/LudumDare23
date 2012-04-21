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
  
  boolean collidesWith(Creature c) {
    float r = c.radius;
    return (
      // are any of up/down/left/right points out of bounds
      collidesWith(PVector.add(c.pos, new PVector( r,  0) )) ||
      collidesWith(PVector.add(c.pos, new PVector(-r,  0) )) ||
      collidesWith(PVector.add(c.pos, new PVector( 0,  r) )) ||
      collidesWith(PVector.add(c.pos, new PVector( 0, -r) ))
    );
  }
}
