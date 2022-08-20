import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split/component/maze.dart';
import 'package:split/component/player.dart';

class MyGame extends FlameGame with HasTappables, KeyboardEvents {
  // TODO(any): add collision to game

  final mazeOnePosition = Vector2(50, 50);
  static const mazeGap = 10;

  late Maze mazeOne;
  late Maze mazeTwo;

  @override
  Future<void> onLoad() async {
    final realPlayer = RealPlayer();
    final shadowPlayer = ShadowPlayer();

    // TODO(Tobias): extract into separate GameBoard class
    mazeOne = Maze(
      realPlayer,
      position: mazeOnePosition,
    );
    mazeTwo = Maze(
      shadowPlayer,
      position: Vector2(mazeOnePosition.x + mazeOne.width + mazeGap, 50),
    );

    add(mazeOne);
    add(mazeTwo);

    final gameSize = Vector2(
      mazeOne.size.x * 2 + mazeGap + mazeOne.position.x * 2,
      mazeOne.size.y + mazeOne.position.y * 2,
    );

    camera.viewport = FixedResolutionViewport(gameSize);
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
        mazeOne.player.moveWest(true);
        mazeTwo.player.moveWest(true);
        return KeyEventResult.handled;
      } else if (isRight) {
        mazeOne.player.moveEast(true);
        mazeTwo.player.moveEast(true);
        return KeyEventResult.handled;
      } else if (isUp) {
        mazeOne.player.moveNorth(true);
        mazeTwo.player.moveNorth(true);
        return KeyEventResult.handled;
      } else if (isDown) {
        mazeOne.player.moveSouth(true);
        mazeTwo.player.moveSouth(true);
        return KeyEventResult.handled;
      }
    } else if (isKeyUp) {
      if (isLeft) {
        mazeOne.player.moveWest(false);
        mazeTwo.player.moveWest(false);
        return KeyEventResult.handled;
      } else if (isRight) {
        mazeOne.player.moveEast(false);
        mazeTwo.player.moveEast(false);
        return KeyEventResult.handled;
      } else if (isUp) {
        mazeOne.player.moveNorth(false);
        mazeTwo.player.moveNorth(false);
        return KeyEventResult.handled;
      } else if (isDown) {
        mazeOne.player.moveSouth(false);
        mazeTwo.player.moveSouth(false);
        return KeyEventResult.handled;
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
