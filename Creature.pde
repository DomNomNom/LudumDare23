class Creature extends Entity {
  float radius;
  
  Creature(float rad) {
    radius = rad;
    size = new PVector(radius, radius);
  }
  
  boolean isBigger(Creature c) {
    return (this.radius >= c.radius);
  }
  
  boolean collidesWith(Entity e) {
    // if their center is within us
    if (collidesWith(e.pos)) return true;
  
    // p is the point on our circumference closest to the position of e
    PVector p = PVector.sub(e.pos, pos);
    p.normalize();
    p.mult(radius);
    p.add(pos);
    return e.collidesWith(p);
  }
  
  boolean collidesWith(PVector point) {
   println("DONG: " + (PVector.dist(point, pos) < radius));
    return (PVector.dist(point, pos) < radius);
  }
}
