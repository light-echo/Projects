/////////////////////////////////////////////////////////////////////////
//
//
// This class is for sensing the position of where people touch and drag
// I can use kinect, radar
// First create by John Lee. 23 Mar 2019
//
//
/////////////////////////////////////////////////////////////////////////


class QTSensor
{
  PImage depthImg;

  int minDepth =  60;
  int maxDepth = 850;

  int posX, posY;
  int prevX, prevY;

  float speedX, speedY;

  float angle;
  
  void initDefaultData()
  {
    
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
      
    posX = 0;
    posY = 0;

    prevX = 0;
    prevY = 0;

    speedX = 0;
    speedY = 0;
  }
    
  void traceMovement()
  {
    int[] rawDepth;
    int newPosX, newPosY;
    int minData = 5000;

    newPosX = 0;
    newPosY = 0;

    rawDepth = kinect.getRawDepth();

    for (int i=0; i < rawDepth.length; i++)
    {
      if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) 
      {
        depthImg.pixels[i] = color(255);

        if (rawDepth[i] < minData)
        {
          minData = rawDepth[i];

          newPosX = i % 640;
          newPosY = i/640;
        }
      } else
      {
        depthImg.pixels[i] = color(0);
      }
    }

    depthImg.updatePixels();

    speedX = (newPosX - posX) / 10.0;
    speedY = (newPosY - posY) / 10.0;

    posX += speedX;
    posY += speedY;
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

      image(depthImg, 0, 0);
      
      ellipse(posX, posY, 50, 50);
    }
    else
    {
      ellipse(mouseX,mouseY , 50,50);
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
