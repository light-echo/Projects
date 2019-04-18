/////////////////////////////////////////////////////////////////////////
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
  void setPosition(int posX,int posY)
  {
     // please impalement your visual effect here!
    origin = new PVector (random(posX-dist, posX+dist),random(posY-dist, posY+dist));
    particles.add(new Particle(origin));
    // println("QTVisualizer received the position "+posX,","+posY);
  }
  
  
  // Interaction module calls this everysingle frame
  void update()
  {  
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
     
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
  
}

// A simple Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
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
    fill(255, lifespan);
    ellipse(position.x, position.y, 15, 15);
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
