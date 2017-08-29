class Bullet {
  PVector pos, vel;
  int radius;
  int life;
  ArrayList list; // A list of all the bullets fired by the UFO. This is used to remove this missile from the list.
  
  PImage [] firing = new PImage [9];
  int currentFrame = 0;
  int tileWidth = 128;
  int tileHeight = 128;
  
  Bullet(PVector pos, PVector vel, int life, ArrayList list) {
    this.pos = pos;
    this.vel = vel; 
    this.life = life;
    this.list = list;
    PImage sheet = loadImage("fire_explosion.png");
    for (int i = 0; i < firing.length; i++) {
      
      PImage tile = createImage(tileWidth, tileHeight, ARGB);
      tile.copy(sheet, i*tileWidth, 0, tileWidth, tileHeight, 0, 0, tileWidth, tileHeight);
      
      firing[i] = tile;
      tile.resize(40,40);
    }
  }
  
  // check collion between this missile and other moving object
  boolean collision(MovingObject other) {
    if (dist(pos.x, pos.y, other.pos.x, other.pos.y) < other.radius) {
      return true;
    }
    return false;
  }
  
  // update by destroying off-screen objects and collided objects 
  void update() {
    pos.add(vel);
    if (pos.y < 0) { // If off the screen, life is -1. Setting to -1 stops it from creating an explosion when it leaves the screen
      life = -1;
    }
    if (pos.y > height){
      life = -1;
    }
    if (pos.x < 0){
      life = -1;
    }
    if (pos.x > width){
      life = -1;
    }
    life--;
        if (frameCount % 5 == 0) {
      currentFrame++;
    }
    if (currentFrame == firing.length) {
      currentFrame = 0;
    }
    if (pos.x + firing[currentFrame].width < 0) 
      pos.x = width+firing[currentFrame].width;
  }
  
  // Draw the missile
  void drawMe() {
    if (life > 0) {
    pushMatrix();
    translate(pos.x, pos.y);
    //scale(-1, 1);
    PImage img = firing[currentFrame];
    image(img, -img.width/2, -img.height/2);
    popMatrix();
    }
  }
}
