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
    final isLeft = event.logicalKey == LogicalKeyboardKey.arrowLeft;
    final isRight = event.logicalKey == LogicalKeyboardKey.arrowRight;
    final isUp = event.logicalKey == LogicalKeyboardKey.arrowUp;
    final isDown = event.logicalKey == LogicalKeyboardKey.arrowDown;

    final isKeyDown = event is RawKeyDownEvent;
    final isKeyUp = event is RawKeyUpEvent;

    if (isKeyDown) {
      if (isLeft) {
        movePlayersWest(shouldMove: true);
      } else if (isRight) {
        movePlayersEast(shouldMove: true);
      } else if (isUp) {
        movePlayersNorth(shouldMove: true);
      } else if (isDown) {
        movePlayersSouth(shouldMove: true);
      }
    } else if (isKeyUp) {
      if (isLeft) {
        movePlayersWest(shouldMove: false);
      } else if (isRight) {
        movePlayersEast(shouldMove: false);
      } else if (isUp) {
        movePlayersNorth(shouldMove: false);
      } else if (isDown) {
        movePlayersSouth(shouldMove: false);
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void movePlayersSouth({
    required bool shouldMove,
  }) {
    _realPlayer.moveSouth(shouldMove);
    _shadowPlayer.moveSouth(shouldMove);
  }

  void movePlayersNorth({
    required bool shouldMove,
  }) {
    _realPlayer.moveNorth(shouldMove);
    _shadowPlayer.moveNorth(shouldMove);
  }

  void movePlayersEast({
    required bool shouldMove,
  }) {
    _realPlayer.moveEast(shouldMove);
    _shadowPlayer.moveEast(shouldMove);
  }

  void movePlayersWest({
    required bool shouldMove,
  }) {
    _realPlayer.moveWest(shouldMove);
    _shadowPlayer.moveWest(shouldMove);
  }
}
