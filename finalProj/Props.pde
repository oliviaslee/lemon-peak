/*
  DESINV23 final project
  Props Object interface (used for importing and rendering various images)

  Olivia Lee
  Apr 19 2019
*/
class Props {
  float _x, _y, _w, _h;
  PImage prop; 
  String img;
  boolean resized;
  String type;
  int dir = 1;

  Props() {
    _x = random(0, width);
    _y = random(height/2, height);
    prop = new PImage();
  }

  Props(float x, float y) {
    _x = x;
    _y = y;
    prop = new PImage();
  }
  
  Props(String type) {
    this.type = type;
    if (type == "cloud") {
      _x = random(0, width);
      _y = random(height/5, height/2);
      prop = new PImage();     
    }
    if (type == "scoreboard") {
      _x = 0;
      _y = height;
      prop = new PImage();
      setCoor(prop.width /2, height - prop.height/2);
    }
  }

  void setImage(String imgLoc) {
    img = imgLoc;
    prop = loadImage(img);
  }
  
  void sb() {
    setCoor(prop.width /2, height - prop.height/2);
  }

  void render() {
    pushMatrix();
    if (resized) {
      image(prop, _x, _y, _w, _h);
    } else if (type == "cloud") {
      pushStyle();
        imageMode(CENTER);
        image(prop, _x, _y);
      popStyle();
    } else {
       image(prop, _x, _y);
    }
    popMatrix();
  }
  
  void render(float angle) {
    pushMatrix();
      translate(_x, _y);
      rotate(PI/2 + angle);
      image(prop, 0, 0);
    popMatrix();
  }

  void move(float x, float y) {
    if (type == "cloud" && 
    (_x > width - (prop.width/4)) || (_x < prop.width/4)) {
        dir = -dir;
    }
    _x += x * dir;
    _y += y;
  }

  float xCor() {return _x;}
  float yCor() {return _y;}
  
  void setCoor(float x, float y) {
    _x = x; 
    _y = y;
  }

  void resizeImg(int w, int h) {
    prop.resize(w, h);
  }

  void resizeP(float w, float h) {
    _w = w;
    _h = h;
    resized = true;
  }
  PImage pimage() {return prop;}
  String type() {return type;}
}
