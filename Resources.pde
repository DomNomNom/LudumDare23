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
    animations.put("bullet", new Animation("bullet.png"));
    animations.put("player", new Animation("player", 1000, true));

    fonts.put("pauseLabel", loadFont("fonts/CharterBT-Italic-48.vlw"));

    sounds.put("shot", minim.loadFile("audio/shot.wav"));
  }

  // stop all audio
  void stop() {
    for (AudioPlayer p : sounds.values())
      p.close();
  }  
}
