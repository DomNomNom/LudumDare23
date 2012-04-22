class Player extends Creature {
  PVector target;

  final static float spriteRadius = 50;
  float scaleFactor;

  final float controlSpeed = .0007;
  final float friction = .005;

  float angle;
  float rotateSpeed = .01;
  
  // sound
  boolean didCollide;
  boolean prevCollide;
  

  Player(float x, float y) {
    super(spriteRadius);
    pos = new PVector(x, y);
    target = new PVector(0,0);
    groups = new group[] {group.game, group.player, group.creature};
    drawLayer = layer.player;
    animation = resources.animations.get("player");
    scaleFactor = 1;
    didCollide = false;
  }

  boolean isBigger(Creature c) {
    return (this.radius >= c.radius); // the player is dominant in the equal case
  }

  boolean collidesWith(Entity e) {
    boolean collision = super.collidesWith(e);
    if (collision) didCollide = true;
    return collision;
  }
  
  boolean collidesWith(PVector point) {
    boolean collision = super.collidesWith(point);
    if (collision) didCollide = true;
    return collision;
  }

  void shoot() {
    /* // NO SHOOTING IN THIS GAME! */
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
    resources.sounds.get("transfer").pause();
    dead = true;
  }

  void draw() {
    // collision sound
    //engine.debug = ""+didCollide;
    if (didCollide && !prevCollide)
      resources.sounds.get("transfer").loop();
    else if (prevCollide && !didCollide)
      resources.sounds.get("transfer").pause();
    prevCollide = didCollide;
    didCollide = false;
  

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
