import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:split/assets.dart';

class WinningAnimation extends PositionComponent {
  WinningAnimation({super.position, super.size})
      : super(
          anchor: Anchor.center,
          priority: 4,
        );

  @override
  Future<void> onLoad() async {
    const spriteSize = 80.0;
    final miniZombieLibrary = MiniLibrary.fromDataString(zombieLibrary);
    final zombieSprites = await miniZombieLibrary.toSprites(
      color: Colors.white,
      pixelSize: 1,
    );
    final realPlayer = SpriteAnimationComponent(
      size: Vector2.all(spriteSize),
      anchor: Anchor.center,
      animation: SpriteAnimation.spriteList(
        [
          zombieSprites['zombie_side1']!,
          zombieSprites['zombie_side2']!,
        ],
        stepTime: 0.2,
      ),
    );
    realPlayer.flipHorizontallyAroundCenter();
    final miniGhostLibrary = MiniLibrary.fromDataString(ghostLibrary);
    final ghostSprites = await miniGhostLibrary.toSprites(
      color: Colors.white,
      pixelSize: 1,
    );
    final shadowPlayer = SpriteAnimationComponent(
      size: Vector2.all(spriteSize),
      anchor: Anchor.center,
      animation: SpriteAnimation.spriteList(
        [
          ghostSprites['ghost_side1']!,
          ghostSprites['ghost_side2']!,
          ghostSprites['ghost_side3']!,
        ],
        stepTime: 0.2,
      ),
    );

    final miniWinningLibrary = MiniLibrary.fromDataString(mergeLibrary);
    final winningSprites = await miniWinningLibrary.toSprites(
      color: Colors.white,
      pixelSize: 1,
    );
    final mergedPerson = SpriteAnimationComponent(
      size: Vector2.all(spriteSize),
      anchor: Anchor.center,
      animation: SpriteAnimation.spriteList(
        [
          Sprite(winningSprites['merge_6']!.image),
          Sprite(winningSprites['merge_7']!.image),
        ],
        stepTime: 0.2,
      ),
    );
    final winningMerge = SpriteAnimationComponent(
      size: Vector2.all(spriteSize),
      anchor: Anchor.center,
      //removeOnFinish: true,
      animation: SpriteAnimation.spriteList(
        [
          winningSprites['merge_1']!,
          winningSprites['merge_2']!,
          winningSprites['merge_3']!,
          winningSprites['merge_4']!,
          winningSprites['merge_5']!,
        ],
        stepTime: 0.2,
        loop: false,
      ),
    );
    winningMerge.animation?.onComplete = () {
      add(mergedPerson);
      winningMerge.removeFromParent();
    };

    realPlayer.position = Vector2(20, size.y / 2);
    shadowPlayer.position = Vector2(size.x - 20, size.y / 2);
    winningMerge.position = Vector2(size.x / 2, size.y / 2);
    mergedPerson.position = Vector2(size.x / 2, size.y / 2);
    add(realPlayer);
    add(shadowPlayer);

    realPlayer.add(
      MoveToEffect(
        size / 2,
        EffectController(duration: 5, curve: Curves.linear),
        onComplete: realPlayer.removeFromParent,
      ),
    );
    shadowPlayer.add(
      MoveToEffect(
        size / 2,
        EffectController(duration: 5, curve: Curves.linear),
        onComplete: () {
          shadowPlayer.removeFromParent();
          add(winningMerge);
        },
      ),
    );
  }
}
