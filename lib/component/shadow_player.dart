import 'package:flame/components.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:split/assets.dart';
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
    final miniLibrary = MiniLibrary.fromDataString(ghostLibrary);
    final sprites = await miniLibrary.toSprites(
      color: Colors.white,
      pixelSize: 1,
    );
    animations = {
      AnimationState.idle: SpriteAnimation.spriteList(
        [
          sprites['ghost_front1']!,
        ],
        stepTime: 0.2,
      ),
      AnimationState.movingSide: SpriteAnimation.spriteList(
        [
          sprites['ghost_side1']!,
          sprites['ghost_side2']!,
          sprites['ghost_side3']!,
        ],
        stepTime: 0.2,
      ),
      AnimationState.movingUp: SpriteAnimation.spriteList(
        [
          sprites['ghost_back1']!,
          sprites['ghost_back2']!,
          sprites['ghost_back3']!,
        ],
        stepTime: 0.2,
      ),
      AnimationState.movingDown: SpriteAnimation.spriteList(
        [
          sprites['ghost_front1']!,
          sprites['ghost_front2']!,
          sprites['ghost_front3']!,
        ],
        stepTime: 0.2,
      ),
    };
    position.addListener(() {
      gameRef.realPlayer.border?.position = position;
    });
  }
}
