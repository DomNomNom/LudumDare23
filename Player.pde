class Player extends Creature {
  PVector target;

  final static float spriteRadius = 50;

  float movementSpeed = .2;
  float angle;
  float rotateSpeed = .01;

  Player(float x, float y) {
    super(spriteRadius);
    pos = new PVector(x, y);
    target = new PVector(0,0);
    groups = new group[] {group.game, group.player, group.creature};
    drawLayer = layer.player;
    animation = resources.animations.get("player");
  }

  boolean isBigger(Creature c) {
    return (this.radius >= c.radius); // the player is dominant in the equal case
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
    PVector acc = new PVector(input.control.x, input.control.y);
    acc.normalize();
    acc.mult(.001);

    if (input.control.mag() == 0)
      acc.add(PVector.mult(vel, -.005)); // friction

    vel.add(PVector.mult(acc, dt));

    /*
    vel.x = input.control.x; // deep copy as we don't want to modify input.
    vel.y = input.control.y;
    vel.normalize();
    vel.mult(movementSpeed);
    */
    move(dt);

    angle += rotateSpeed;

    animation.update(dt);
  }

  void draw() {
    fill(color(40, 200, 40));
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(angle);
      noSmooth(); // note: smoothed image + rotating + smoothing = crap
      scale(radius/spriteRadius);
      animation.draw();
      smooth();
    popMatrix();
    
    // Target line
    stroke(255, 100);
    //line(pos.x, pos.y, target.x, target.y);
  }
}
