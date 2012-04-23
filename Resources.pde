/**************************************************\
| A class that holds together big data resources   |
| that may be used by multiple objects.            |
| Example: Multiple bullets can use the same image |
\**************************************************/

class Resources {
  Map<String, Animation  > animations = new HashMap<String, Animation  >();
  Map<String, PFont      > fonts      = new HashMap<String, PFont      >();
  Map<String, AudioPlayer> sounds     = new HashMap<String, AudioPlayer>();
  
  Resources() {
    animations.put("player", new Animation("player_0", 7, 1000, true));
    animations.put("mover", new Animation("mover.png"));

    fonts.put("pauseLabel", loadFont("fonts/CharterBT-Italic-48.vlw"));

    sounds.put("transfer", minim.loadFile("audio/mused.wav"));
    
    sounds.put("background", minim.loadFile("audio/background.wav"));
    sounds.get("background").loop();
    
  }

  // stop all audio
  void stop() {
    for (AudioPlayer p : sounds.values())
      p.close();
  }  
}
