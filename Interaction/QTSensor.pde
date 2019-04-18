/////////////////////////////////////////////////////////////////////////
//
//
// This class is for sensing the position of where people touch and drag
// I can use kinect, radar
// First create by John Lee. 23 Mar 2019
//
//[002] modify code to send position to use PVector
/////////////////////////////////////////////////////////////////////////


class QTSensor
{
  PImage depthImg;

  int minDepth =  60;
  int maxDepth = 850;
  float angle;
  
  PVector curPosition;
  PVector curSpeed;
  
  void initDefaultData()
  {
    curPosition = new PVector(0,0,0);
    curSpeed = new PVector(0,0,0);
    
    if (SIMULATION_MODE == false)
    {
      angle = kinect.getTilt();
    
      depthImg = new PImage(kinect.width, kinect.height);
    }
    else
    {
      angle = 0;
      depthImg = new PImage(width,height);
    }
  }
    
  void traceMovement()
  {
    int[] rawDepth;
    int newPosX, newPosY,newPosZ;
    int minData = 5000;

    newPosX = 0;
    newPosY = 0;
    newPosZ = 0;

    rawDepth = kinect.getRawDepth();

    for (int i=0; i < rawDepth.length; i++)
    {
      if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) 
      {
        depthImg.pixels[i] = color(255);

        if (rawDepth[i] < minData && (i/640) < 380)
        {
          minData = rawDepth[i];

          newPosX = i % 640;
          newPosY = i/640;
          
          //println(newPosX, " , "+newPosY);
        }
      } else
      {
        depthImg.pixels[i] = color(0);
      }
    }
    
    newPosX = int(newPosX * screenRatio.x)+50;
    newPosY = int(newPosY * screenRatio.y)+50;
    
    //println(screenRatio);

    depthImg.updatePixels();

    curSpeed.x = (newPosX - curPosition.x) / 10.0;
    curSpeed.y = (newPosY - curPosition.y) / 10.0;
    curSpeed.z = (newPosZ - curPosition.z) / 10.0;

    curPosition.add(curSpeed);
  }


  void update() 
  {
    fill(0, 20);

    rect(0, 0, width, height);

    stroke(255);

    fill(0, 255, 0);

    if (SIMULATION_MODE == false)
    {
      traceMovement();

      //image(depthImg, 0, 0);
      
      ellipse(curPosition.x, curPosition.y, 50, 50);
      
      myVisualizer.setPosition(curPosition);
      myCommunicator.setPosition(curPosition);
    }
    else
    {
      ;//ellipse(mouseX,mouseY , 50,50);
    }

    //image(kinect.getDepthImage(),0,0);
    
    stroke(255);
    fill(255);
  }

  void keyPressed() 
  {
    if (key == CODED) 
    {
      if (keyCode == UP) 
      {
        angle++;
      } else if (keyCode == DOWN) 
      {
        angle--;
      }

      angle = constrain(angle, 0, 30);

      kinect.setTilt(angle);
    }
  }
}
