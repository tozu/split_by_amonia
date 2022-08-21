import 'package:split/component/player.dart';
import 'package:split/data/player_sprites_path.dart';

class ShadowPlayer extends Player {
  ShadowPlayer()
      : super(
          // TODO(any): add sprites for shadow player
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
      gameRef.realPlayer.border.position = position;
    });
  }
}
