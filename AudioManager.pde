import processing.sound.*; //<>//

//Plays audio files
//Can play files as oneshot audio 
//or as loops
//Can play as many instances of one
//To play a clip, first load it via loadFile,
//then play/loop it by its handle.
class AudioManager {
  BrownNoise thruster;
  PApplet sketch;
  ArrayList<AudioClip> clips;

  //Constuctor
  AudioManager(PApplet sketch) {
    this.sketch = sketch;
    clips = new ArrayList<AudioClip>();
  }

  //Loads an audio file from disk, if no file by the
  //same name was loaded before
  void loadFile(String name, String path) {
    AudioClip exists = findClip(name);
    println("name="+name+", exists="+exists);
    if (exists == null) {
      clips.add(new AudioClip(name, path));
    }
  }

  //Plays an audio clip the audio manager knows
  void play(String name) {
    AudioClip toPlay = findClip(name);
    if (toPlay != null) {
      toPlay.play();
    }
  }

  //Plays an audio clip the audio manager knows
  void loop(String name) {
    AudioClip toPlay = findClip(name);
    if (toPlay != null) {
      toPlay.loop();
    }
  }

  void stop(String name) {
    AudioClip toPlay = findClip(name);
    if (toPlay != null) {
      toPlay.stop();
    }
  }

  //Finds a clip by its name
  AudioClip findClip(String name) {
    AudioClip clip = null;
    Iterator i = clips.iterator();
    while (i.hasNext()) {
      AudioClip c = (AudioClip)i.next();
      if (c.name == name) {
        clip=c;
        break;
      }
    }
    return clip;
  }
}

class AudioClip {
  String name;
  SoundFile file;
  boolean isPlaying = false;

  AudioClip(String name, String path) {
    file = new SoundFile(Asteroids_clone.this, path);
    this.name = name;
  }

  void play() {
    file.play();
  }

  void loop() {
    if (!isPlaying) {
      isPlaying=true;
      file.loop();
    }
  }

  void stop() {
    if (isPlaying) {
      isPlaying=false;
      file.stop();
    }
  }
}
