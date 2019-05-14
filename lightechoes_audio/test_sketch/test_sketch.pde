QTsend sender;

int mousePressedNum = 0;
int eSize = 0;
void setup()
{
  //fullScreen();
  size(800, 600); 
  sender = new QTsend();
}


void draw()
{
  background(0); 
  ellipseMode(CENTER);  
  ellipse(mouseX, mouseY, eSize, eSize);
  sender.send(mouseX, mouseY, eSize, mousePressedNum);
  sender.printPdValue();

  if (mousePressed == true) {
    mousePressedNum = 1;
    eSize = eSize+1;
    
  } if (mousePressed == false && eSize >0) {
    mousePressedNum = 0;
    eSize = eSize-10;
    if (eSize < 10){
      eSize = 0;
    }
    
  }
  
}
// Click within the image to change 
// the value of the rectangle
