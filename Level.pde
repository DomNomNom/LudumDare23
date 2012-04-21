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
              Float.parseFloat(values[1])
            ));
          }
        }
        else { // we have a Mover
          int targetPriority = Integer.parseInt(key);
          engine.addEntity(new Mover(
            Float.parseFloat(values[0]),
            Float.parseFloat(values[1]),
            Float.parseFloat(values[2])
          ));
        }
      }
    }
    
    if (!hasPlayer) {
      println("PLAYER NOT DEFINED!!!");
      addPlayer(new Player(350, 300));
    }
  }
  
  void addPlayer(Player p) {
    engine.player = p;
    engine.addEntity(p);
  }
}

