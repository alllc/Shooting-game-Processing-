class KeyHolder extends MovingObject {
  float angle = PI;
  int dir = 1;
  int health;
  int countdown;
  PImage[] walking = new PImage[4];
  int currentFrame=0;
  int tileWidth = 77;
  int tileHeight =156;
  boolean alive = true;
  int radius = 20;

  KeyHolder(PVector pos){
    super(pos);
    health = 2;

    PImage sheet = loadImage("fire.png");
    for (int i = 0; i < walking.length; i++) {
      
      PImage tile = createImage(tileWidth, tileHeight, ARGB);
      tile.copy(sheet, i*tileWidth, 0, tileWidth, tileHeight, 0, 0, tileWidth, tileHeight);

      walking[i] = tile;
    }
  }
  void update() {  
    pos.add(vel);
    angle += 0.04 * dir; 
    if ( random(0, 16) < 1) {
      dir *= -1; 
    }
    vel.set(0.5* cos(angle),  0.5* sin(angle));  
    if (frameCount % 10 == 0) {
      currentFrame++;
    }
    if (currentFrame == walking.length) {
      currentFrame = 0;
    }
    if (pos.x + walking[currentFrame].width < 0) 
      pos.x = width+walking[currentFrame].width;
  }
  



  void drawMe() {
    pushMatrix();
    translate(pos.x, pos.y);
    //scale(-1, 1);
    PImage img = walking[currentFrame];
    image(img, -img.width/2, -img.height/2);
    popMatrix();
  }
}
