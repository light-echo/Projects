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

  int minDepth =  740;
  int maxDepth = 840;

  int kinectX1, kinectX2, kinectY1, kinectY2;
  int prjX1, prjX2, prjY1, prjY2;

  float angle;
  float acc;

  PVector curPosition;
  PVector curSpeed;
  PVector transformedPosition;

  void initDefaultData()
  {        
    kinectX1 = 160;
    kinectY1 = 107;
    kinectX2 = 500;
    kinectY2 = 304;

    prjX1 = 0;
    prjY1 = 0;
    prjX2 = width;
    prjY2 = height;
    
    acc = 20;

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
    
    println("TEST  "+transform(kinectX1, kinectX1, kinectX2, prjX1, prjX2));
    println("TEST  "+transform(kinectX2, kinectX1, kinectX2, prjX1, prjX2));
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

      if (posX >= kinectX1 && posX <= kinectX2 && posY >= kinectY1 && posY <= kinectY2)
      {
         depthImg.pixels[i] = color(255);
        
        //println(newPosX, " , "+newPosY+ " "+rawDepth[i]);
        
        if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) 
        {
           depthImg.pixels[i] = color(255);

          if (rawDepth[i] < minData)
          {
            minData = rawDepth[i];

            newPosX = i % 640;
            newPosY = i/640;

           // println(newPosX, " , "+minData);
          }
        } 
      }
    }
    
    newPosX = int(newPosX);// * screenRatio.x)-70;
    newPosY = int(newPosY);// * screenRatio.y)+200;
    newPosZ = minData;
    
    //println(screenRatio);

    depthImg.updatePixels();

    curSpeed.x = (newPosX - curPosition.x) / acc;
    curSpeed.y = (newPosY - curPosition.y) / acc;
    curSpeed.z = (newPosZ - curPosition.z) / acc;

    curPosition.add(curSpeed);
  }

  void update() 
  {
    fill(0, 20);

    //rect(0, 0, width, height);

    stroke(255);

    fill(0, 255, 0);

    if (SIMULATION_MODE == false)
    {
       traceMovement();

       transformedPosition.x = transform(curPosition.x, kinectX1, kinectX2, prjX1, prjX2);
       transformedPosition.y = transform(curPosition.y, kinectY1, kinectY2, prjY1, prjY2);
       transformedPosition.z = constrain(map(curPosition.z,minDepth,maxDepth,100,0),0,100);
       
       //transformedPosition.set(mouseX, mouseY, 0);
       
      // transformedPosition.set(478,438, 0);
       
       //ellipse(transformedPosition.x, transformedPosition.y, 50, 50);
       
       //myVisualizer.setPosition(transformedPosition);
       
       //transformedPosition.x = mouseX+random(10,20);
       //transformedPosition.y = mouseY+random(10,20);
       
       //transformedPosition.x = 550;
       //transformedPosition.y 26328;
       
       myVisualizer_3.setPosition(transformedPosition);
       
      // println(transformedPosition);
       
       //myVisualizer_2.setPosition(transformedPosition);
       myCommunicator.setPosition(transformedPosition);
    } else
    {
       ;//ellipse(mouseX,mouseY , 50,50);
    }

    //image(depthImg,0,0);

    stroke(255);
    fill(255,0,0);
  //  rect(prjX1,prjY1, prjX2 - prjX1 , prjY2 - prjY1);
    
    fill(255);
    textSize(50);
   // text(transformedPosition.z,300,300);
    
   // text((int)transformedPosition.x+" "+(int)transformedPosition.y,300,350);
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
