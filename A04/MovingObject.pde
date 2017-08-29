class MovingObject{
  //fields
  PVector pos, vel, acc, dim;
  float radius;
  float damp = 0.8; //constant damping factor
  

  //a constructor to initialize the fields above with initial values
  MovingObject(PVector pos) {
    this.pos = pos;
    vel = new PVector(); //must create instance
    acc = new PVector();
    dim = new PVector(36, 36);
  }
  //move method, PVector force as parameter, add to acceleration
  void move(PVector force) {
    vel.add(force);
  }
 
  //collision between moving object
  boolean collision(MovingObject other) {
      if (dist(pos.x, pos.y, other.pos.x, other.pos.y) < radius + other.radius) {
          return true;
      }
      return false;
  }
  
  //update the physics for the character
  void update() {
    vel.add(acc); //add acceleration to velocity
    vel.mult(damp); //multiply velocity by dampening factor
    pos.add(vel); //moves character
    acc.set(0, 0, 0); //clear the acceleration for the next loop
  }

  void draw() {
    ellipse(tileSize+dim.x/2, tileSize+dim.y/2, dim.x, dim.y);
  }
}
