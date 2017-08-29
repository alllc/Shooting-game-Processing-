import ddf.minim.*;//import music 
//assign speed for movement
float speed = 2;
PVector upForce = new PVector(0, -speed);
PVector downForce = new PVector(0, speed);
PVector leftForce = new PVector(-speed, 0);
PVector rightForce = new PVector(speed, 0);
boolean up, down, left, right,fire,restart;

KeyHolder h ;
Player player;
Enemy e;
MysteryBox box;

//variables for audio
AudioPlayer song;
Minim minim;

//ainimation for walking
PImage[] standing = new PImage[1];
PImage[] walkingLeft = new PImage[4];
PImage[] walkingRight = new PImage[4];
PImage[] walkingDown = new PImage[4];
PImage[] walkingUp = new PImage[4];
int state = 0;


int reward = 0;

//making list
ArrayList<Tile> tiles = new ArrayList<Tile>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Enemy> enemies = new ArrayList<Enemy>(); // List containing all the enemies
ArrayList<MysteryBox> rewardbox = new ArrayList<MysteryBox>(); // List containing all the enemies

//some num setting
int addEnemy = 300;
int enemySize = 5;
int tileSize = 40;
int timer = 0;
//PVector tileBounds;

int[][] map = new int[31][16];

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {left = true;    state = 1;}
    else if (keyCode == RIGHT) {right = true;    state = 2;}
    else if (keyCode == UP) {up = true; state = 4;}
    else if (keyCode == DOWN) {down = true; state = 3;}
  }
  else{
    if(key == ' '){fire = true;}
    if(key =='r' || key == 'R'){restart = true;}
  }
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {left = false;    state = 1;}
    else if (keyCode == RIGHT) {right = false;    state = 2;}
    else if (keyCode == UP) {up = false;    state = 4;}
    else if (keyCode == DOWN) {down = false;    state = 3;}
  }
  else {
    if ( key == ' '){fire = false; }
    if (key =='r' || key == 'R'){restart = false;}
  }
}

void setup() {
  size(1200, 600);
  stroke(200);
  strokeWeight(2);
  fill(63);
    boolean block;
  //this code will loop the 2d map array and generate some objects 1 is a box, 0 is grass
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      //if we are not on the edge of the map
      if (i != 0 && j !=0 && i != map.length - 1 && j != map[i].length - 1) {
        //randomly decide to place block or grass, 1/6 chance of a block
        if (random(0, 6) < 1) {
          map[i][j] = 1;
          block = true;
        } 
        else {
          map[i][j] = 0;
          block = false;
        }
        //on the edges of the map place blocks
      } 
      else {
        map[i][j] = 1;
        block = true;
      }

      String path = "img/levels/tile" + map[i][j] + ".jpg";
      //third argument is the map value, true means it will be a block tile, false means a grass tile (won't block player)
      tiles.add(new Tile(path, new PVector(i * tileSize, j * tileSize), block));

    }
  }

  //your character must start on a tile that is not on the edge and also not a block
  //assign random spot for player
    Tile playerStart = tiles.get(int(random(0,tiles.size())));
    // if statement does not work this time. so i tried with while statement
    while (playerStart.block!=false) {
      playerStart = tiles.get(int(random(0,tiles.size())));
    }
    player = new Player(new PVector(playerStart.pos.x, playerStart.pos.y));
    
    //assign random spot for fire
    Tile firePoint = tiles.get(int(random(0,tiles.size())));
    while (firePoint.block!=false) {
      firePoint = tiles.get(int(random(0,tiles.size())));
    }
    h = new KeyHolder(new PVector(firePoint.pos.x, firePoint.pos.y));

//song
  minim = new Minim(this);
  song = minim.loadFile("background-music.mp3");
  song.loop();
}

