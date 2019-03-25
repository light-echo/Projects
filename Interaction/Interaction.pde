

/////////////////////////////////////////////////////////////////////////
//
//
// This is a main project for Korea exhibition
// Main purpose of this project is to detect the position of where people touch and drag
// , Visualization, send some data to sound module via OSC
//
// First create by John Lee. 23 Mar 2019
// Github test
//
/////////////////////////////////////////////////////////////////////////


import org.openkinect.freenect.*;
import org.openkinect.processing.*;

boolean SIMULATION_MODE = true;

Kinect kinect;
QTSensor mySensor;
QTVisualizer myVisualizer;
QTCommunicator myCommunicator;

void setup() 
{
  size(640, 480);

  background(0);

  initDefaultData();
}

void initDefaultData()
{
  kinect = new Kinect(this);
  
  if (kinect.numDevices() > 0)
  {
    kinect.initDepth();
    kinect.enableIR(true);  
    kinect.enableMirror(true);

    mySensor = new QTSensor();
    
    mySensor.initDefaultData();
    
    SIMULATION_MODE = false;
  }
  else
  {
    println("Can't found sensor, system will running with simulation mode");
    
    SIMULATION_MODE = true;
  }
  
  myVisualizer = new QTVisualizer();
  myCommunicator = new QTCommunicator();
  
  myVisualizer.initDefaultData();
  myCommunicator.initDefaultData();
}

void draw() 
{
  if (SIMULATION_MODE == false)
  {
    mySensor.update();
  }
  
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
