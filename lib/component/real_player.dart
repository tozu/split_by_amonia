import 'package:flame/components.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:split/assets.dart';
import 'package:split/component/player.dart';
import 'package:split/data/player_sprites_path.dart';
import 'package:split/handler/audio_handler.dart';

class RealPlayer extends Player {
  RealPlayer(AudioHandler audioHandler)
      : super(
          PlayerSpritesPath(
            idle: 'playerIdle',
            moving: 'playerMoving',
            crashing: 'playerCrashing',
          ),
          audioHandler,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final miniLibrary = MiniLibrary.fromDataString(zombieLibrary);
    final sprites = await miniLibrary.toSprites(
      color: Colors.white,
      pixelSize: 1,
    );
    animations = {
      AnimationState.idle: SpriteAnimation.spriteList(
        [
          sprites['zombie_front']!,
        ],
        stepTime: 0.2,
      ),
      AnimationState.movingSide: SpriteAnimation.spriteList(
        [
          sprites['zombie_side1']!,
          sprites['zombie_side2']!,
        ],
        stepTime: 0.2,
      ),
      AnimationState.movingUp: SpriteAnimation.spriteList(
        [
          sprites['zombie_back_walk1']!,
          sprites['zombie_back_walk2']!,
        ],
        stepTime: 0.2,
      ),
      AnimationState.movingDown: SpriteAnimation.spriteList(
        [
          sprites['zombie_front_walk1']!,
          sprites['zombie_front_walk2']!,
        ],
        stepTime: 0.2,
      ),
    };
    position.addListener(() {
      gameRef.shadowPlayer.border.position = position;
    });
  }
}
