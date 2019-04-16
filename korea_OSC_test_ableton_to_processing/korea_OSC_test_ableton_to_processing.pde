import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

//raw values (don't use these)

float amplitude1 = 0;
float amplitude2 = 0;
float amplitude3 = 0;
float amplitude4 = 0;


//smoothed out values (use these)

float A1 = 0;
float A2 = 0;
float A3 = 0;
float A4 = 0;

//smoothing amount (the smaller the smoother, 1 is maximum)

float smooth_factor = 0.05;

void setup() {
  oscP5 = new OscP5(this, 12000); 
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}

void draw() {

  //add these to wherever the visuals are being generated
  A1 += (amplitude1 - A1) * smooth_factor;
  A2 += (amplitude2 - A2) * smooth_factor;
  A3 += (amplitude3 - A3) * smooth_factor;
  A4 += (amplitude4 - A4) * smooth_factor;
}


//OSC message function, add this anywhere

void oscEvent(OscMessage theOscMessage) 
{
  if (theOscMessage.checkAddrPattern("/amp")==true)
  {
    amplitude1 = theOscMessage.get(0).floatValue();
  }
  if (theOscMessage.checkAddrPattern("/amp2")==true)
  {
    amplitude2 = theOscMessage.get(0).floatValue();
  }
  if (theOscMessage.checkAddrPattern("/amp3")==true)
  {
    amplitude3 = theOscMessage.get(0).floatValue();
  }
  if (theOscMessage.checkAddrPattern("/amp4")==true)
  {
    amplitude4 = theOscMessage.get(0).floatValue();
  }
}
