/****************************************************************\
| Has the defenition of main game loop and pulls things together |
|                                                                |
| Contains two inner classes: Physics and GameState              |
\****************************************************************/

class Engine {
  // entity handling
  Player player;
  Background background;
  Physics physics = new Physics();
  private ArrayList<Entity> entities = new ArrayList<Entity>();
  private HashMap<group, ArrayList<Entity>> groups = new HashMap<group, ArrayList<Entity>>();
  float prevTime;

  String debug = "";

  Camera camera;
  
  GameState gameState = new GameState();

  Engine() {
    for (group g : group.values()) // have a arraylist for every group
      groups.put(g, new ArrayList<Entity>());
    camera = new Camera();
    gameState.changeState(state.menu);
    prevTime = millis();
  }

  void run() {
    float mills = millis();
    float dt = mills - prevTime;
    prevTime = mills;

    // input
    input.pollEvents();

    // update
    for (Entity e : entities)
      if (e.updating)
        e.update(dt);
    removeDeadEntities();
    physics.doCollisions();
    removeDeadEntities();

    // draw
    Collections.sort(entities); // ensure we are draw background to foreground

    pushMatrix(); pushStyle();
      background.draw();
    popStyle(); popMatrix();

    pushMatrix();
      camera.shiftView();
      for (Entity e : groups.get(group.game)) {
        if (e.drawLayer.ordinal() <= layer.invisible.ordinal()) break; // no need to draw invisible stuff
        pushMatrix(); pushStyle();
          e.draw();
        popStyle(); popMatrix(); // ensure no graphical settings are transfered
      }
    popMatrix();

    // draw menus
    for (Entity e : groups.get(group.menu)) {
      pushMatrix(); pushStyle();
        e.draw();
      popStyle(); popMatrix(); // ensure no graphical settings are transfered
    }  
    removeDeadEntities();
    
    text(debug, center.x, 0.15*center.y);
    
    gameState.checkLevelChange();
    //println(entities); // DEBUG
  }

  // ====== end main game loop ======



  void removeDeadEntities() {
    for (int i=entities.size()-1; i>=0; --i) { // We are deleting from the array so iterating backwards makes more sense
      Entity e = entities.get(i);
      if (e.dead) removeEntity(e);
    }
  }

  void addEntity(Entity e) {
    entities.add(e);
    for (group g : e.groups) // add the enity to the groups it belongs to
      groups.get(g).add(e);
  }

  void removeEntity(Entity e) {
    e.die();
    entities.remove(e);
    for (group g : e.groups) // remove the enity from the groups it belongs to
      groups.get(g).remove(e);
  }

  // removes all entities that are in the given group.
  void removeEntityGroup(group g) {
    ArrayList<Entity> toRemove = new ArrayList();
    for (Entity e : groups.get(g)) // deep copy
      toRemove.add(e);

    for (Entity e : toRemove)
      removeEntity(e);
    //groups.put(g, new ArrayList<Entity>());  // we shouldn't need this
  }


  /*******************************************************\
  |          Physics. what do think this does?            |
  |                                                       |
  \*******************************************************/
  class Physics {
    // if the objects in the corresponding groups collide, then do a certian action
    Map<group, group> nomNom = new HashMap<group, group>();
    //Map<group, group> keyDies = new HashMap<group, group>();

    Physics() {
      nomNom.put(group.creature, group.creature);
      //keyDies.put(group.bullet, group.levelBounds);
    }

