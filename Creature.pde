class Creature extends Entity {
  float radius;
  
  Creature(float rad) {
    radius = rad;
    size = new PVector(0, 0); // DON'T USE THIS
    groups = new group[] {group.creature, group.game};
  }
  
  float getArea() {
    return PI * radius * radius;
  }
  
  void addArea(float v) {
    setArea(getArea() + v);
  }
  
  void setArea(float v) {
    if (v <= 0) {
      println("OMG I'm dead!");
      radius = 0;
      die();
      return;
    }
    
    radius = sqrt(v/PI); // inverse of 
  }
  
  
  boolean isBigger(Creature c) {
    return (this.radius > c.radius);
  }
  
  boolean collidesWith(Entity e) {
    // if their center is within us
    if (collidesWith(e.pos)) return true;
  
    // p is the point on our circumference closest to the e's position
    PVector p = PVector.sub(e.pos, pos);
    p.normalize();
    p.mult(radius);
    p.add(pos);
    
    // does the e collide with this point
    return e.collidesWith(p);
  }
  
  boolean collidesWith(PVector point) {
    return (PVector.dist(point, pos) < radius);
  }
}
