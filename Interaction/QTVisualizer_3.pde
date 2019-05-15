class QTVisualizer_3 {
  PImage gradient;
  int numOfBlobs = 5;
  Blob [] blobs = new Blob[numOfBlobs];
  PVector [] origin = new PVector [numOfBlobs];
  PVector pos;
  int startColor;

  void initDefaultData() {
    
    int tempX,tempY;

    startColor = 120;
    
    tempX = 200;
    tempY = 200;

    for (int i=0; i<numOfBlobs; i++)
    {
      origin[i] = new PVector(random(100, width-200), random(100, height-200));
    }
    
    
    //for (int i=0; i<numOfBlobs; i++)
    //{
    //  origin[i] = new PVector(tempX+random(0,100),tempY+random(0,50));
      
    //   tempX += 300;
      
    //  if (tempX >= (width))
    //  {
    //    tempY += 200;
        
    //    tempX = 200;
    //  }
    //}
    
  
    

    pos = new PVector();
    gradient = createImage(width, height, RGB);

    for (int i = 0; i<numOfBlobs; i++) {

      //if ( (i % 4) ==0)
      //{
      // blobs[i] = new Blob(origin[i], startColor-90+(i*8));
      //} else {
        blobs[i] = new Blob(origin[i], startColor+(i*8)); //
     // }

      blobs[i].initiate();
    }
  }

  void update() {
    drawGradient();
    
    for (Blob b : blobs) {
      b.display();
      b.returnToOriginal();
    }

    //fill(255);
    //textSize(50);
    //text(this.pos.x, 300, 300);
    //text(this.pos.y, 550, 300);
  }

  void setPosition(PVector pos) {
    this.pos = pos;
    for (Blob b : blobs) {
      b.updatePos(pos);
    }
  }

  void drawGradient() {

    noStroke();
    
    fill(250,100,100,50);
    
    ellipse(this.pos.x, this.pos.y, 50, 50);



    //  gradient.loadPixels();
    //  for (int y=0; y<gradient.height; y++) {
    //    for (int x=0; x<gradient.width; x++) {
    //      int index = x + y * gradient.width;
    //      float distance = dist(x, y, this.pos.x, this.pos.y);
    //      gradient.pixels[index] = color(distance, 100, 100);
    //    }
    //  }
    //  gradient.updatePixels();
    // // colorMode(RGB, 255, 255, 255);
    //}
  }
}

class Blob {
  float resolution = 15, 
    nVal, 
    rad = 200, 
    nInt =  random(0.1, 3), 
    nAmp = random(0.0, 1.0);
  float originX, originY;
  int numOfCoord = 0, maxPlace = 0, valSize = int(resolution) +1 ;
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
    speed = 300;
    startTime = new int[valSize];
    numOfCoord = 0;
    endTime = 5000;
  }
  void initiate() {
    for (float a=0; a<=TWO_PI; a+=TWO_PI/ (resolution-1)) {
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

    //  fill(255);

    beginShape();

    fill(myColor, 44, 74);

    curveVertex(locations[numOfCoord-1].x, locations[numOfCoord-1].y);

    for (int i=0; i<numOfCoord; i++) {

      fill(myColor+(i*2), 100, 100,200);

      curveVertex(locations[i].x, locations[i].y);
    }

    curveVertex(locations[0].x, locations[0].y);
    curveVertex(locations[1].x, locations[1].y);

    endShape();

    // for (int i=0; i<numOfCoord; i++) 
    // {
    //  fill(255);
    //  textSize(10);
    //  text(locations[i].x+" "+locations[i].y, locations[i].x, locations[i].y);
    //}
  }

  void updatePos(PVector position) {
    position.set( position);


    for (int i=0; i<numOfCoord; i++) {  

      // dist[i] = locations[i].dist(position);

      dist[i] = position.dist(locations[i]);

      float  distX = position.x - locations[i].x;
      float distY = position.y - locations[i].y;

      //stroke(255, 0, 0);
      //noFill();
      //ellipse(locations[i].x, locations[i].y, 10, 10);

      locations[i].add(velocities[i]);

      if ( dist[i] <minDist ) {   
        startTime[i] = millis();

        updateSpeed(i, distX, distY);

        velocities[i].set(distX/speed, distY/speed);

        println(dist[i]);
      } else { 
        velocities[i].set(0, 0);
        // minDist = 50;
      }
    }
  }

  void returnToOriginal() {
    for (int i=0; i<numOfCoord; i++) {
      float distOX = originalLoc[i].x-locations[i].x;
      float distOY = originalLoc[i].y-locations[i].y;
      if (velocities[i].x==0 && velocities[i].y==0 && millis()-startTime[i]>endTime) { //velocities[i].x==0 && velocities[i].y==0 &&
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
