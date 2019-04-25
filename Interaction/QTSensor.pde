/////////////////////////////////////////////////////////////////////////
//
// This class is for sensing the position of where people touch and drag
// I can use kinect, radar
// First create by John Lee. 23 Mar 2019
//
//[002] modify code to send position to use PVector
//[003] added transform function
//
/////////////////////////////////////////////////////////////////////////


class QTSensor
{
  PImage depthImg;

  int minDepth =  80;
  int maxDepth = 950;

  int kinectX1, kinectX2, kinectY1, kinectY2;
  int prjX1, prjX2, prjY1, prjY2;

  float angle;

  PVector curPosition;
  PVector curSpeed;
  PVector transformedPosition;

  void initDefaultData()
  {    
    kinectX1 = 210;
    kinectX2 = 400;
    kinectY1 = 130;
    kinectY2 = 290;

    prjX1 = 230;
    prjX2 = 760;
    prjY1 = 200;
    prjY2 = 720;

    curPosition = new PVector(0, 0, 0);
    curSpeed = new PVector(0, 0, 0);
    transformedPosition = new PVector(0,0,0);

    if (SIMULATION_MODE == false)
    {
      angle = kinect.getTilt();

      depthImg = new PImage(kinect.width, kinect.height);
    } else
    {
      angle = 0;
      depthImg = new PImage(width, height);
    }
  }

  float transform(float input, float A, float B, float C, float D)
  {
    float value;

    value = C +((input-A) * (D-C)/(B-A));

    return value;
  }

  void traceMovement()
  {
    int[] rawDepth;
    int newPosX, newPosY, newPosZ;
    int posX, posY;
    int minData = 5000;

    newPosX = 0;
    newPosY = 0;
    newPosZ = 0;

    rawDepth = kinect.getRawDepth();

    for (int i=0; i < rawDepth.length; i++)
    {
      posX = (i % 640);
      posY = (i / 640);

      if (posX > 210 && posX < 400 && posY > 130 && posY < 290)
      {
        //depthImg.pixels[i] = color(255);
        
        //println(newPosX, " , "+newPosY+ " "+rawDepth[i]);
        
        if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) 
        {
           depthImg.pixels[i] = color(255);

          if (rawDepth[i] < minData)
          {
            minData = rawDepth[i];

            newPosX = i % 640;
            newPosY = i/640;

            //println(newPosX, " , "+newPosY);
          }
        } else
        {
          //depthImg.pixels[i] = color(0);
        }
      }else{
        ;//depthImg.pixels[i] = color(0);
      }
    }
    
    newPosX = int(newPosX);// * screenRatio.x)-70;
    newPosY = int(newPosY);// * screenRatio.y)+200;
    
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

       transformedPosition.x = transform(curPosition.x, kinectX1, kinectX2, prjX1, prjX2);
       transformedPosition.y = transform(curPosition.y, kinectY1, kinectY2, prjY1, prjY2);
       
       ellipse(transformedPosition.x, transformedPosition.y, 50, 50);
       
       myVisualizer.setPosition(curPosition);
       myCommunicator.setPosition(transformedPosition);
    } else
    {
       ;//ellipse(mouseX,mouseY , 50,50);
    }

    //image(kinect.getDepthImage(),0,0);

    stroke(255);
    fill(255);
    
    text("test",300,300);
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
