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
  
  int minDepth = 890;
  int maxDepth = 900;
  
  PVector textPos;
  
  boolean displayKinectImage;
  
  float angle;
  
  void setup()
  {
    //size(800,500,P2D);
  
    fullScreen(P2D, 1);
  
    background(0);
  
    stroke(255);
  
    noFill();
  
    textPos = new PVector(0, 0);
  
    initKinect();
  }
  
  void initKinect()
  {  
    displayKinectImage = true;
    
    kinect = new Kinect(this);
    kinect.initDepth();
    angle = kinect.getTilt();
  
    // Blank image
    depthImg = new PImage(kinect.width, kinect.height);
  
    println("Kinect resolution "+ kinect.width, kinect.height);
  }
  
  float transform(float input, float A, float B, float C, float D)
  {
    float value;
  
    value = C +((input-A) * (D-C)/(B-A));
  
    return value;
  }
  
  void draw()
  {
    int index;
    int depth;
    int[] rawDepth;
    
    background(0);
    
    depth = 0;
    
    rawDepth = kinect.getRawDepth();
    
    index = (mouseX+(mouseY * 640));
    
    for (int i=0;i<rawDepth.length;i++)
    {
      depth = rawDepth[i];
      
      if (depth >= minDepth && depth <= maxDepth)
      {
        depthImg.pixels[i] = color((int)map(rawDepth[i],minDepth,maxDepth,0,255));
      }else{
        depthImg.pixels[i] = color(0);
      }
    }
    
    if (index < (640*480))
    {
      index = (mouseX+(mouseY * 640));
      
      depth = rawDepth[index];
    }
    
    
    if (displayKinectImage == true)
    {
    noFill();
    stroke(255);
    
    rect(0,0,kinect.width,kinect.height);
      
    depthImg.updatePixels();  
  
    image(depthImg,0,0);
    }
  
    textSize(25);
    fill(255);
  
    fill(255); // kinect
    text("Pos:",        textPos.x, textPos.y+20);
    text(mouseX+" , "+mouseY, textPos.x+60, textPos.y+20);
      
    text("Depth: "+depth,  textPos.x, textPos.y+90);
    text("Min Depth: "+minDepth,  textPos.x, textPos.y+130);
    text("Max Depth: "+maxDepth,  textPos.x, textPos.y+170);
  
    noFill();
    //fill(0, 0, 255);
    
    strokeWeight(2);
    stroke(0,0,255);
    
    line(mouseX,mouseY-20,mouseX,mouseY+20);
    line(mouseX-20,mouseY,mouseX+20,mouseY);
  
  
    noFill();
    strokeWeight(3);
    //rect(190+200,110+200,400-180,420-110);
  
    strokeWeight(1);
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
    } else if (key == 'a') {
      minDepth = constrain(minDepth+5, 0, maxDepth);
    } else if (key == 's') {
      minDepth = constrain(minDepth-5, 0, maxDepth);
    } else if (key == 'z') {
      maxDepth = constrain(maxDepth+5, minDepth, 2047);
    } else if (key =='x') {
      maxDepth = constrain(maxDepth-5, minDepth, 2047);
    }
    
    if (key == 'f'){
      textPos.set(mouseX,mouseY);
    }
    
    if (key == 'k'){
      displayKinectImage = !displayKinectImage;
    }
  }
