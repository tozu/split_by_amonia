import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:split/component/player.dart';
import 'package:split/component/tile.dart';
import 'package:split/my_game.dart';

class PlayerBorder extends RectangleComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  final int borderReach;
  final Player player;

  PlayerBorder({required this.player, this.borderReach = 5})
      : super(
          size: Vector2(
            borderReach * Tile.spriteSize,
            borderReach * Tile.spriteSize,
          ),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    position = player.position;
    add(RectangleHitbox());
    paint = BasicPalette.white.paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    add(
      SequenceEffect(
        [
          MoveByEffect(
            Vector2(3, 2),
            NoiseEffectController(
              duration: 0.2,
              frequency: 1,
            ),
          ),
          RotateEffect.to(
            0.1,
            NoiseEffectController(
              duration: 0.2,
              frequency: 1,
            ),
          )
        ],
        infinite: true,
      ),
    );
    add(
      ScaleEffect.by(
        Vector2.all(1.05),
        EffectController(
          duration: 1,
          infinite: true,
          alternate: true,
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}
