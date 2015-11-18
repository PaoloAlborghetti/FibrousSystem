
class Agent {

  //------------------------------------------------------- GLOBAL VARIABLES
  Vec3D loc = new Vec3D();
  Vec3D speed = new Vec3D(random(-2, 2), random(-2, 2), 0);
  Vec3D acc = new Vec3D();

  ArrayList <Vec3D> tail = new ArrayList <Vec3D> ();
  int TLen = 100;
  int TStep = 20;

  //---------------------------angle detection flocking
  float angle;
  float VAngle;
  Vec3D perip = new Vec3D();

  //---------------------------angle detection tail seek
  float stigAngle;
  float stigVAngle;
  Vec3D stigPerip = new Vec3D();

  //---------------------------future location
  Vec3D FutVec;
  Vec3D FutLoc;
  Vec3D gravity = new Vec3D (0, -1, 0);

  //-------------------------------------------------------CONSTRUCTOR
  Agent(Vec3D _loc) {
    loc = _loc;
  }
  //-------------------------------------------------------FUNCTIONS
  void run() {

    display();
    move();
    bounce();
    if (LB) lineBetween();
    drawTail();
    FutLoc();
    if (appWander) wander();
    VAngle = radians(viewAngle);
    stigVAngle = radians(stigViewAngle);
  }



  //--------------------------------------------------------STIGMERGY

  void stigmergy(ArrayList<Vec3D> field) {
    stigSeparate(stigSepMag, stigSepViewRange, field);
    stigCohesion(stigCohMag, stigCohViewRange, field);
    stigAlign(stigAliMag, stigAliViewRange, field);
  }

  //------------------------------------------------------------STIGMERGY COHESION

  void stigCohesion(float magnitude, float range, ArrayList <Vec3D> field) {
    Vec3D sum = new Vec3D();
    Vec3D steer = new Vec3D();
    int count = 0;
    for (int i = 0; i < field.size (); i++) {
      float distance = FutLoc.distanceTo(field.get(i));
      if (distance > 0 && distance < range) {
        stigPerip = (field.get(i)).sub(loc);
        stigAngle = stigPerip.angleBetween(speed, true);
        if (stigAngle < 0) stigAngle += TWO_PI;
        if (abs(stigAngle) < stigVAngle ) {
          sum.addSelf(field.get(i));
          count++;
        }
      }
    }
    if (count>0) {
      sum.scaleSelf(1.0/count);
      steer = sum.sub(loc);
    }
    steer.normalize();
    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }
  //-------------------------------------------------------- ALIGN

  void stigAlign(float magnitude, float range, ArrayList <Vec3D> field) {
    Vec3D steer = new Vec3D();
    int count = 0;
    for (int i = 0; i < field.size (); i++) {
      float distance = FutLoc.distanceTo(field.get(i));
      if (distance > 0 && distance < range) {
        stigPerip = (field.get(i)).sub(loc);
        stigAngle = stigPerip.angleBetween(speed, true);
        if (stigAngle < 0) stigAngle += TWO_PI;
        if (abs(stigAngle) < stigVAngle ) {
          steer.addSelf(field.get(i)); 
          count++;
        }
      }
    }
    if (count>0) {
      steer.scaleSelf(1.0/count);
    }
    steer.normalize();
    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }


  //------------------------------------------------------ SEPARATE

  void stigSeparate(float magnitude, float range, ArrayList <Vec3D> field) {
    Vec3D steer = new Vec3D();
    int count = 0;
    for (int i = 0; i < field.size (); i++) {
      float distance = FutLoc.distanceTo(field.get(i));
      if (distance > 0 && distance < range) {
        stigPerip = (field.get(i)).sub(loc);
        stigAngle = stigPerip.angleBetween(speed, true);
        if (stigAngle < 0) stigAngle += TWO_PI;
        if (abs(stigAngle) < stigVAngle ) {
          Vec3D diff = loc.sub(field.get(i));
          diff.normalizeTo(1.0/distance);
          steer.addSelf(diff);
          count++;
        }
      }
    }
    if (count > 0) {
      steer.scaleSelf(1.0/count);
    }
    steer.normalize();
    steer.scaleSelf(magnitude);
    acc.addSelf(steer);
  }

  //-----------------------------------------------------------LINE BETWEEN
  void lineBetween() {
    for (Agent other : agents) {
      float distance = loc.distanceTo(other.loc);
      if (distance > 5 && distance < 40) {
        stroke(0, 15);
        strokeWeight(0.1);
        line(loc.x, loc.y, other.loc.x, other.loc.y);
      }
    }
  }


  //-----------------------------------------------------------------SPACE WRAP

  void bounce() {
    if (loc.x > width) {
      loc.x -=width;
      //speed.x = speed.x * -1;
    }
    if (loc.x < 0) {
      loc.x+=width;
      //speed.x = speed.x * -1;
    }
    if (loc.y > height) {
      loc.y-=height;
      //speed.y = speed.y * -1;
    }
    if (loc.y < 0) {
      loc.y+=height;
      //speed.y = speed.y * -1;
    }
  }

  //-----------------------------------------------------------------MOVE

  void move() {
    pushMatrix();    
    speed = speed.getRotatedZ(random(-1, 1));
    popMatrix();
    acc.addSelf(gravity);
    speed.addSelf(acc);
    speed.limit(maxVel);
    loc.addSelf(speed);
    acc.clear();
  }

  //-----------------------------------------------------------------DISPLAY

  void display() {
    noStroke();
    fill(0, 150);
    ellipse(loc.x, loc.y, 1.2, 1.2);
  }

  //------------------------------------------------------------DRAW TAIL

  void drawTail() {
    tail.add(loc.copy());
    if (tail.size() > TLen) {
      tail.remove(0);
    }
    fill(160, 255, 10, 255);
    noStroke();
    for ( int i = 0; i < tail.size (); i+= TStep ) {    
      if (tailPrev) {
        ellipse((tail.get(i)).x, (tail.get(i)).y, 1.5, 1.5);
      }
    }
  }


  //--------------------------------------------------------PREDICT FUT LOC

  void FutLoc() {

    FutVec = speed.copy();
    FutVec.normalize();
    FutVec.scaleSelf(futLocMag);
    FutLoc = FutVec.addSelf(loc);
    stroke(160, 255, 10);
    strokeWeight(0.5);
    if (futPrev) line(loc.x, loc.y, FutLoc.x, FutLoc.y);
  }

  //-----------------------------------------------------------WANDER

  void wander() {
    float wanderR = 25;
    float wanderD = 40;
    float change = 0.6;
    wandertheta += random(-change, change);
    Vec3D circleLoc = speed.copy();
    circleLoc.normalize();
    circleLoc.scaleSelf(wanderD);
    circleLoc.addSelf(loc); 
    Vec3D circleOffSet = new Vec3D(wanderR*cos(wandertheta), wanderR*sin(wandertheta), 0);
    Vec3D target = circleLoc.addSelf(circleOffSet);
    Vec3D steer = target.sub(loc);
    steer.normalize();
    steer.scaleSelf(1);
    acc.addSelf(steer);
  }
}

