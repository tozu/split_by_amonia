import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:split/component/gameboard.dart';
import 'package:split/handler/input_handler.dart';

class MyGame extends FlameGame
    with
        HasTappables,
        KeyboardEvents,
        HasCollisionDetection,
        HasKeyboardHandlerComponents {
  @override
  Future<void> onLoad() async {
    final gameBoard = GameBoard();

    add(gameBoard);

    add(
      KeyboardInputHandler(
        realPlayer: gameBoard.realPlayer,
        shadowPlayer: gameBoard.shadowPlayer,
      ),
    );

    camera.viewport = FixedResolutionViewport(gameBoard.size);
  }

  /*
      final splitControl = event.logicalKey == LogicalKeyboardKey.keyQ;
      final dualControl = event.logicalKey == LogicalKeyboardKey.keyW;

      if (splitControl) {
        if (mazeOne.player.active && mazeTwo.player.active) {
          mazeTwo.player.setActivation(false);
        } else {
          mazeOne.player.setActivation(!mazeOne.player.active);
          mazeTwo.player.setActivation(!mazeTwo.player.active);
        }
      } else if (dualControl) {
        mazeOne.player.setActivation(true);
        mazeTwo.player.setActivation(true);
      }


   */

}
