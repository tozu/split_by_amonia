import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:split/component/player.dart';

class KeyboardInputHandler extends KeyboardListenerComponent {
  final Player _realPlayer;
  final Player _shadowPlayer;

  KeyboardInputHandler({
    required Player realPlayer,
    required Player shadowPlayer,
  })  : _realPlayer = realPlayer,
        _shadowPlayer = shadowPlayer;

  @override
  bool onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    super.onKeyEvent(event, keysPressed);
    final isLeft = event.logicalKey == LogicalKeyboardKey.arrowLeft;
    final isRight = event.logicalKey == LogicalKeyboardKey.arrowRight;
    final isUp = event.logicalKey == LogicalKeyboardKey.arrowUp;
    final isDown = event.logicalKey == LogicalKeyboardKey.arrowDown;

    final isKeyDown = event is RawKeyDownEvent;
    final isKeyUp = event is RawKeyUpEvent;

    if (isKeyDown) {
      if (isLeft) {
        movePlayers(direction: Direction.west);
      } else if (isRight) {
        movePlayers(direction: Direction.east);
      } else if (isUp) {
        movePlayers(direction: Direction.north);
      } else if (isDown) {
        movePlayers(direction: Direction.south);
      }
    } else if (isKeyUp) {
      movePlayers(direction: null);
    }

    return false;
  }

  void movePlayers({required Direction? direction}) {
    _realPlayer.moveToDirection(direction: direction);
    _shadowPlayer.moveToDirection(direction: direction);
  }
}
