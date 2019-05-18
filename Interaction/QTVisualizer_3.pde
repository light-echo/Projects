int ORIGINAL_DIST = 80;

class QTVisualizer_3 {
  float alpha;
  int numOfBlobs = 5;
  int startColor;
  boolean startSleep = false;
  Blob [] blobs = new Blob[numOfBlobs];
  PVector [] origin = new PVector [numOfBlobs];
  PVector pos;

  void initDefaultData() {

    startColor = 120;

    for (int i=0; i<numOfBlobs; i++)
    {
      origin[i] = new PVector(random(100, width-200), random(100, height-200));
    }

    pos = new PVector();

    for (int i = 0; i<numOfBlobs; i++) {

      blobs[i] = new Blob(origin[i], startColor+(i*8)); 

      blobs[i].initiate();
    }
  }

  void update() {
    drawCursor();

    for (Blob b : blobs) {
      b.display();
      b.returnToOriginal();
    }
    //screensaver mode starts
    if (alpha < 255 && startSleep==true) {
      alpha ++;
      tint(255, alpha);  // Apply transparency without changing color
    }   
    //screensaver stops
    if (alpha>0 && startSleep == false) {
      background(0);
      alpha-=30;
      tint(255, alpha);  // Apply transparency without changing color
      image(screenSaver, 0, 0, width, height);
      
      screenSaver.stop();
    }
      
    if (startSleep == true)
    {
      image(screenSaver, 0, 0, width, height);
    }
  }

  void setPosition(PVector pos) {
    this.pos = pos;
    for (Blob b : blobs) {
      b.updatePos(pos);
    }
  }

  void drawCursor() {

    noStroke();

    fill(250, 100, 100, 50);

    ellipse(this.pos.x, this.pos.y, 50, 50);
  }

  void goToSleep() {
    
    alpha = 0;
    
    screenSaver.loop();
    
    startSleep = true;
  }

  void wakeUp() {
    
    alpha = 255;
    
    startSleep = false;
    
    initDefaultData();
  }


}

class Blob {

  float resolution = 15, 
    nVal, 
    rad = 150, 
    nInt =  random(0.1, 3), 
    nAmp = random(0.0, 1.0);
  float originX, originY;

  int numOfCoord = 0, maxPlace = 0, valSize = int(resolution) +1;

  float distance;
  float[] dist;
  float[] allDist;
  float speed;
  PVector[] locations;
  PVector[] originalLoc;
  PVector[] velocities;
  PVector position;
  float minDist;
  int j=0;
  int startTime[];
  float n;
  int myColor;
  boolean randVal = true;
  int endTime;

  Blob(PVector o, int myColor) {

    this.originX = o.x;
    this.originY = o.y;
    this.myColor = myColor;
    nVal = 1;
    locations = new PVector[valSize];
    velocities  = new PVector[valSize];
    originalLoc = new PVector[valSize];
    dist = new float[valSize];
    allDist = new float[valSize];
    position = new PVector(0, 0);
    minDist = 100;
    speed = 700;
    startTime = new int[valSize];
    numOfCoord = 0;
    endTime = 20000;
  }

  void initiate() {

    for (float a=0; a<=TWO_PI; a+=TWO_PI/ (resolution-1)) 
    {
      nVal = map(noise( cos(a)*nInt+1, sin(a)*nInt+1), 0.0, 1.0, nAmp, 1.0); // map noise value to match the amplitude

      locations[numOfCoord] = new PVector(0, 0, 0);
      locations[numOfCoord].set(cos(a)*rad*nVal+originX, sin(a)*rad*nVal+originY);

      originalLoc[numOfCoord] = new PVector(0, 0, 0);
      originalLoc[numOfCoord].set(cos(a)*rad*nVal+originX, sin(a)*rad*nVal+originY);

      velocities[numOfCoord++] = new PVector(0, 0);
    }
  }

  void display() {

    noStroke();

    beginShape();
    // 102, 36, 31 GREEN. 342, 71, 72 PINK. 247, 100, 50 BLUE. 273, 100, 29 VIOLET. 
    fill(myColor+(distance/5.0), 44, 74);

    curveVertex(locations[numOfCoord-1].x, locations[numOfCoord-1].y);

    for (int i=0; i<numOfCoord; i++) {

      fill(myColor+(i*2), 100, 100, 200);

      curveVertex(locations[i].x, locations[i].y);
    }

    curveVertex(locations[0].x, locations[0].y);
    curveVertex(locations[1].x, locations[1].y);

    endShape();
  }

  void updatePos(PVector position) {

    float  distX;
    float  distY;

    position.set( position);

    minDist = (ORIGINAL_DIST + position.z);

    for (int i=0; i<numOfCoord; i++) {  

      dist[i] = position.dist(locations[i]);

      distX = position.x - locations[i].x;
      distY = position.y - locations[i].y;

      locations[i].add(velocities[i]);

      if ( dist[i] <minDist ) {   
        startTime[i] = millis();

        updateSpeed(i, distX, distY);

        velocities[i].set(distX/speed, distY/speed);
      } else { 
        velocities[i].set(0, 0);
      }
    }
  }

  void returnToOriginal() {

    float distOX;
    float distOY;

    for (int i=0; i<numOfCoord; i++) {
      distOX = originalLoc[i].x-locations[i].x;
      distOY = originalLoc[i].y-locations[i].y;

      if (velocities[i].x==0 && velocities[i].y==0 && millis()-startTime[i]>endTime) 
      {
        if (locations[i]!=originalLoc[i]) {
          //println("speed");
          velocities[i].set(distOX/30, distOY/30);
        }
      }
    }
  }

  void updateSpeed(int j, float distX, float distY) {

    for (int i = 0; i<numOfCoord; i++) {

      allDist[i] = locations[i].dist(locations[j]);
      velocities[i].set(distX/(allDist[i]*0.5), distY/(allDist[i]*0.5));
    }
  }
}
