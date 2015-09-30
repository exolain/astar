PImage img;
int raw_puzzle[] [];
int puzzle[][];
Ball ball;
Ball ball_goal;
PVector goal;
ArrayList<PVector> visited;
ArrayList<PVector> toVisit;
int current_cost = 0;

void setup() {
  size(432, 432);
  background(0);
  raw_puzzle = new int [width][height];
  puzzle = new int[22][22];
  goal = new PVector ((int)random(width),(int)random(height));
  img = loadImage("puzzle.jpg");
  ball = new Ball(30,9);
  ball_goal = new Ball(goal.x+20, goal.y+20);
  ball_goal.col = 45;
  image(img,0,0);
  loadPixels();  
  visited = new ArrayList<PVector>();
  for (int x = 0; x < width; x++) {
    // Loop through every pixel row
    for (int y = 0; y < height; y++) {
      raw_puzzle[x][y] = pixels[x+y*width];
    }
  }
  ///generate matrix based on pxel data
  int xx = 0;
  int yy = 0;
  for (int x = 0; x < width; x+=20, xx++) {
    // Loop through every pixel row
    yy = 0;
    for (int y = 0; y < height; y+=20, yy++) {
      if (raw_puzzle[x+1][y+1] == -1) ///blanco
      {
        puzzle[x][y] = 0;
      } else { ///negro
        puzzle[x][y] = 1;
      }
    }
  }
}


void draw() {
  ball.display();
  ball_goal.display();
}

int manhattan_distance(int posX, int posY, int targetX, int targetY){
  int dx = posX - targetX; // x-distance to expected coordinate
  int dy = posY - targetY; // y-distance to expected coordinate
  return Math.abs(dx) + Math.abs(dy);
} 

class Ball {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;
  float maxspeed;
  public int col;
  

  Ball(float x, float y) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);
    r = 3.0;
    maxspeed = 4;
    maxforce = 0.1;
    col = 175;
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void seek(PVector target) {
    //PVector desired = PVector.sub(target,location);
    //desired.normalize();
    //desired.mult(maxspeed);
    //PVector steer = PVector.sub(desired,velocity);
    //steer.limit(maxforce);
    //applyForce(steer);
     PVector desired = PVector.sub(target,location);
     float d = desired.mag();
    desired.normalize();
    if (d < 300) {
      float m = map(d,0,100,0,maxspeed);
      desired.mult(m);
   } else {
      desired.mult(maxspeed);
    }
     PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
  

  void display() {
    float theta = velocity.heading() + PI/2;
    fill(col);
    stroke(0);
    pushMatrix();
    translate(location.x,location.y);
    rotate(theta);
    ellipse(0, 0, 20, 20);
    popMatrix();
  }
}

