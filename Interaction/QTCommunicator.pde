/////////////////////////////////////////////////////////////////////////
// By QTo3 - Thu Nguyen 
// OSC receiving and sending
// It used OcsP5 library to create OSC communication
//                           ____
//  ________________________/ O  \___/
// <%%%%%%%%%%%%%%%%%%%%%%%%_____/   \
/////////////////////////////////////////////////////////////////////////


import netP5.*;
import oscP5.*;

class QTCommunicator
{

  OscP5 oscP5;
  NetAddress myRemoteLocation;
  int pdValue; 


  //Constructor to set up OSC communication
  QTCommunicator() {
    /* start oscP5, listening for incoming messages at port 12000 */
    oscP5 = new OscP5(this, 12000);


    /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
     * an ip address and a port number. myRemoteLocation is used as parameter in
     * oscP5.send() when sending osc packets to another computer, device, 
     * application. usage see below. for testing purposes the listening port
     * and the port of the remote location address are the same, hence you will
     * send messages back to this sketch.
     */
    myRemoteLocation = new NetAddress("127.0.0.1", 3107); //port 3107 
  }

  void initDefaultData()
  {
    //Whenever this class called by someone, this function called at the beginning. so, please
    // write your initial code here.
  }


  // QTSensor calls every single time whenever the position changed
  // Position are sent via OSC 
  void setPosition(int posX, int posY)

  {
    /* in the following different ways of creating osc messages are shown by example */
    OscMessage myMessage = new OscMessage("/xy");

    myMessage.add(posX); /* add an int to the osc message */
    myMessage.add(posY); /* add an int to the osc message */

    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);     
    println("QTCommunicator received the position "+posX, ","+posY);
  }
  
  
 
  // Received OSC message for instance by PD wit one value and prints the 
  // value and save it as integer 
  void oscEvent(OscMessage theOscMessage) {
    /* print the address pattern and the typetag of the received OscMessage */
    print("### received an osc message.");
    print(theOscMessage.get(0).intValue()); //prints the value 
    pdValue = theOscMessage.get(0).intValue();
  }



  // Interaction module calls this everysingle frame
  void update()
  {
    text("Received Value: "+pdValue, 10,20); // print receive value 
  }
}
