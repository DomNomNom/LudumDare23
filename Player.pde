class Player extends Creature {
  PVector target;

  float movementSpeed = .2;
  float angle;
  float rotateSpeed = .01;

  Player(float x, float y) {
    super(50);
    pos = new PVector(x, y);
    target = new PVector(0,0);
    groups = new group[] {group.game, group.player};
    drawLayer = layer.player;
    animation = resources.animations.get("player");
  }

  void shoot() {
    /* // NO SHOOTING IN THIS GAME!
    if (updating) {
      // spawn a bullet
      engine.addEntity(new Bullet(pos, angle));

      // play the shooting sound
      resources.sounds.get("shot").rewind();
      resources.sounds.get("shot").play();
    }
    */
  }

  void update(float dt) {
    vel.x = input.control.x; // deep copy as we don't want to modify input.
    vel.y = input.control.y;
    vel.normalize();
    vel.mult(movementSpeed);
    move(dt);

    angle += rotateSpeed;

    animation.update(dt);
  }

  void draw() {
    fill(color(40, 200, 40));
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(angle);
      animation.draw();
    popMatrix();
    
    // Target line
    stroke(255, 100);
    //line(pos.x, pos.y, target.x, target.y);
  }
}
