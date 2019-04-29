////////////////////////////////////////////////////////////////////////
// Visualization class  for Korea project
// Creates an arraylist of particles that follows x and y pos
// Hanna Thenor Årström
// 28 March 2019
// Ver 1 for testing
/////////////////////////////////////////////////////////////////////////

class QTVisualizer
{
  ArrayList<Particle> particles;
  PVector origin;
  float dist;
  
  void initDefaultData()
  {
    //Whenever this class called by someone, this function called at the beginning. so, please
    // write your initial code here.
    particles = new ArrayList<Particle>();
    dist = 25;
  } 
  
  // QTSensor calls every single time whenever the position changed
  void setPosition(PVector pos)
  {
    
     // please impalement your visual effect here!
    origin = new PVector (random(pos.x-dist, pos.x+dist),random(pos.y-dist, pos.y+dist));
    particles.add(new Particle(origin));
    // println("QTVisualizer received the position "+posX,","+posY);
  }
  
  
  // Interaction module calls this everysingle frame
  void update()
  {  
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      
      p.tempColor = color(random(128,255),random(128,255),random(128,255));;
     
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
  
  
  void setAmplitudes(float [] amplitudes){
  //amplitudes array has four values coming from Olli 
  //you can use them to change the particle tc. 
    float amplitude1 = amplitudes[1]; //...and so on  
  }
  
}

// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color tempColor;
  //float mass;
  

  Particle(PVector l) {
    acceleration = new PVector(0, random(0,0.5));
    velocity = new PVector(0,0);
    position = l.get();
    lifespan = random(125.0, 255.0);
   // mass = 1;
  }



  void run() {
    update();
    display();
  }
//  void applyForce(PVector force) {
//    PVector f = force.get();
//    f.div(mass);
//    acceleration.add(f);
//  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
     lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
   // fill(255, lifespan);
   
   noStroke();
    
    fill(random(0,255),random(0,255),random(0,255), lifespan);
    
    ellipse(position.x, position.y, 15*3, 15*3);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0 ) {
      return true;
    } else {
      return false;
    }
  }
}
