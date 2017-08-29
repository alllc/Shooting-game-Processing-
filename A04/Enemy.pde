class Enemy extends MovingObject {
  PImage enemy = loadImage("ghost.png");
  float angle = 0;
  int dir = 1;
  int health;
  int countdown;
  boolean alive = true;
  
  Enemy(PVector pos){
    super(pos);
    health = 5;
    enemy.resize(40,40);
    radius = enemy.width/2;
    float angle = -PI/4;
    int dir = 1;
  }
  void update() {  
    pos.add(vel);
    angle += 0.04 * dir; 
    if ( random(0, 16) < 1) {
      dir *= -1; 
    }
    vel.set(0.5* cos(angle),  0.5* sin(angle));  
    if(pos.x > width){
      pos.x=0;
    }
    if(pos.x < 0){
      pos.x = width;
    }
    if(pos.y > height){
      pos.y = 0;
    }
    if(pos.y < 0){
      pos.y = height;
    }
    
  }

  
  void drawMe(){
      pushMatrix();
      translate(pos.x,pos.y);
      image(enemy,-enemy.width/2,-enemy.height/2);
      popMatrix();
  }
}
