class MysteryBox extends MovingObject {
  PImage life = loadImage("box.png");
  MysteryBox(PVector pos){
    super(pos);
    life.resize(40,40);
    radius = life.width/2;
  }

  void drawMe(){
      pushMatrix();
      translate(pos.x,pos.y);
      image(life,-life.width/2,-life.height/2);
      popMatrix();
  }
}
