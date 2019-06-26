/*
  DESINV23 final project
  LemonHead Object class that implements Candy interface

  Olivia Lee
  Apr 19 2019
*/

class LemonHead implements Candy {
  int health = 5;
  float _x, _y;
  PImage lemon;
  float xDir = 1.0, yDir = 0.05;
  boolean endScreen = false;
  int dir = 1;
  
  boolean hit;

  LemonHead() {    
    lemon = new PImage();
    _x = random(0, width);
    _y = random(0, height/2);
    lemon = loadImage("lemon.png");
    
    hit = false;
  }

  void render() {
    imageMode(CENTER);
    if (!endScreen) {
      image(lemon, _x, _y);
    }
    //target();
  }

  float xCor() {
    return _x;
  }
  float yCor() {
    return _y;
  }

  void move(float x, float y) {
    _x += x;
    _y += y;
  }

  void move() {
    if (_x < 0 || _x > width - lemon.width/2) {
      dir = -dir;
    }
    _x += dir*xDir;
    _y += yDir;
    if (_y > height - 125) {
      endScreen = true;
    }
  }
  
  boolean hit(float x, float y) {
    if (x >= _x - lemon.width/2 && x <= _x + lemon.width/2 
       && y >= _y - lemon.height/2 && y <= _y + lemon.height/2) {
      hit = true; 
    }
    return hit;
  }
}
