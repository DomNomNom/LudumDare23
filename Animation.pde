class Animation {
  PImage[] images;

  boolean pingPong;

  float animationTime;
  float period = 1000; // milliseconds
  float frameCount; // same as images.length, just as a float
  int frame;

  // Constructor for a single-image animation. file specifies the image file in data/images/
  Animation(String file) {
    images = new PImage[] { loadImage("/data/images/" + file) };
    frameCount = images.length;
  }

  // Constructor for the animation. folder corresponds to a folder containing the images in data/animations/
  Animation(String folder, float period, boolean pingPong) {
    this.pingPong = pingPong;
    this.period = period;
    folder = sketchPath + "/data/animations/" + folder + "/";
    String[] fileNames = sort(new File(folder).list());
    images = new PImage[fileNames.length];
    for (int i=0; i<fileNames.length; ++i)
      images[i] = loadImage(folder + fileNames[i]);
    frameCount = images.length;
  }

  void update(float dt) {
    animationTime += dt;
    while (animationTime >= period) // ensure 0 <= animationTime < period
      animationTime -= period;

    if (pingPong) { // reverse the animation when passing the middle of the period
      frame = floor(animationTime * 2*(frameCount-1)/period);
      if (animationTime >= period/2)
        frame = 2*(images.length-1) - frame;
    }
    else  // start from the beginning when passing the period
      frame = floor(animationTime * frameCount/period);
  }

  void draw() {
    image(images[frame], 0, 0);
  }
}
