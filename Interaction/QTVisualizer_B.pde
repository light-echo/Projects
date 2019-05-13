class QTVisualizer2 {
  float 
    resolution, 
    nVal, 
    rad, 
    nInt, 
    nAmp, 
    originX, 
    originY;
  int counter, maxPlace, valSize;
  float distance;
  float[] dist;
  PVector[] locations;
  PVector[] velocities;
  PVector mousePos;
  float minDist;
  int closestCoord;

  void initDefaultData() {
    originX = 490;
    originY = 440;
    closestCoord=0;
    resolution = 20;
    maxPlace = 0;
    counter = 0;
    valSize = int(resolution) +1 ;
    nInt =  random(0.1, 3);
    nAmp = random(0.0, 1.0);
    rad = 150;
    //nVal = 1;
    locations = new PVector[valSize];
    velocities  = new PVector[valSize];
    dist = new float[valSize];
    mousePos = new PVector(0, 0, 0);
    minDist = 50;
    counter = 0;

    for (float a=0; a<=TWO_PI; a+=TWO_PI/ (resolution-1)) {
      nVal = map(noise( cos(a)*nInt+1, sin(a)*nInt+1), 0.0, 1.0, nAmp, 1.0); // map noise value to match the amplitude
      locations[counter] = new PVector(0, 0, 0);
      locations[counter].set (cos(a)*rad*nVal+originX, sin(a)*rad*nVal+originY);

      velocities[counter++] = new PVector(0, 0); //random(-1,1),random(-1,1)
    }
  }
  void update() {
    stroke(255);
    noFill();
    //fill(0);
    beginShape();
    curveVertex(-rad+originX, 0);
   
    for (int i=0; i<counter; i++) { //<>// //<>//

      curveVertex(locations[i].x, locations[i].y); //<>// //<>//
    }
    endShape(CLOSE);
  }
  void setPosition(PVector position) {
    mousePos.set(position);
    //mousePos.set( xPos, yPos);
    
    println(position);

    for (int i=0; i<counter; i++) {  

      dist[i] = locations[i].dist(mousePos);

      float  distX = mousePos.x - locations[i].x;
      float distY = mousePos.y - locations[i].y;

      stroke(255);
      noFill();

      ellipse(locations[i].x, locations[i].y, 10, 10);

      // point(locations[i].x, locations[i].y);    
      locations[i].add(velocities[i]);
      
      if ( dist[i] <50 ) {    
        if (minDist > dist[i])
        { 
          minDist = dist[i];
          closestCoord = i;
        }
//        stroke(0, 255, 0);
//        ellipse(locations[closestCoord].x, locations[closestCoord].y, 10, 10);
       velocities[closestCoord].set(distX/5, distY/5);
        println(closestCoord);
      } 

      else if (!mousePressed) {
        velocities[i].set(0, 0);
        minDist = 50;
      
    }
  }

}
}
