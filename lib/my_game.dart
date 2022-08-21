import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:split/component/gameboard.dart';
import 'package:split/component/player.dart';
import 'package:split/handler/input_handler.dart';

import 'component/winning_animation.dart';

class MyGame extends FlameGame
    with
        HasTappables,
        KeyboardEvents,
        HasCollisionDetection,
        HasKeyboardHandlerComponents {
  late Player realPlayer;
  late Player shadowPlayer;
  bool winningState = false;
  bool loosingState = false;

  @override
  Future<void> onLoad() async {
    final gameBoard = GameBoard();

    add(WinningAnimation(size: size, position: size / 2));
    await add(gameBoard);

    realPlayer = gameBoard.realPlayer;
    shadowPlayer = gameBoard.shadowPlayer;

    add(
      KeyboardInputHandler(
        realPlayer: realPlayer,
        shadowPlayer: shadowPlayer,
        panel: gameBoard.controlModePanel,
      ),
    );

    camera.viewport = FixedResolutionViewport(gameBoard.size);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (winningState) {
      print("you've won!");
    }
  }
}