void draw() {
  
  //intro screen
  if (timer<300) {
    introduction();
    timer++;
  }
  else{
  background(255);
  if (left) player.move(leftForce);
  if (right) player.move(rightForce);
  if (up) player.move(upForce);
  if (down) player.move(downForce);
  if (fire) player.fireBullet();
   
   //drawing tile and wall collision
  for (int i = 0; i < tiles.size(); i++) {
    Tile t = tiles.get(i);
    if (t.wall(player)) {
       player.vel.mult(0.0);
    }
    if (t.wall(h)) {
       h.vel.mult(0.0);
    }
    if (t.inWindow()) {
      t.drawMe();
    }
  }
   player.update();
    

    //adding reward box every 30 second
    if(frameCount % 1800 == 0){
      Tile boxPoint = tiles.get(int(random(0,tiles.size())));
      while (boxPoint.block!=false) {
        boxPoint = tiles.get(int(random(0,tiles.size())));
      }
      rewardbox.add(new MysteryBox(new PVector(boxPoint.pos.x, boxPoint.pos.y)));   
    } 
    for(int i = 0; i < rewardbox.size();i++){
      MysteryBox box = rewardbox.get(i);
      box.update();
      box.drawMe();
       if(box.collision(player)){
        rewardbox.remove(i);
        player.reward();
        player.rewardImageDisplay();
        reward = (int)random(0,3);

      }
    }
    
    //adding enemy every 10 seconds
    if(frameCount % addEnemy == 0){
      Tile startTile = tiles.get(int(random(0,tiles.size())));
      while(startTile.block!=false) {
        startTile = tiles.get(int(random(0,tiles.size())));
      }
        enemies.add(new Enemy(new PVector(startTile.pos.x, startTile.pos.y)));
    } 


   for (int i = 0; i < enemies.size(); i++) {
    Enemy e = enemies.get(i);
    e.update();
    e.drawMe();
       if(e.collision(player)){
        player.hit();
      }
    }
    
   //draw fireball
   h.update();
   h.drawMe(); 
   if(h.collision(player)){
      nextLevel();    
      player.levelUpImage();      
      }

  drawHUD();

//result
  if(player.life <= 0 ){
    gameOver();
    if(restart){
        replay();
    }
   }
   
   if(player.level == 100){
       win();
  }
  }
}

void replay(){
  setup();
}

void win(){
    background(255);
   text("You win!", width/2 - 40, height/2-20);
  text("Your score is " + player.score, width/2 - 80, height/2);
  text("Press R to restart", width/2 - 60, height/2+20);
}
void gameOver() {
  background(255);
  text("Game Over", width/2 - 40, height/2-20);
  text("Your score is " + player.score, width/2 - 80, height/2);
  text("Press R to restart", width/2 - 60, height/2+20);
}

void drawHUD() {

  textSize(18);
  text("SCORE: " + player.score,  20, 40);
  text("Life: " + player.life, 20, 60);
  text("Level: " + player.level, 20, 80);
  text("Shooting distance: " + player.power, 20, 100);

}


void nextLevel(){
    Tile firePoint = tiles.get(int(random(0,tiles.size())));
    if (firePoint.block==false) {
      h = new KeyHolder(new PVector(firePoint.pos.x, firePoint.pos.y));
    }
    player.score += 1000;
    player.level += 1;
    enemySize += 1;
    addEnemy -= 10;
 }
  
// set the introduction page
void introduction() {
  background(0);
  fill(255);
  text("Introduction:", 30, 100);
  text("One fire represent a level. Collecting 100 fires to win the game.", 30, 120);
  text("You are the person in the game. ", 30, 140);
  text("You should press 4 “arrows” of direction in order to escape all ghost that moving aournd the map. ", 30, 160);
  text("You can press “space” to shoot bullets to kill the enemies. ", 30, 180);
  text("You can view your information on the top left of screen.", 30, 200);
  text("Enemy will appear every 5 seconds, and a mystery box will appear every 30 seconds.", 30, 220);
  text("Mystery box contains free point, life, and shooting distance.", 30, 240);
  text("Remember, the hight level you get, the faster ghost will appear.", 30, 260);
  text("Good Luck !", 30, 360);
}
    
