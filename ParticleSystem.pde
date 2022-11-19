import java.util.*;

class ParticleSystem {
  ArrayList<Particle> particles;

  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }

  void run() {
    Iterator<Particle> particleIterator = particles.iterator();

    while (particleIterator.hasNext()) {
      Particle p = particleIterator.next();
      p.update();
      p.display();
      if (p.isDead()){
         particleIterator.remove(); 
      }
    }
  }
}
