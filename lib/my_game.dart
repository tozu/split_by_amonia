import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:split/component/gameboard.dart';
import 'package:split/component/player.dart';
import 'package:split/component/victory_screen.dart';
import 'package:split/handler/audio_handler.dart';
import 'package:split/handler/input_handler.dart';

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
  bool won = false;
  final audioHandler = AudioHandler();

  @override
  void update(double dt) {
    super.update(dt);
    if (winningState && !won) {
      won = true;
      add(VictoryScreen());
    }
  }

  @override
  Future<void> onLoad() async {
    init();
  }

  void init() async {
    await audioHandler.init();
    final gameBoard = GameBoard();

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

    audioHandler.playBackgroundMusic();
  }

  void restart() {
    audioHandler.stopBackgroundMusic();
    removeAll(children);
    init();
  }

  @override
  void onRemove() async {
    super.onRemove();
  }
}
