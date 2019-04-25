/////////////////////////////////////////////////////////////////////////
//
//
// This is coordinate aligner between kinect and projector
//
// First create by John Lee. 24 Apr 2019
// 
//
/////////////////////////////////////////////////////////////////////////



import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;

// Depth image
PImage depthImg;

int minDepth = 870;
int maxDepth = 950;

float angle;

void setup()
{
  //size(800,500,P2D);
  
  fullScreen(P2D,1);
  
  background(0);
  
  stroke(255);
  
  noFill();
  
  initKinect();
}

void initKinect()
{  
  kinect = new Kinect(this);
  kinect.initDepth();
  angle = kinect.getTilt();

  // Blank image
  depthImg = new PImage(kinect.width, kinect.height);
  
  println("Kinect resolution "+ kinect.width , kinect.height);
}

float transform(float input, float A,float B,float C, float D)
{
  float value;
  
  value = C +((input-A) * (D-C)/(B-A));
  
  return value;
}

void draw()
{
  background(0);
  
  // Draw the raw image
  image(kinect.getDepthImage(), 200, 200);
     
     
  textSize(25);
  fill(255);
  text(mouseX,mouseX+20,mouseY-20);
  text(mouseY,mouseX+80,mouseY-20);
  
  fill(255,0,0); // kinect
  text(mouseX-200,mouseX+20,mouseY+20);
  text(mouseY-200,mouseX+80,mouseY+20);
  
  fill(255);
  text((int)transform(mouseX-200,180,400,390,660) , 50,50); // first two values are kinect position
  text((int)transform(mouseY-200,110,420,290,620) , 120,50); 
  
  noFill();
  ellipse(mouseX,mouseY,20,20);
  
  noFill();
  strokeWeight(3);
  rect(190+200,110+200,400-180,420-110);
  
  strokeWeight(1);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      angle++;
    } else if (keyCode == DOWN) {
      angle--;
    }
    angle = constrain(angle, 0, 30);
    kinect.setTilt(angle);
  } else if (key == 'a') {
    minDepth = constrain(minDepth+10, 0, maxDepth);
  } else if (key == 's') {
    minDepth = constrain(minDepth-10, 0, maxDepth);
  } else if (key == 'z') {
    maxDepth = constrain(maxDepth+10, minDepth, 2047);
  } else if (key =='x') {
    maxDepth = constrain(maxDepth-10, minDepth, 2047);
  }
}
