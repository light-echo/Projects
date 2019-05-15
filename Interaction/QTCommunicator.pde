/////////////////////////////////////////////////////////////////////////
// By QTo3 - Thu Nguyen 
// OSC receiving and sending
// It used OcsP5 library to create OSC communication
//                           ____
//  ________________________/ O  \___/
// <%%%%%%%%%%%%%%%%%%%%%%%%_____/   \
/////////////////////////////////////////////////////////////////////////



class QTCommunicator
{

  OscP5 oscP5;
  NetAddress myRemoteLocation;
  //float amplitude1 = 0;
  //float amplitude2 = 0;
  //float amplitude3 = 0;
  //float amplitude4 = 0;

  float A1 = 0;
  float A2 = 0;
  float A3 = 0;
  float A4 = 0;

  float smooth_factor = 0.05;

  //Constructor to set up OSC communication
  QTCommunicator() {
  }

  void initDefaultData()
  {
    //set up for class 
    /* start oscP5, listening for incoming messages at port 12000 */
    oscP5 = new OscP5(this, 12000);


    /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
     * an ip address and a port number. myRemoteLocation is used as parameter in
     * oscP5.send() when sending osc packets to another computer, device, 
     * application. usage see below. for testing purposes the listening port
     * and the port of the remote location address are the same, hence you will
     * send messages back to this sketch.
     */
   // myRemoteLocation = new NetAddress("10.100.58.244", 3107); //port 3107
    
   // myRemoteLocation = new NetAddress("127.0.0.1", 3107); //port 3107
    
    myRemoteLocation = new NetAddress("10.100.48.13", 3107); //port 3107
    
    println("its working");
  }


  // QTSensor calls every single time whenever the position changed
  // Position are sent via OSC 
  void setPosition(PVector pos)
  {
    /* in the following different ways of creating osc messages are shown by example */
    OscMessage myMessage = new OscMessage("/xyz");

    myMessage.add(pos.x); /* add an int to the osc message */
    myMessage.add(pos.y); /* add an int to the osc message */
    myMessage.add(pos.z); /* add an int to the osc message */


    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);     
   // println("QTCommunicator received the position "+pos.x, ","+pos.y);
  }



  // Received OSC message for instance by PD wit one value and prints the 
  // value and save it as integer 
  void oscEvent(OscMessage theOscMessage) {
    /* print the address pattern and the typetag of the received OscMessage */
    print("### received an osc message.");
    if (theOscMessage.checkAddrPattern("/amp")==true)
    {
      float amplitude1 = theOscMessage.get(0).floatValue();
      //add these to wherever the visuals are being generated
      A1 += (amplitude1 - A1) * smooth_factor;
    }
    if (theOscMessage.checkAddrPattern("/amp2")==true)
    {
      float amplitude2 = theOscMessage.get(0).floatValue();
      A2 += (amplitude2 - A2) * smooth_factor;
    }
    if (theOscMessage.checkAddrPattern("/amp3")==true)
    {
      float amplitude3 = theOscMessage.get(0).floatValue();
      A3 += (amplitude3 - A3) * smooth_factor;
    }
    if (theOscMessage.checkAddrPattern("/amp4")==true)
    {
      float amplitude4 = theOscMessage.get(0).floatValue();
      A4 += (amplitude4 - A4) * smooth_factor;
    }
  }

  float[] getAmplitudes() {
    float[] tmp =  {A1, A2, A3, A4}; 
    return tmp;
  }
  

  // Interactive module calls this everysingle frame
  void update()
  {
   ;// text("Received Value: "+A1+A2+A3+A4, 10, 20); // print receive value
  }
}
