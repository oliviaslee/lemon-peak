/*
  DESINV23 final project
  Candy Object interface

  Olivia Lee
  Apr 19 2019
*/

interface Candy {
  float xCor();
  float yCor();
  void move(float x, float y);
  void move();
  void render();
  boolean hit(float x, float y);
}
