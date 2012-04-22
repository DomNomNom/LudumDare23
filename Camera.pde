class Camera {
  
  float scaleFactor;
  
  Camera() { }
  
  void shiftView() {
    if (engine.player == null) return;

    scaleFactor = engine.player.scaleFactor;
    
    PVector translation = PVector.sub(center, engine.player.pos); // deep copy and opposite direction
    PVector lookahead = PVector.mult(engine.player.vel, -500);
    translation.add(lookahead);
    translation.mult(scaleFactor);
    
    translate(translation.x, translation.y);
    
    // scale from the center
    translate(center.x, center.y);
      scale(scaleFactor);
    translate(-center.x, -center.y);
  }
}
