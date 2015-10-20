/*
Integrantes:
Natalia Marin
Randy Salas
*/
final int UP = 0;
final int LEFT = 1;
final int DOWN = 2;
final int RIGHT = 4;
PImage img;
ArrayList<PVector> queue;
ArrayList<String> visited;
PVector goal;
  
Ghost g1;

void setup() {
  size(432, 432);
  background(0);
  img= loadImage("puzzle.jpg");
  image(img,0,0);
  g1 = new Ghost(310,110);
  visited = new ArrayList<String>();
  queue = new ArrayList<PVector>();
  //queue.add(new PVector(-1,-1));    
  //goal = new PVector((int)random(width/10)*10,(int)random(height/10)*10);
  goal = new PVector(20,10);
}


boolean isEmpty(ArrayList<PVector> list){
  return list.size() == 1 && list.get(0).x== -1 && list.get(0).y== -1;
}

boolean isObstacle(float posx, float posy){
   return !(get ( (int)posx , (int)posy ) == -1);
}
int manhattan_distance(int posX, int posY, int targetX, int targetY){
  int dx = posX - targetX; // x-distance to expected coordinate
  int dy = posY - targetY; // y-distance to expected coordinate
  return Math.abs(dx) + Math.abs(dy);
} 


void astar(){


  boolean moved = false;

    do {
    float posX = g1.location.x;
    float posY = g1.location.y;
    boolean neighborIsBetter = false;
      int currentDistance = manhattan_distance((int)posX,(int)posY, (int)goal.x,(int)goal.y);
    System.out.println(get((int)posX, (int)posY));
    if (posY > 0 && !visited.contains(posX + "" + (posY-10)) && !(isObstacle((posX), (posY-10)))){
      int distance = manhattan_distance((int)posX,(int)posY-10, (int)goal.x,(int)goal.y);
      PVector neighbor=new PVector(g1.location.x, g1.location.y-10);
             if(!queue.contains(neighbor)) {
                queue.add(neighbor);
                neighborIsBetter = true;
                //if neighbor is closer to start it could also be better
             } else if(distance < currentDistance) {
                  neighborIsBetter = true;
                  } else {
                  neighborIsBetter = false;
            }
            if(neighborIsBetter){
                  g1.location.y = g1.location.y-10;
            }
      queue.add(new PVector(posX, posY));

      visited.add(posX + "" + posY);

      moved = true;

  }else if(posX > 0 && !visited.contains((posX-10) + "" + posY) && !(isObstacle((posX-10), posY))){
       int distance = manhattan_distance((int)posX-10,(int)posY, (int)goal.x,(int)goal.y);
      PVector neighbor=new PVector(g1.location.x-10, g1.location.y);
             if(!queue.contains(neighbor)) {
                queue.add(neighbor);
                neighborIsBetter = true;
                //if neighbor is closer to start it could also be better
             } else if(distance < currentDistance) {
                  neighborIsBetter = true;
                  } else {
                  neighborIsBetter = false;
            }
            if(neighborIsBetter){
               g1.location.x = g1.location.x-10;
            }
            
      queue.add(new PVector(posX, posY));
      visited.add(posX + "" + posY);
      moved = true;
    }else if(posY < height && !visited.contains(posX + "" + (posY+10))&& !(isObstacle((posX), posY+10))){
       int distance = manhattan_distance((int)posX,(int)posY+10, (int)goal.x,(int)goal.y);
      PVector neighbor=new PVector(g1.location.x, g1.location.y+10);
             if(!queue.contains(neighbor)) {
                queue.add(neighbor);
                neighborIsBetter = true;
                //if neighbor is closer to start it could also be better
             } else if(distance < currentDistance) {
                  neighborIsBetter = true;
                  } else {
                  neighborIsBetter = false;
            }
            if(neighborIsBetter){
                g1.location.y = g1.location.y+10;
            }
      queue.add(new PVector(posX, posY));
      visited.add(posX + "" + posY);
      moved = true;
    }else if(posX < width && !visited.contains((posX+10) + "" + posY)&& !(isObstacle((posX+10), posY))){
       int distance = manhattan_distance((int)posX+10,(int)posY, (int)goal.x,(int)goal.y);
      PVector neighbor=new PVector(g1.location.x+10, g1.location.y);
             if(!queue.contains(neighbor)) {
                queue.add(neighbor);
                neighborIsBetter = true;
                //if neighbor is closer to start it could also be better
             } else if(distance < currentDistance) {
                  neighborIsBetter = true;
                  } else {
                  neighborIsBetter = false;
            }
            if(neighborIsBetter){
              g1.location.x = g1.location.x+10;
            }
      queue.add(new PVector(posX, posY));
      visited.add(posX + "" + posY);
      moved = true;
    } 
    
    //System.out.println(g1.location.x + "," + g1.location.y + " Visited: " + visited.get(visited.size()-1));
    
    System.out.println(visited.toString());
    
    
    if (!moved && !(isObstacle((posX), posY)) ){
      
      PVector p = queue.get(queue.size() - 1);
      queue.remove(queue.size() - 1);
      g1.location.x = p.x;
      g1.location.y = p.y;
    }
  
  }  while (isEmpty(queue) && !moved);


}


void draw() {
  noStroke(); 
    //background(0);
  
  fill(0,200,0);
  ellipse(goal.x,goal.y, 30,30);
  
  
  //Arrived
  if (!(g1.location.x == goal.x && g1.location.y == goal.y)){
    astar();
  }
  


  g1.display();
  


}


class Ghost {

  PVector gColor;
  int gScareFactor;
  PVector eyesOrientation;
  
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  // Additional variable for size
  float r;
  float maxforce;
  float maxspeed;

  Ghost(float x, float y) { //TODO: Put parameters as needed
  
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    location = new PVector(x,y);

    //TODO: Set color and ScareFactor randomly
    gColor = new PVector(255,190,88);
    eyesOrientation = new PVector(0,0);

    //[full] Arbitrary values for maxspeed and
    // force; try varying these!
    maxspeed = 1;
    maxforce = 0.1;
    //[end]
  }

  // Our standard .Euler integration. motion model
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    
    eyesOrientation = velocity;
    eyesOrientation =  eyesOrientation.normalize().mult(1.5);
    
    if (location.x < 20 || location.x > width-20){
      location.x -= velocity.x;
    }
    
    if (location.y < 25 || location.y > height-25){
      location.y -= velocity.y;
    }
      
    acceleration.mult(0);
  }

  // Newton.s second law; we could divide by mass if we wanted.
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void flee(PVector target) {
    PVector desired = PVector.sub(location,target);
    desired.normalize();
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }

  void display() {
      fill(0,0,248);
      ellipse(location.x+9+eyesOrientation.x,location.y+2+eyesOrientation.y,20,20);
      
  }
}
