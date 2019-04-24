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

int minDepth =  60;
int maxDepth = 880;

float angle;

void setup()
{
  //size(800,500,P2D);
  
  fullScreen(P2D);
  
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
  text((int)transform(mouseX-200,190,460,390,660) , 50,50); // first two values are kinect position
  text((int)transform(mouseY-200,90,420,290,620) , 120,50); 
  
  noFill();
  ellipse(mouseX,mouseY,20,20);
  
  noFill();
  strokeWeight(3);
  rect(390,290,660-390,620-290);
  
  strokeWeight(1);
  
  
}
