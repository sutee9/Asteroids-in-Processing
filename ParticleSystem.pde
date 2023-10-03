import java.util.*;

class ParticleSystem {
  ArrayList<Particle> particles;
  boolean running = false;

  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }

  void start(float centerX, float centerY, int lifetime) {
    running = true;
    for (int i=0; i < 50; i++) {
      float angle = random(0, TWO_PI);
      PVector dir= new PVector(sin(angle), cos(angle));
      particles.add(
        new Particle(
          new PVector(centerX, centerY), //position
          dir.mult(random(1, 3)), //velocity
          new PVector(dir.x*-1/(float)lifetime, dir.y*-1/(float)lifetime), //acceleration
          lifetime)
        );
    }
  }

  void stop() {
    running = false;
  }

  void run() {
    if (running) {
      Iterator<Particle> particleIterator = particles.iterator();

      while (particleIterator.hasNext()) {
        Particle p = particleIterator.next();
        p.update();
        p.display();
        if (p.isDead()) {
          particleIterator.remove();
        }
      }

      if (particles.size() == 0) {
        stop();
      }
    }
  }
}
