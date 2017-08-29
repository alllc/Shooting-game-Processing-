class Player extends MovingObject {
  //use PImage to store an image
  int currentFrame=0;
  PImage[] frames;

  int countdown;
  ArrayList<Bullet> bullets;
  //control fire
  int fireTimer = 0;
  int invincibleTimer = 60;
  int life;
  int score = 0;
  int velX, velY;  
  int timer = 240;
  int level = 1;
  int power = 20;
  PImage levelUp = loadImage("level.png");
  PImage rewardImage = loadImage("reward.png");
  //a constructor to initialize the fields above with initial values
  Player (PVector pos){
    super(pos);
    frames = standing;
    bullets = new ArrayList<Bullet>();
    radius = 20;
    life = 3;
    frames = standing;
    levelUp.resize(100,80);
    rewardImage.resize(100,100);
    PImage sheet = loadImage("fewalk.png");
    
    //walking left
    for (int i = 0; i < walkingLeft.length; i++) {
    //walking[i] = loadImage("panwalk_" + i + ".png");
   
      PImage tile = createImage(128, 128, ARGB);
      tile.copy(sheet, i*128, 0, 128, 128, 0, 0, 128, 128);
      
      walkingLeft[i] = tile;
          tile.resize(80,80);
    }
    
    //walking right
    for (int i = 0; i < walkingRight.length; i++) {
    //walking[i] = loadImage("panwalk_" + i + ".png");
   
      PImage tile = createImage(128, 128, ARGB);
      tile.copy(sheet, i*128, 128, 128, 128, 0, 0, 128, 128);
      
      walkingRight[i] = tile;
          tile.resize(80,80);
    }
    
    //walking down
    for (int i = 0; i < walkingDown.length; i++) {
    //walking[i] = loadImage("panwalk_" + i + ".png");
   
      PImage tile = createImage(128, 128, ARGB);
      tile.copy(sheet, i*128, 256, 128, 128, 0, 0, 128, 128);
      
      walkingDown[i] = tile;
          tile.resize(80,80);
    }
    //walking up
    for (int i = 0; i < walkingUp.length; i++) {
    //walking[i] = loadImage("panwalk_" + i + ".png");
   
      PImage tile = createImage(128, 128, ARGB);
      tile.copy(sheet, i*128, 384, 128, 128, 0, 0, 128, 128);
      
      walkingUp[i] = tile;
          tile.resize(80,80);
    }

    standing[0] = walkingLeft[0];
    vel = new PVector(); 
    //        for (int i = 0; i < shooting.length; i++) {
    //            walking[i] = loadImage("images/shooting" + i + ".jpg");
    //        }
  }
  
  //fire method
  void fireBullet() {
    if (fireTimer == 0) {
        bullets.add( new Bullet(new PVector(pos.x, pos.y), new PVector(velX, velY), power, bullets) );
        fireTimer = 20   ;
    }
    fireTimer--;
  }
    // If player gets hit
  void hit() {
    if (invincibleTimer == 0) {        // if not invincible
        life--;
        invincibleTimer = 60;          // wait for one sec
    }
  }
   void levelUpImage(){
     if(timer != 0){
         pushMatrix();
         translate(pos.x,pos.y);
        image(levelUp, -levelUp.width/2, -levelUp.height/2);
        popMatrix();
        timer --;
     }
  }
  void rewardImageDisplay(){
        pushMatrix();
        translate(pos.x,pos.y-100);
        image(rewardImage, -rewardImage.width/2, -rewardImage.height/2);
        popMatrix();
  }
   void reward(){
    switch(reward){
    case 1:
    power += 2;
    break;
    case 2:
    life += 1;
    break;
    default:
    score += (int)random(50,500);
    break;
    }
  }

  
  
  void update() {
    for (int i = 0; i < bullets.size(); i++) {
        Bullet m = bullets.get(i);
        m.update();
        m.drawMe();
        
       for (int j = 0; j < enemies.size(); j++) {
        Enemy e = enemies.get(j);
        if (m.collision(e) && m.life > 0) {
          m.life = 0;
          e.health --;
          if (e.health == 0) {
            score +=50;
            enemies.remove(e);
            
          }
        }
      } 

    }
    
    super.update();
    if (invincibleTimer > 0) {
        if (invincibleTimer % 2 == 0) {
            drawMe();
        }
        invincibleTimer--;
    } else {
        drawMe();
    }
   //player can't move out the screen

    if (frameCount % 9 == 0) {
      currentFrame++;

      println(currentFrame);

      switch (state) {
        //walking
      case 1:
        if (currentFrame == walkingLeft.length) {
          currentFrame = 0;
        }
        velX = -5;
        velY = 0;
        changeFrame(walkingLeft);
        break;
      case 2:
        if (currentFrame == walkingRight.length) {
          currentFrame = 0;
        }
        velX = 5;
        velY = 0;
        changeFrame(walkingRight);
        break;
      case 3:
        if (currentFrame == walkingDown.length) {
          currentFrame = 0;
        }
        velX = 0;
        velY = 5;
        changeFrame(walkingDown);
        break;
      case 4:
        if (currentFrame == walkingUp.length) {
          currentFrame = 0;
        }
        velX = 0;
        velY = -5;
        changeFrame(walkingUp);
        break;
        //            case ...
      default:
        currentFrame = 0;
        changeFrame(standing);
        break;
      }
    }
  }
    void changeFrame(PImage[]list) {
    //the PImage reference for character is now
    //the frame in the list we want
    frames = list;
  }
  void drawMe(){
    fill(63);
    pushMatrix();
    translate(pos.x,pos.y-20);
    PImage img = frames[currentFrame];

    image(img, -img.width/2, -img.height/2);
    
    popMatrix();
  }
}
