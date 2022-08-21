import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:split/component/gameboard.dart';
import 'package:split/component/player.dart';
import 'package:split/handler/input_handler.dart';

class MyGame extends FlameGame
    with
        HasTappables,
        KeyboardEvents,
        HasCollisionDetection,
        HasKeyboardHandlerComponents {
  late Player realPlayer;
  late Player shadowPlayer;

  @override
  Future<void> onLoad() async {
    final gameBoard = GameBoard();

    await add(gameBoard);

    realPlayer = gameBoard.realPlayer;
    shadowPlayer = gameBoard.shadowPlayer;

    add(
      KeyboardInputHandler(
        realPlayer: realPlayer,
        shadowPlayer: shadowPlayer,
      ),
    );

    camera.viewport = FixedResolutionViewport(gameBoard.size);
  }
}
