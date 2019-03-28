

/////////////////////////////////////////////////////////////////////////
//
//
// This is a main project for Korea exhibition
// Main purpose of this project is to detect the position of where people touch and drag
// , Visualization, send some data to sound module via OSC
//
// First create by John Lee. 23 Mar 2019
// First working version test. 28 Mar 2019
//
/////////////////////////////////////////////////////////////////////////

import netP5.*;
import oscP5.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

boolean SIMULATION_MODE = true;

Kinect kinect;
QTSensor mySensor;
QTVisualizer myVisualizer;
QTCommunicator myCommunicator;

PVector screenRatio;  // this is a aspec ratio between kinect sensor and projector

void setup() 
{
  
  //fullScreen(P2D,2); // please use this code for fully working test with projector. added by John. 28 Mar 2019
  
  size(640, 480); // please use this code for testing on your PC . added by John. 28 Mar 2019
  
  println(width,height);
  
  background(0);

  initDefaultData();
}

void initDefaultData()
{
  screenRatio = new PVector(1280 / 640.0 , 720 / 480.0);
  
  println(screenRatio);
    
  kinect = new Kinect(this);
  
  if (kinect.numDevices() > 0)
  {
    kinect.initDepth();
    kinect.enableIR(true);  
    kinect.enableMirror(true);
    
    SIMULATION_MODE = false;
  }
  else
  {
    println("Can't found sensor, system will running with simulation mode");
    
    SIMULATION_MODE = true;
  }
  
  mySensor = new QTSensor(); // even simulation mode , it's better to new QTSensor
  myVisualizer = new QTVisualizer();
  myCommunicator = new QTCommunicator();
  
  mySensor.initDefaultData();
  myVisualizer.initDefaultData();
  myCommunicator.initDefaultData();
}

void draw() 
{
  background(0);
  
  mySensor.update();
  myVisualizer.update();
  myCommunicator.update();
}

void mouseMoved()
{
  if (SIMULATION_MODE == true)
  {
    myVisualizer.setPosition(mouseX,mouseY);
    myCommunicator.setPosition(mouseX,mouseY);    
  }
}

void keyPressed() 
{
  if (SIMULATION_MODE == true)
  {
    mySensor.keyPressed();
  }
}
