

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

import netP5.*;
import oscP5.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

int dummyPosZ;
int dummyDirection;
PVector dummyPosition;
boolean SIMULATION_MODE = true;
boolean simulatePosZ = false;
int MAX_POSZ = 100; // [002] added by John.

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
  dummyPosition = new PVector(0, 0, 0);
  dummyPosZ = 0;
  dummyDirection = 1;

  kinect = new Kinect(this);

  if (kinect.numDevices() > 0)
  {
    kinect.initDepth();
    kinect.enableIR(true);  
    kinect.enableMirror(true);

    SIMULATION_MODE = false;
  } else
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

void simulatePosition()
{
  dummyPosZ += dummyDirection;

  if (dummyPosZ <= 0)
  {
    dummyPosZ = 0;
    
    simulatePosZ = false;
  }

  if (dummyPosZ >= MAX_POSZ)
  {
    dummyPosZ = MAX_POSZ;
    
    simulatePosZ = false;
  }
  
  sendDummyPosition();
}

void sendDummyPosition()
{
  dummyPosition.set(mouseX, mouseY, dummyPosZ);
  
  myVisualizer.setPosition(dummyPosition);
  myCommunicator.setPosition(dummyPosition);
}

void draw() 
{
  background(0);

  mySensor.update();
  myVisualizer.update();
  myCommunicator.update();

  if (SIMULATION_MODE == true && simulatePosZ == true)
  {
    simulatePosition();
  }
}

void mouseMoved()
{
  if (SIMULATION_MODE == true)
  {
    sendDummyPosition();
    
    println("**");
  }
}

void mousePressed()
{
  simulatePosZ = true;
  dummyDirection = 1;
}

void mouseReleased()
{
  simulatePosZ = true;
  dummyDirection = -1;
}

void keyPressed() 
{
  if (SIMULATION_MODE == true)
  {
    mySensor.keyPressed();
  }
}
