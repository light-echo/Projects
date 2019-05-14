
import netP5.*;
import oscP5.*;
int pdValue; 

class QTsend {

  OscP5 oscP5;
  NetAddress myRemoteLocation;

  QTsend() {
    /* start oscP5, listening for incoming messages at port 12000 */
    oscP5 = new OscP5(this, 12000);


    /* myRemoteLocation is a NetAddress. a NetAddress takes 2 parameters,
     * an ip address and a port number. myRemoteLocation is used as parameter in
     * oscP5.send() when sending osc packets to another computer, device, 
     * application. usage see below. for testing purposes the listening port
     * and the port of the remote location address are the same, hence you will
     * send messages back to this sketch.
     */
    myRemoteLocation = new NetAddress("127.0.0.1", 3107); 
  }

  void send(int x, int y, int z, int f) {

    /* in the following different ways of creating osc messages are shown by example */
    OscMessage myMessage = new OscMessage("/xyz");

    myMessage.add(x); /* add an int to the osc message */
    myMessage.add(y); /* add an int to the osc message */
    myMessage.add(z);
    myMessage.add(f);

    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
  }



  void oscEvent(OscMessage theOscMessage) {
    /* print the address pattern and the typetag of the received OscMessage */
    print("### received an osc message.");
    print(theOscMessage.get(0).intValue()); //prints the value 
    pdValue = theOscMessage.get(0).intValue();
  }
  
   void printPdValue() {
     text("Received Value: "+pdValue, 10,20);
   }
}
