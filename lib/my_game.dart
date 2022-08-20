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
  late GameBoard gameBoard;

  @override
  Future<void> onLoad() async {
    gameBoard = GameBoard();

    add(gameBoard);

    add(
      KeyboardInputHandler(
        realPlayer: gameBoard.realPlayer,
        shadowPlayer: gameBoard.shadowPlayer,
      ),
    );

    camera.viewport = FixedResolutionViewport(gameBoard.size);
  }
}
