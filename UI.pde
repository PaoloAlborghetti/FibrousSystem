int sArray = 20;

float aliRad;
float cohRad;
float sepRad;
float aliMag;
float cohMag;
float sepMag;
float maxVel;
float wandertheta;
float futLocMag;
float viewAngle;
float stigViewAngle;
float stigCohMag;
float stigCohViewRange;
float stigAliMag;
float stigAliViewRange;
float stigSepMag;
float stigSepViewRange;


void  ui() {

  buildFSlider("stigViewAngle", 0, 360, 30);

  buildFSlider("stigCohMag", 0, 10, 8); 
  buildFSlider("stigCohViewRange", 0, 60, 20);

  buildFSlider("stigAliMag", 0, 10, 0);
  buildFSlider("stigAliViewRange", 0, 60, 10);

  buildFSlider("stigSepMag", 0, 10, 0.75);
  buildFSlider("stigSepViewRange", 0, 60, 5);

  buildFSlider("maxVel", 0, 10, 2);
  buildFSlider("wandertheta", 0, 180, 1);  
  buildFSlider("futLocMag", 0, 50, 10);
}

void initController() {
  controlP5 = new ControlP5(this);
  controlP5.setColorBackground(color(225, 225, 225, 10)); 
  controlP5.setColorForeground(color(100));
  controlP5.setColorActive(color(0, 0,0, 255));
  controlP5.setColorLabel(color(0, 0,0, 255));
  controlP5.setAutoDraw(true);
  controlWindow = controlP5.addControlWindow("controlP5window", 100, 100, 200, 400);

}



void buildFSlider(String name, float min, float max, float def) {
  Controller s1 = controlP5.addSlider(name, min, max, def, 20, sArray, 100, 10);
  sArray += 20;
  s1.setId(1);
  s1.setValue(def);

}

void buildISlider(String name, int min, int max, int def) {
  Controller s1 = controlP5.addSlider(name, min, max, def, 20, sArray, 100, 10);
  sArray += 20;
  s1.setId(1);
  s1.setValue(def);
  s1.setWindow(controlWindow);
}

