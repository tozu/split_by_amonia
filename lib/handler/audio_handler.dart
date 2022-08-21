import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioHandler {
  late List<String> _audioFiles;

  late AudioPool _step;
  late AudioPool _crash;

  // late AudioPool _stepZombie;
  // late AudioPool _stepGhost;

  // audio
  final String backgroundMusic = 'theme-v3.wav';
  final String loosingSound = 'loosing.wav';
  final String winningSound = 'winning.wav';

  // effects
  final String stepSound = 'steps-2.wav';
  final String crashingSound = 'bump.wav'; // 'bump-2.wav';  //or this one
  // final String stepGhostSound = 'step-ghost.mp3';
  // final String stepZombieSound = 'step-zombie.mp3';

  // Audio

  Future<void> init() async {
    _audioFiles = [
      backgroundMusic,
      loosingSound,
      winningSound,
    ];

    await FlameAudio.audioCache.loadAll(_audioFiles);

    // kick start background music observer
    FlameAudio.bgm.initialize();
  }

  void playBackgroundMusic({double? volume}) {
    _playBackground(backgroundMusic, volume: volume);
  }

  void stopBackgroundMusic() {
    FlameAudio.bgm.stop();
  }

  void _playBackground(String musicFile, {double? volume}) {
    FlameAudio.bgm.play(musicFile, volume: volume ?? 0.25);
  }

  void playWinning() {
    _playBackground(winningSound);
  }

  void playLoosing() {
    _playBackground(loosingSound);
  }

  // Sound effects

  Future<void> initializeSoundEffects() async {
    _step = await _initializeSoundEffect(stepSound);
    _crash = await _initializeSoundEffect(crashingSound);
    // _stepZombie = await _initializeSoundEffect(stepGhostSound);
    // _stepGhost = await _initializeSoundEffect(stepZombieSound);
  }

  Future<AudioPool> _initializeSoundEffect(String sound) async =>
      AudioPool.create('audio/$sound', maxPlayers: 10);

  void playCrash() {
    _crash.start();
  }

  void playStep() {
    _step.start();
  }

  // void playStepZombie() {
  //   _stepZombie.start();
  // }
  //
  // void playStepGhost() {
  //   _stepGhost.start();
  // }

  void destroy() {
    FlameAudio.bgm.dispose();
    FlameAudio.audioCache.clearAll();
  }
}
