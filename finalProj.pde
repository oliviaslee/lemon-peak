/*
  DESINV23 final project
  Lemon Peak - candy animation game

  Olivia Lee, Crystal Chang
  Apr 19 2019
*/
import processing.serial.*;
import cc.arduino.*;
import org.firmata.*;
import processing.sound.*;
SoundFile file;
Serial port;
int lf = 10;

//color palette 
int[] colorPalette = {#FCD1FC, #D1ECFC, #AAEACB, #EAAAB2, #FFCB93};
int numColors = 5; 

color c1, c2;

double counter = 0;
int score = 0;
int difficulty = 2, track = 0; //use to populate unique number of enemies
boolean delay = false;
float dTrack;

float tX, tY; //target coordinates

boolean startGame, playGame, populated, threading;

PImage welcome, start;

//
ArrayList<Candy> candies;
ArrayList<Integer> hitCandies;
ArrayList<Props> scene;
ArrayList<Props> pellets;
ArrayList<PVector> projDir;
String[] bulletLibrary = {"bulletBlue.png", "bulletGreen.png", "bulletOrange.png", "bulletPink.png"};
int pIndex, pMax = 4, pSpeed = 4, cSpeed = 1;

//arduino setup analog values 
//int[] analog = {0,1,2,3};
//int[] output;

//sound effects
ArrayList<SoundFile> soundLibrary;

void setup() {
  //size(1425, 850, P3D); //dimensions fitting for macbook pro 13.3"
  fullScreen(P2D);
  background(255);
  
  port = new Serial(this, "/dev/cu.usbmodem14301", 9600);
  port.bufferUntil(lf);
  
  //bg gradient colors
  c1 = color(#EECAE0);
  c2 = color(#6FB6E4);
  
  candies = new ArrayList();
  hitCandies = new ArrayList();
  scene = new ArrayList();
  pellets = new ArrayList();
  projDir = new ArrayList();
  soundLibrary = new ArrayList();
  
  startGame = true;
  
  welcome = new PImage(); start = new PImage();
  welcome = loadImage("lemon_logo_blurred2.png");
  start = loadImage("start_button.png");
  
  loadMusic();
  soundLibrary.get(1).loop();
}

void draw() {
  background(255);
  counter += 0.05;
  
  if (startGame) {
    drawLanding(counter);
  } else if (playGame) {
    pushMatrix();
      setGradient(0, 0, width, height, c1, c2);
    popMatrix();
    renderGamePlay();
    trackPellets();
  }
  //tracks if a enemy candy is hit
  if (hitCandies.size() > 0 && candies.size() > 0) {
    handleHit();
  }
}

void mouseClicked() {
  if (startGame 
      && mouseX >= width/2 - welcome.width/2 
      && mouseX <= width/2 + welcome.width/2
      && mouseY >= height/2 - welcome.height/2
      && mouseY <= height/2 + welcome.height/2) {
    
    startGame = false;
    playGame = true;
  }
}

//toggling start of game
//handles target moves and shooting
void keyPressed() {
  if (playGame) {
    if (keyCode == LEFT) {tX-=40;}
    if (keyCode == RIGHT) {tX+=40;}
    if (keyCode == UP) {tY-=40;}
    if (keyCode == DOWN) {tY+=40;}
    
    if (key == ENTER || key == RETURN) {
      shoot();
      //println("attempt to shoot pellet");
    }
  }
}

//landing page helper functions
void drawLanding(double move) {
  //draws diagonal lines with rotating color palette 
  pushStyle();
  strokeWeight(15);
    for (int i = 0; i < 35; i++) { 
      stroke(colorPalette[(i + (int)move) % numColors]);
      line(80*i, 0, 0, 58*i);
    }
  popStyle();
  
  if (startGame) {
    pushMatrix();
    pushStyle();
      translate(0, -start.height);
      imageMode(CENTER);
      image(welcome,width/2, height/2);
      image(start, width/2, height/2 + start.height*5/2);
    popStyle();
    popMatrix();
  }
  drawBorder(colorPalette[0]);
}

void drawBorder(int hex) {
  pushMatrix();
    pushStyle();
      strokeWeight(20);
      stroke(hex);
      translate(5,5);
      line(0, 0, width, 0);
      line(0, 0, 0, height);
      translate(-10,-10);
      line(width, 0, width, height);
      line(0, height, width, height);
    popStyle();
  popMatrix();
}

//initialized game play
void renderGamePlay() {
  if (!populated) {
    populateGame();
    populated = true;
  }
  if (track < difficulty && !delay) {
    track++;
    LemonHead lemon = new LemonHead();
    candies.add(lemon);
  }
  //adds slight delay buffer between populating new lemon head
  if (delay) {
    dTrack++;
    if (dTrack == 300) {
      delay = false; dTrack = 0;}
  }
  // hardcode rendering for mountains
  for (int i = 0; i < 2; i++) {
    Props p = scene.get(i);
    p.render();  
  }
  //renders existing candies
  for (int i = 0; i < candies.size(); i++) {
    candies.get(i).move();
    candies.get(i).render();
  }
  //renders moving clouds
  for (int i = 2; i < scene.size(); i++) {
    Props p = scene.get(i);
    if (p.type() == "cloud") {
      p.move(cSpeed, 0);
    }
    p.render();  
  }
  scoreboard();
  target();
}

// modification of https://processing.org/examples/lineargradient.html
void setGradient(int x, int y, float w, float h, color c1, color c2) {
  // Top to bottom gradient
  for (int i = y; i <= y+h; i++) {
    float inter = map(i, y, y+h, 0, 1);
    color c = lerpColor(c1, c2, inter);
    stroke(c);
    line(x, i, x+w, i);
  }
}

void populateGame() {
  Props mnt = new Props(width/6, height*3/5); Props mnt1 = new Props(width*4/5, height*3/5);
  Props cloud = new Props("cloud"); Props cloud1 = new Props("cloud");
  Props scoreboard = new Props("scoreboard"); 
  
  mnt.resizeP(947*2/3, 1271*2/3);mnt1.resizeP(870*2/3, 1270*2/3);
  cloud.resizeP(759/2, 480/2); cloud1.resizeP(1647/3, 1040/3);
  
  mnt.setImage("hillLeft.png"); mnt1.setImage("hillRight.png");
  cloud.setImage("solidCloud.png"); cloud1.setImage("clearCloud.png");
  scoreboard.setImage("total.png"); scoreboard.sb();
  
  scene.add(mnt); scene.add(mnt1);
  scene.add(cloud); scene.add(cloud1); 
  scene.add(scoreboard);
}

void target() {
  pushStyle();
    pushMatrix();
      stroke(#BC3B3B);
      strokeWeight(2);
      noFill();
      ellipseMode(CENTER);
      ellipse(tX, tY, 75, 75);
      line(tX - 75/2, tY, 75/2 + tX, tY);
      line(tX, tY - 75/2, tX, 75/2 + tY);
    popMatrix();
  popStyle();
}

void shoot() {
  Props p = new Props(width/2,height);
  // iterate through different bullet colors
  p.setImage(bulletLibrary[pIndex % pMax]);
  pIndex++;
  p.resizeImg(58, 50);
  pellets.add(p);
  
  // store angle at which pellet is shot 
  projDir.add(dirGen(tX,tY,p.xCor(),p.yCor()));
  
  trackPellets();
}

// generates images for shot pellets
void trackPellets() {
  for (int i = 0; i < pellets.size(); i++) {
    Props pellet = pellets.get(i);
    pellet.move(projDir.get(i).x,projDir.get(i).y);
    
    //orient pellet towards the target using target, which returns angle
    pellet.render(projDir.get(i).heading());
    boolean h = checkHit(pellet.xCor(), pellet.yCor());
    if (h) {
      pellets.remove(i);
      i--;
      break;
    }
  }
}

// helper function 
// returns angle of rotation from a temp vector based off on input coors
PVector dirGen(float x, float y, float x2, float y2) {
  PVector point1 = new PVector(x,y);
  PVector point2 = new PVector(x2,y2);
  PVector temp = PVector.sub(point1, point2);
  temp.normalize();
  temp.mult(pSpeed);

  return temp;
}

boolean checkHit(float x, float y) {
  boolean trackHit = false;
  for (int i = 0; i < candies.size(); i++) {
    Candy c = candies.get(i);
    trackHit = c.hit(x,y);
    if (trackHit) {
      hitCandies.add(i);
      soundLibrary.get(0).play();
      delay(1500);
      soundLibrary.get(0).pause();
      break;
    }
  }
  return trackHit;
}

void handleHit() {
  delay = true;
  score++; track--;
  //sending number to port for arduino to process; write any char to mark end of a number
  port.write(Integer.toString(1));
  port.write('e');
  
  int index = hitCandies.get(0);
  candies.remove(index);
  hitCandies.remove(0);
}

void scoreboard() {
  pushMatrix(); pushStyle();
    translate(0, height);
    fill(255);
    textSize(40);
    text(score, 30, -50);
  popStyle(); popMatrix();
}

void loadMusic() {
  SoundFile point = new SoundFile(this, "_point.mp3");
  soundLibrary.add(point);
  
  SoundFile bg = new SoundFile(this, "_bg.mp3");
  soundLibrary.add(bg);
}

void serialEvent(Serial p) {
  try {
    // get message till line break (ASCII > 13)
    //println(p.read());
    String message = (p.readString());
    println(message);
    // just if there is data
    //if (message != null) {
    //  if (message.charAt(0) == 'd') {
    //    //trigger new music
    //    score++;
    //  }
    //println(
        //println(message.charAt(0));
        //Character.getNumericValue(c)
        //print
        if (message.charAt(0) == '4') { // 4
          //println("aldj");
          shoot();
        } if (message.charAt(0) == '0') {//0
          tX+=40;
        } if (message.charAt(0) == '2') { //2
          tX-=40;
        } if (message.charAt(0) == '6') { //6
          tY+=40;
        } if (message.charAt(0) == '8'){ //8
          tY-=40;
        } 
      }
    //}
  
  catch (Exception e) {
    println(e);
  }
}
