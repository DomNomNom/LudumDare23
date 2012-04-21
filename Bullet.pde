class Bullet extends Entity {
  final float speed = .5;
  float angle;

  Bullet(PVector spawnPos, float angle) {
    pos = new PVector(spawnPos.x, spawnPos.y);
    vel = new PVector(1, 0);
    vel.rotate(angle);
    vel.mult(speed);
    this.angle = angle;
    drawLayer = layer.bullet;
    groups = new group[] {group.game, group.bullet};
    animation = resources.animations.get("bullet");
  }

  void draw() {
    translate(pos.x, pos.y);
    rotate(angle);
    animation.draw();
  }
}
