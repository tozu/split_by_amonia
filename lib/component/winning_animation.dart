import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:split/component/player.dart';
import 'package:split/component/real_player.dart';
import 'package:split/component/shadow_player.dart';

class WinningAnimation extends PositionComponent {
  WinningAnimation({super.position, super.size}) : super(anchor: Anchor.center);
  @override
  Future<void> onLoad() async {
    final realPlayer = RealPlayer();
    realPlayer.position = Vector2(20, size.y / 2);
    realPlayer.moveToDirection(direction: Direction.east);
    final shadowPlayer = ShadowPlayer();
    shadowPlayer.position = Vector2(size.x - 20, size.y / 2);
    shadowPlayer.moveToDirection(direction: Direction.west);
    addAll([realPlayer, shadowPlayer]);
    realPlayer.add(
      MoveToEffect(
        size / 2,
        EffectController(duration: 3, curve: Curves.easeInOutCubic),
      ),
    );
    shadowPlayer.add(
      MoveToEffect(
        size / 2,
        EffectController(duration: 3, curve: Curves.easeInOutCubic),
      ),
    );
  }
}
