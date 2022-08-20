import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split/component/gameboard.dart';
import 'package:split/component/player.dart';

class MyGame extends FlameGame
    with HasTappables, KeyboardEvents, HasCollisionDetection {
  late GameBoard gameBoard;

  late Player realPlayer;
  late Player shadowPlayer;

  @override
  Future<void> onLoad() async {
    gameBoard = GameBoard();
    realPlayer = gameBoard.realPlayer;
    shadowPlayer = gameBoard.shadowPlayer;

    add(gameBoard);

    camera.viewport = FixedResolutionViewport(gameBoard.size);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    // TODO(any): HasKeyboardHandlerComponents instead
    final isLeft = event.logicalKey == LogicalKeyboardKey.arrowLeft;
    final isRight = event.logicalKey == LogicalKeyboardKey.arrowRight;
    final isUp = event.logicalKey == LogicalKeyboardKey.arrowUp;
    final isDown = event.logicalKey == LogicalKeyboardKey.arrowDown;

    final isKeyDown = event is RawKeyDownEvent;
    final isKeyUp = event is RawKeyUpEvent;

    if (isKeyDown) {
      if (isLeft) {
        realPlayer.moveWest(true);
        shadowPlayer.moveWest(true);
        return KeyEventResult.handled;
      } else if (isRight) {
        realPlayer.moveEast(true);
        shadowPlayer.moveEast(true);
        return KeyEventResult.handled;
      } else if (isUp) {
        realPlayer.moveNorth(true);
        shadowPlayer.moveNorth(true);
        return KeyEventResult.handled;
      } else if (isDown) {
        realPlayer.moveSouth(true);
        shadowPlayer.moveSouth(true);
        return KeyEventResult.handled;
      }
    } else if (isKeyUp) {
      if (isLeft) {
        realPlayer.moveWest(false);
        shadowPlayer.moveWest(false);
        return KeyEventResult.handled;
      } else if (isRight) {
        realPlayer.moveEast(false);
        shadowPlayer.moveEast(false);
        return KeyEventResult.handled;
      } else if (isUp) {
        realPlayer.moveNorth(false);
        shadowPlayer.moveNorth(false);
        return KeyEventResult.handled;
      } else if (isDown) {
        realPlayer.moveSouth(false);
        shadowPlayer.moveSouth(false);
        return KeyEventResult.handled;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
