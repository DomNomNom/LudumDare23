enum layer { // listed foreground - background
  invisible, // this and any layer listed before this will not be drawn.
  menu,
  player,
  bullet,
  enemy,
  background,
}

// States that the game can be in
enum state {
  gameInit,
  menu,
  paused,
  game,
}

// groups that an entity can be in. they are not mutually exclusive.
enum group {
  background,
  game,
  player,
  bullet,
  enemy,
  levelBounds,
  menu,
  pauseMenu,
}
