import 'package:split/component/player.dart';
import 'package:split/data/player_sprites_path.dart';

class RealPlayer extends Player {
  RealPlayer()
      : super(
          PlayerSpritesPath(
            idle: 'playerIdle',
            moving: 'playerMoving',
            crashing: 'playerCrashing',
          ),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position.addListener(() {
      gameRef.shadowPlayer.border.position = position;
    });
  }
}
