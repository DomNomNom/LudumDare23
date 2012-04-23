class Mover extends Creature {
  final static float spriteRadius = 50;
  float scaleFactor;
  
  float angle;
  
  Mover(float x, float y, float radius) {
    super(radius);
    scaleFactor = radius/spriteRadius;
    pos = new PVector( x,  y);
    vel = new PVector(.0, .0);
    drawLayer = layer.enemy;
    groups = new group[] {group.game, group.enemy, group.creature};
    animation = resources.animations.get("mover");
    angle = random(TWO_PI);
  }
  Mover(float x, float y, float radius, float velX, float velY) {
    super(radius);
    scaleFactor = radius/spriteRadius;
    pos = new PVector( x,  y);
    vel = new PVector(velX, velY);
    drawLayer = layer.enemy;
    groups = new group[] {group.game, group.enemy, group.creature};
    animation = resources.animations.get("mover");
    angle = random(TWO_PI);
  }

  void draw() { // TODO: make a animation for this
    color drawColor;
    if (engine.player.isBigger(this)) 
      tint(#2F8FC1);
    else
      tint(#C12F2F);

    translate(pos.x, pos.y);
    rotate(angle);
    scaleFactor = spriteRadius/radius;
    scale(1.0/scaleFactor);
    if (animation == null)
      ellipse(0, 0, radius, radius);
    else
      animation.draw();
  }
}