    void doCollisions() {
      /*
      these are quite lengthy versions of saying
      for all in a, if they collide with any of b, do something (kill one of them)
      */
      for (group g : nomNom.keySet()) {
        for (Entity a_ : groups.get(g)) {
          Creature a = (Creature) a_;
          for (Entity b_ : groups.get(nomNom.get(g))) {
            Creature b = (Creature) b_;
            if (a == b) continue; // don't eat yourself! D:

            if (a.collidesWith(b)) {
              // TODO: adjust the rate
              float transfer = PI * pow(// amount OmNomNomed from b by a (the collision area)
                PVector.dist(a.pos, b.pos) - a.radius - b.radius,
                2
              ); 
              
              if (b.isBigger(a))
                transfer *= -1; // transfer the other way
                
              a.addArea( transfer);
              b.addArea(-transfer);
            }
          }
        }
      }
      /*
      for (group g : keyDies.keySet()) {
        for (Entity a : groups.get(g)) {
          for (Entity b : groups.get(keyDies.get(g))) {
            if (a.collidesWith(b)) {
              a.die();
            }
          }
        }
      }*/
    }
    
  }

  /*******************************************************\
  | Handles transitions between game states               |
  |                                                       |
  | It's been moved to a inner class as it is quite a big |
  | chunk of code that is seperate                        |
  \*******************************************************/
  class GameState {

    state currentState = state.gameInit; // use changeState() which does proper job of changing this with safe transitions

    Level level;
    int levelCount = 3;
    final int maxLevel = 3;

    GameState() { }

    void nextLevel() {
      ++levelCount;
      if (levelCount > maxLevel) {
        levelCount = maxLevel;
        debug = "You win.\nThe universe is pretty tiny now";
        return;
      }
      loadLevel(levelCount);
    }

    void checkLevelChange() {
      if (level == null) return;
      
      if (level.winCondition())
        nextLevel();
      else if (level.failCondition())
        changeState(state.gameOver);
    }

    void loadLevel(int levelCount) {
      println("loadlevel: " + levelCount);
      player = null;
      removeEntityGroup(group.player);
      level = new Level(levelCount);
    }

    // has lots of code defining safe transitions and what should be done
    void changeState(state changeTo) {
      boolean wasSafe = true;

      if (currentState == state.gameInit) {
        if (changeTo == state.menu) {
          background = new Background();
          addEntity(new OutOfBounds());
          addEntity(new Menu());
        }
        else wasSafe = false;
      }
      else if (currentState == state.menu) {
        if (changeTo == state.game) {
          removeEntityGroup(group.menu);
          loadLevel(levelCount);
        }
        else wasSafe = false;
      }
      else if (currentState == state.paused) {
        if (changeTo == state.paused) // special case: pausing again toggles back to game
          changeTo = state.game;
        if (changeTo == state.game) {
          removeEntityGroup(group.pauseMenu);
          for (Entity e : groups.get(group.game)) e.updating = true; // unfreeze game
        }
        else if (changeTo == state.menu) {
          resources.sounds.get("transfer").pause();
          removeEntityGroup(group.game);
          removeEntityGroup(group.pauseMenu);
          addEntity(new Menu());
        }
        else wasSafe = false;
      }
      else if (currentState == state.game) {
        if (changeTo == state.paused) {
          for (Entity e : groups.get(group.game))
            e.updating = false; // freeze game
          addEntity(new PauseMenu());
        }
        else if (changeTo == state.gameOver) {
          resources.sounds.get("transfer").pause();
          removeEntityGroup(group.game);
          addEntity(new GameOver());
        }
        else if (changeTo == state.game) {
          resources.sounds.get("transfer").pause();
          removeEntityGroup(group.game);
          loadLevel(levelCount);
        }
        else wasSafe = false;
      }
      else if (currentState == state.gameOver) {
        if (changeTo == state.game) {
          removeEntityGroup(group.menu);
          loadLevel(levelCount);
        }
        else if (changeTo == state.menu) {
          removeEntityGroup(group.menu);
          addEntity(new Menu());
        }
        else wasSafe = false;
      }
      else wasSafe = false;

      if (wasSafe)
        currentState = changeTo;
      else
        println("OMG, you totally did not just try to change from '" +currentState+ "' to '" +changeTo+ "'. I hate you.");
    }
  }
}

