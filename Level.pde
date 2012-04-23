class Level {
  String keyValueSeparator = ":";
  
  Level(int levelName) {
    
    boolean hasPlayer = false;
    
    for (String line : loadStrings("data/levels/" +levelName+ ".level")) {
      int sepPos = line.indexOf(keyValueSeparator);
      if (sepPos != -1) { // if it is a valid line
        String[] keyValue = line.split(":");
        String key = keyValue[0];
        String[] values = keyValue[1].split(",");
        
        if (key.equals("P")) { // player
          if (hasPlayer) 
            println("PLAYER REDEFINED!!!");
          else {
            hasPlayer = true;
            addPlayer(new Player(
              Float.parseFloat(values[0]), 
              Float.parseFloat(values[1]), 
              Float.parseFloat(values[2])
            ));
          }
        }
        else { // we have a Mover
          int targetPriority = Integer.parseInt(key);
          println(values.length);
          if (values.length == 3) {
            engine.addEntity(new Mover(
              Float.parseFloat(values[0]),
              Float.parseFloat(values[1]),
              Float.parseFloat(values[2])
            ));
          }
          else {
            engine.addEntity(new Mover(
              Float.parseFloat(values[0]),
              Float.parseFloat(values[1]),
              Float.parseFloat(values[2]),
              Float.parseFloat(values[3]),
              Float.parseFloat(values[4])
            ));
          }
        }
      }
    }
    
    if (!hasPlayer) {
      println("PLAYER NOT DEFINED!!!");
      addPlayer(new Player(350, 300, 50));
    }
  }
  
  boolean winCondition() {
    List<Entity> creatures = engine.groups.get(group.creature);
    if (creatures.size() == 1)
      return (creatures.get(0) == engine.player);
    return false;
  }
  
  boolean failCondition() {
    return (
      (engine.gameState.currentState == state.game) && 
      (engine.player == null || engine.player.dead)
    );
  }
  
  void addPlayer(Player p) {
    engine.player = p;
    engine.addEntity(p);
  }
}

