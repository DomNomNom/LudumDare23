/****************************************************************\
| Has the defenition of main game loop and pulls things together |
|                                                                |
| Contains two inner classes: Physics and GameState              |
\****************************************************************/

class Engine {
  // entity handling
  Player player;
  Physics physics = new Physics();
  private ArrayList<Entity> entities = new ArrayList<Entity>();
  private HashMap<group, ArrayList<Entity>> groups = new HashMap<group, ArrayList<Entity>>();
  float prevTime;

  GameState gameState = new GameState();

  Engine() {
    for (group g : group.values()) // have a arraylist for every group
      groups.put(g, new ArrayList<Entity>());
    gameState.changeState(state.menu);
    prevTime = millis();
  }

  void run() {
    float mills = millis();
    float dt = mills - prevTime;
    prevTime = mills;

    physics.doCollisions();

    // update and remove
    for (int i=entities.size()-1; i>=0; --i) { // We are deleting from the array so iterating backwards makes more sense
      Entity e = entities.get(i);
      if (e.updating) {
        e.update(dt);
      }
      if (e.dead) removeEntity(e);
    }

    // draw
    Collections.sort(entities); // ensure we are draw background to foreground
    for (Entity e : entities) {
      if (e.drawLayer.ordinal() <= layer.invisible.ordinal()) break; // no need to draw invisible stuff
      pushMatrix(); pushStyle();
        e.draw();
      popStyle(); popMatrix(); // ensure no graphical settings are transfered
    }
    //println(entities); // DEBUG
  }

  void addEntity(Entity e) {
    entities.add(e);
    for (group g : e.groups) // add the enity to the groups it belongs to
      groups.get(g).add(e);
  }

  void removeEntity(Entity e) {
    entities.remove(e);
    for (group g : e.groups) // remove the enity from the groups it belongs to
      groups.get(g).remove(e);
  }

  // removes all entities that are in the given group.
  void removeEntityGroup(group g) {
    entities.removeAll(groups.get(g));
    groups.put(g, new ArrayList<Entity>());
  }


  /*******************************************************\
  |          Physics. what do think this does?            |
  |                                                       |
  \*******************************************************/
  class Physics {
    // if the objects in the corresponding groups collide, then do a certian action
    Map<group, group> bothDie = new HashMap<group, group>();
    Map<group, group> keyDies = new HashMap<group, group>();

    Physics() {
      bothDie.put(group.bullet, group.enemy);
      keyDies.put(group.bullet, group.levelBounds);
    }

    void doCollisions() {
      /*
      these are quite lengthy versions of saying
      for all in a, if they collide with any of b, do something (kill one of them)
      */
      for (group g : bothDie.keySet()) {
        for (Entity a : groups.get(g)) {
          for (Entity b : groups.get(bothDie.get(g))) {
            if (a.collidesWith(b)) {
              a.die();
              b.die();
            }
          }
        }
      }
      for (group g : keyDies.keySet()) {
        for (Entity a : groups.get(g)) {
          for (Entity b : groups.get(keyDies.get(g))) {
            if (a.collidesWith(b)) {
              a.die();
            }
          }
        }
      }
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

    GameState() { }

    // has lots of code defining safe transitions and what should be done
    void changeState(state changeTo) {
      boolean wasSafe = true;

      if (currentState == state.gameInit) {
        if (changeTo == state.menu) {
          addEntity(new Background());
          addEntity(new OutOfBounds());
          addEntity(new Menu());
        }
        else wasSafe = false;
      }
      else if (currentState == state.menu) {
        if (changeTo == state.game) {
          player = new Player(300, 200);
          addEntity(player);
          addEntity(new Mover(100, 100));
          addEntity(new Mover(250, 200));
          removeEntityGroup(group.menu);
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
          removeEntityGroup(group.game);
          removeEntityGroup(group.pauseMenu);
          addEntity(new Menu());
        }
        else wasSafe = false;
      }
      else if (currentState == state.game) {
        if (changeTo == state.paused) {
          for (Entity e : groups.get(group.game)) e.updating = false; // freeze game
          addEntity(new PauseMenu());
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

