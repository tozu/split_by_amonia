import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:split/component/control_model_panel.dart';
import 'package:split/component/player.dart';
import 'package:split/handler/audio_handler.dart';

class KeyboardInputHandler extends KeyboardListenerComponent {
  final Player _realPlayer;
  final Player _shadowPlayer;
  final ControlModePanel panel;
  final AudioHandler audio;

  KeyboardInputHandler({
    required Player realPlayer,
    required Player shadowPlayer,
    required this.panel,
    required this.audio,
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

    final splitControl = event.logicalKey == LogicalKeyboardKey.keyQ;
    final dualControl = event.logicalKey == LogicalKeyboardKey.keyW;

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
      } else if (splitControl) {
        if (_realPlayer.isManualModeActive &&
            _shadowPlayer.isManualModeActive) {
          // enable manual mode for real player
          _shadowPlayer.enableManualMode(false);
        } else {
          // enable manual mode for shadow player
          _realPlayer.enableManualMode(!_realPlayer.isManualModeActive);
          _shadowPlayer.enableManualMode(!_shadowPlayer.isManualModeActive);
        }

        final activePlayer =
            _realPlayer.isManualModeActive ? _realPlayer : _shadowPlayer;

        // update control panel with player info
        panel.updateControlMode(mode: ControlMode.single, player: activePlayer);
      } else if (dualControl) {
        panel.updateControlMode(mode: ControlMode.together);
        _realPlayer.enableManualMode(true);
        _shadowPlayer.enableManualMode(true);
      }

    } else if (isKeyUp) {
      movePlayers(direction: null);
    }

    return false;
  }

  void movePlayers({required Direction? direction}) {
    if (direction != null) {
      // play step sound
      audio.playStep();
    }

    _realPlayer.moveToDirection(direction: direction);
    _shadowPlayer.moveToDirection(direction: direction);
  }
}
