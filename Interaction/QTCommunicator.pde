/////////////////////////////////////////////////////////////////////////
//
//
// Thu, please write your description of this module
//
//
/////////////////////////////////////////////////////////////////////////


class QTCommunicator
{
  
  // write your code here
  
  void initDefaultData()
  {
    //Whenever this class called by someone, this function called at the beginning. so, please
    // write your initial code here.
  }
  
  
  // QTSensor calls every single time whenever the position changed
  void setPosition(int posX,int posY)
  {
     // please impalement your communication code here!
     
      println("QTCommunicator received the position "+posX,","+posY);
  }
  
  // Interaction module calls this everysingle frame
  void update()
  {
    ;
  }
  
}
