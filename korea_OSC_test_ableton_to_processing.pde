import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float amplitude1 = 0;
float amplitude2 = 0;
float amplitude3 = 0;
float amplitude4 = 0;

float A1 = 0;
float A2 = 0;
float A3 = 0;
float A4 = 0;

float smooth_factor = 0.05;

void setup() {
  oscP5 = new OscP5(this, 12000); 
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}

void draw() {
  A1 += (amplitude1 - A1) * smooth_factor;
  A2 += (amplitude2 - A2) * smooth_factor;
  A3 += (amplitude3 - A3) * smooth_factor;
  A4 += (amplitude4 - A4) * smooth_factor;
}
