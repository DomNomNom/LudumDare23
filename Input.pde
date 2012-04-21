Input input; // this is the global var we are going to use

/****************************************************************\
| Handles key presses and mouse actions                          |
|                                                                |
| There are functions from processing that get called when there |
| is a keyboard/mouse event. They are at the end of this file.   |
\****************************************************************/

class Input {
  PVector mousePos = new PVector(width/2, height/2);
  PVector control = new PVector(0, 0);

  HashMap<String, Integer> keyMap;   // maps actions to keycodes (change this at will)
  HashMap<String, Integer> keyCodes; // maps key litterals to keycodes (don't change this)
  String keyValueSeparator = "=>"; // seperates key/values in the .map files
  int currentKey;

  Input() {
    initKeyCodes();
    initKeyMap();
  }

  boolean isEvent(String event) { // small funtion to save the coder some typing
    return currentKey == keyMap.get(event);
  }

  void handleKeyEvent(int keyCode, int pressDir) {
    currentKey = keyCode;

    if (! keyMap.containsValue(keyCode)) //return; // ignore keys that aren't in the bindings
      println("Unboud keyCode: " + keyCode);

    // these want to be tested regardless of whether it is a key up or down event
    if (handleMovementKeys(pressDir)) return;

    // these are specific to key down events.
    if (pressDir == 1) { // keyDown event
      if (isEvent("pause"))
        engine.gameState.changeState(state.paused); // changeState is smart enough to unpause if paused
      else if (isEvent("select")) {
        if (engine.gameState.currentState == state.menu)
          engine.gameState.changeState(state.game);
        else if (engine.gameState.currentState == state.paused)
          engine.gameState.changeState(state.menu);
      }
    }
  }

  // Handles player movement keys. returns true iff the current key is a movement key.
  boolean handleMovementKeys(int pressDir) {
    //println(keyCode + " " + pressDir);
         if (isEvent("up"   )) control.y -= pressDir;
    else if (isEvent("down" )) control.y += pressDir;
    else if (isEvent("left" )) control.x -= pressDir;
    else if (isEvent("right")) control.x += pressDir;
    else return false;
    return true;
  }

  void initKeyMap() {
    keyMap = new HashMap<String, Integer>();
    for (String line : loadStrings("data/keyBindings.map")) {
      int sepPos = line.indexOf(keyValueSeparator);
      if (sepPos != -1) { // if it is a valid line
        keyMap.put(
          line.substring(0, sepPos),
          keyCodes.get(line.substring(sepPos+keyValueSeparator.length()))
        );
      }
    }
  }

  void initKeyCodes() {
    keyCodes = new HashMap<String, Integer>();
    for (String line : loadStrings("data/keyCodes.map")) {
      int sepPos = line.indexOf(keyValueSeparator);
      if (sepPos != -1) { // if it is a valid line
        keyCodes.put(
          line.substring(0, sepPos),
          Integer.parseInt(line.substring(sepPos+keyValueSeparator.length()))
        );
      }
    }
  }
}

void mouseMoved() {
  input.mousePos.x = mouseX;
  input.mousePos.y = mouseY;
}

void mousePressed() {
  if (engine.player != null) engine.player.shoot();
}

void keyPressed()  { input.handleKeyEvent(keyCode,  1); }
void keyReleased() { input.handleKeyEvent(keyCode, -1); }
