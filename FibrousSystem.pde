/*
 
 //--------------------------------------------------FIBROUS SYSTEM 02----------------------------------------------------//
 
 Some example created with this code : http://vimeo.com/45254456.
 More info at : http://radical-reaction-ad.blogspot.it/
 
 References : 
 -Flocking algorithm from Jose Sanchez ( Plethora project ) .
 -Agent angle of vision form Daniel Shiffman.
 
 code by Paolo Alborghetti 2013 (cc)Attribution-ShareAlike
 
 ENJOY! :)
 
 
 */
import toxi.geom.*;
import controlP5.*;

//------------------------------------------------DECLARE

ArrayList <Agent> agents;
ArrayList <Vec3D> totTail;
boolean tailPrev=false;
boolean LB = true;
boolean appWander = false;
boolean futPrev = false;
boolean expTiff = false;
boolean NL=true;
int population = 200;
int fcount =354;

ControlP5 controlP5;
ControlWindow controlWindow;

void setup() {

  size(1280, 720);
  smooth();
  background(200);

  //--------------------------------------------UI CONTROLS

  initController();
  ui();

  //--------------------------------------------INITIALIZE
  agents = new ArrayList();
  totTail = new ArrayList <Vec3D>();


  for (int i=0; i < population; i++) {
    Vec3D origin = new Vec3D (random(width), 0, 0);
    Agent myAgent = new Agent (origin);   
    agents.add(myAgent);
  }
}

void draw() {

  //-----------------------------------CALL FUNCTIONALITY 
  for (Agent Ag : agents) {
    Ag.run();
    totTail.addAll(Ag.tail);
    Ag.stigmergy(totTail);
  }
  totTail.clear();
}
//----------------------------------------------PREVIEW MODE OPTIONS

void keyPressed() { 
  if (key == 't' || key == 'T') {
    tailPrev=!tailPrev;
  }
  if (key == 'l'|| key == 'L') {
    LB=!LB;
  }
  if (key == 'w'|| key == 'W') {
    appWander=!appWander;
  }
  if (key == 'f'|| key == 'F') {
    futPrev=!futPrev;
  }
  if (key == 'e'|| key == 'E') {
    Img();
  }

  if (key == 'n'|| key == 'N') {
    NL=!NL;
    if (!NL)noLoop();
    if (NL)loop();
  }
}

void Img() {
  println(frameCount);
  saveFrame("data/####.jpg");
}

