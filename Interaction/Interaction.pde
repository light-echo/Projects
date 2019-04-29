

/////////////////////////////////////////////////////////////////////////
//
//
// This is a main project for Korea exhibition
// Main purpose of this project is to detect the position of where people touch and drag
// , Visualization, send some data to sound module via OSC
//
// First create by John Lee. 23 Mar 2019
// 
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
QTVisualizer2 myVisualizer_2;
QTCommunicator myCommunicator;

PVector screenRatio;  // this is a aspec ratio between kinect sensor and projector

void setup() 
{
  fullScreen(P2D,2); // please use this code for fully working test with projector. added by John. 28 Mar 2019

  //size(640, 480); // please use this code for testing on your PC . added by John. 28 Mar 2019

  println(width, height);

  background(0);
  
  noCursor();

  initDefaultData();
}

void initDefaultData()
{
  dummyPosition = new PVector(0, 0, 0);
  dummyPosZ = 0;
  dummyDirection = 1;

  screenRatio = new PVector(1280 / 640.0, 720 / 480.0);

  println(screenRatio);

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
  myVisualizer_2 = new QTVisualizer2();
  myCommunicator = new QTCommunicator();

  mySensor.initDefaultData();
  myVisualizer.initDefaultData();
  myVisualizer_2.initDefaultData();
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

 // myVisualizer.setPosition(dummyPosition);
  myCommunicator.setPosition(dummyPosition);
}

void draw() 
{
  background(0);
  
  //getting Amplitudes values from Olli
  float[] amplitudes = myCommunicator.getAmplitudes();
  //Function to send values 
  myVisualizer.setAmplitudes(amplitudes);

  mySensor.update();
  myVisualizer.update();
  myCommunicator.update();

  if (SIMULATION_MODE == true && simulatePosZ == true)
  {
    simulatePosition();
  }
  
  fill(255,0,0);
 
  //rect(230,160,660,520);
}

void mouseMoved()
{
  if (SIMULATION_MODE == true)
  {
    sendDummyPosition();
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
