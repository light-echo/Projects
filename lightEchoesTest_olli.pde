import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

int cubeLen = 100;
float rotAngle = 1;


int cols, rows;
int scl = 50 ;
int w = 3000;
int h = 1600;

float amplitude = 0;
float amplitude2 = 0;
float amplitude3 = 0;

float rotate = 0;
float rotate2 = 0;
float rotate3 = 0;

float trailOn = 0;

float strokeWeight = 0;

float trailDepth = 0;

float sum = 0;
float sum2 = 0;
float sum3 = 0;

float smooth_factor = 0.1;

float flying = 0;

float[][] terrain;

void setup() {
  size(600, 600, P3D);
  surface.setAlwaysOnTop(true);
  cols = w / scl;
  rows = h/ scl;
  terrain = new float[cols][rows];

  oscP5 = new OscP5(this, 12000); 
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}


void draw() {
  sum += (amplitude - sum) * smooth_factor;
  float A = sum*(500);

  sum2 += (amplitude2 - sum2) * smooth_factor;
  float A2 = sum2*(500);

  sum3 += (amplitude3 - sum3) * smooth_factor;
  float A3 = sum3*(500);


  flying -= 0.005;


  background( map(A2, 0, 1, 0, 50));

  noStroke();
  ellipse(width/2, height/2, A3*10, A3*10);
  fill(A*100, 0, A*300, 50);


  float yoff = flying;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      //terrain[x][y] = A;
      terrain[x][y] = map(noise(xoff, yoff ), 0, 1, -50*A, 100*A);
      xoff += 0.2;
    }
    yoff += 0.2;
  }

  pushMatrix();
  translate(width/2, height/2);
  rotateX(map(rotate2, 0, 127, 0, 1000));
  rotateY(map(rotate2, 0, 127, 0, 1000));
  sphere(200*A3);
  popMatrix();

  stroke(255);
  //noFill


  translate(width/2, height/2+50);
  rotateX(map(rotate, 0, 1, 0, 6.3));
  rotateY(map(rotate2, 0, 1, 0, 6.3));
  rotateZ(map(rotate3, 0, 1, 0, 6.3));
  translate(-w/2, -h/2);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x*scl, y*scl, terrain[x][y]); 
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
}

void oscEvent(OscMessage theOscMessage) 
{
  if (theOscMessage.checkAddrPattern("/amp")==true)
  {
    amplitude = theOscMessage.get(0).floatValue();
  }
  if (theOscMessage.checkAddrPattern("/amp2")==true)
  {
    amplitude2 = theOscMessage.get(0).floatValue();
  }
  if (theOscMessage.checkAddrPattern("/amp3")==true)
  {
    amplitude3 = theOscMessage.get(0).floatValue();
  }
  if (theOscMessage.checkAddrPattern("/rotate")==true)
  {
    rotate = theOscMessage.get(0).floatValue();
  }
  if (theOscMessage.checkAddrPattern("/rotate2")==true)
  {
    rotate2 = theOscMessage.get(0).floatValue();
  }
    if (theOscMessage.checkAddrPattern("/rotate3")==true)
  {
    rotate3 = theOscMessage.get(0).floatValue();
  }
  if (theOscMessage.checkAddrPattern("/trailOn")==true)
  {
    trailOn = theOscMessage.get(0).floatValue();
  }
  if (theOscMessage.checkAddrPattern("/trailOn")==true)
  {
    trailOn = theOscMessage.get(0).floatValue();
  }
  if (theOscMessage.checkAddrPattern("/strokeWeight")==true)
  {
    strokeWeight = theOscMessage.get(0).floatValue();
  }
  if (theOscMessage.checkAddrPattern("/trailDepth")==true)
  {
    trailDepth = theOscMessage.get(0).floatValue();
  }
}
