import 'package:flame_audio/flame_audio.dart';

class AudioHandler {
  final _audioFiles = [
    'loosing.wav',
    // 'background.mp3',
  ];

  Future<void> init() async {
    await FlameAudio.audioCache.loadAll(_audioFiles);

    // FlameAudio.createPool();

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

  void destroy() {
    FlameAudio.bgm.dispose();
    FlameAudio.audioCache.clearAll();
  }
}
