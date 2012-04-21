class Player extends Creature {
  PVector target;

  final static float spriteRadius = 50;
  float scaleFactor;

  final float controlSpeed = .001;
  final float friction = .005;

  float angle;
  float rotateSpeed = .01;

  Player(float x, float y) {
    super(spriteRadius);
    pos = new PVector(x, y);
    target = new PVector(0,0);
    groups = new group[] {group.game, group.player, group.creature};
    drawLayer = layer.player;
    animation = resources.animations.get("player");
    scaleFactor = 1;
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
    acc.mult(controlSpeed / scaleFactor);

    acc.add(PVector.mult(vel, -friction)); // friction

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

  void die() {
    println("OMG THE PLAYER DIED!");
    dead = true;
  }

  void draw() {
    scaleFactor = spriteRadius/radius;
    if (scaleFactor >= 30) {
      scaleFactor = 1;
      die();
      return;
    }
    fill(color(40, 200, 40));
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(angle);
      noSmooth(); // note: smoothed image + rotating + smoothing = crap
      scale(1.0/scaleFactor);
      animation.draw();
      smooth();
    popMatrix();
    
    // Target line
    stroke(255, 100);
    //line(pos.x, pos.y, target.x, target.y);
  }
}
