import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioHandler {
  final _audioFiles = [
    // 'background.mp3',
    'loosing.wav',
    // 'winning.mp3',
  ];

  late AudioPool _step;
  late AudioPool _crash;
  late AudioPool _stepZombie;
  late AudioPool _stepGhost;

  final String stepSound = 'step.mp3';
  final String crashingSound = 'crashing.mp3';
  final String stepGhostSound = 'step-ghost.mp3';
  final String stepZombieSound = 'step-zombie.mp3';

  // background music (stop when winning/loosing)

  Future<void> init() async {
    await FlameAudio.audioCache.loadAll(_audioFiles);

    // kick start background music observer
    FlameAudio.bgm.initialize();
  }

  void playBackgroundMusic({double? volume}) {
    _playBackground('loosing.wav', volume: volume);
    // _playBackground('background.mp3', volume: volume);
  }

  void stopBackgroundMusic() {
    FlameAudio.bgm.stop();
  }

  void _playBackground(String musicFile, {double? volume}) {
    FlameAudio.bgm.play(musicFile, volume: volume ?? 0.25);
  }

  Future<void> initializeSoundEffects() async {
    _step = await _initializeSoundEffect(stepSound);
    _crash = await _initializeSoundEffect(crashingSound);
    _stepZombie = await _initializeSoundEffect(stepGhostSound);
    _stepGhost = await _initializeSoundEffect(stepZombieSound);
  }

  Future<AudioPool> _initializeSoundEffect(String sound) async =>
      AudioPool.create(sound, maxPlayers: 10);

  void playCrash() {
    _crash.start();
  }

  void playStep() {
    _step.start();
  }

  void playStepZombie() {
    _stepZombie.start();
  }

  void playStepGhost() {
    _stepGhost.start();
  }

  void destroy() {
    FlameAudio.bgm.dispose();
    FlameAudio.audioCache.clearAll();
  }
}
