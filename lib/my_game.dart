import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:split/component/gameboard.dart';
import 'package:split/component/loosing_screen.dart';
import 'package:split/component/player.dart';
import 'package:split/component/start_component.dart';
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
  bool loosingState = false;
  bool winningState = false;
  bool lost = false;
  bool won = false;
  final audioHandler = AudioHandler();

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    if (winningState && !won) {
      await audioHandler.stopBackgroundMusic();
      await audioHandler.playWinning();
      won = true;
      add(VictoryScreen(size: Vector2(300, 300)));
    }
    if (loosingState && !lost) {
      await audioHandler.stopBackgroundMusic();
      add(LoosingScreen());
      lost = true;
    }
  }

  @override
  Future<void> onLoad() async {
    add(StartScreen());
  }

  Future<void> init() async {
    await audioHandler.init();
    await audioHandler.initializeSoundEffects();

    final gameBoard = GameBoard(audio: audioHandler);

    await add(gameBoard);

    realPlayer = gameBoard.realPlayer;
    shadowPlayer = gameBoard.shadowPlayer;

    add(
      KeyboardInputHandler(
        realPlayer: realPlayer,
        shadowPlayer: shadowPlayer,
        panel: gameBoard.controlModePanel,
        audio: audioHandler,
      ),
    );

    camera.viewport = FixedResolutionViewport(gameBoard.size);

    audioHandler.playBackgroundMusic();
  }

  void restart() {
    audioHandler.stopBackgroundMusic();
    removeAll(children);
    loosingState = false;
    winningState = false;
    init();
  }
}
