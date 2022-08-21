import 'dart:math';

import 'package:flame/components.dart';
import 'package:split/assets.dart';
import 'package:split/component/control_model_panel.dart';
import 'package:split/component/maze.dart';
import 'package:split/component/player.dart';
import 'package:split/component/real_player.dart';
import 'package:split/component/shadow_player.dart';
import 'package:split/handler/audio_handler.dart';

class GameBoard extends PositionComponent {
  static const _mazeGap = 10;

  late Maze _realMaze;
  late Maze _shadowMaze;

  Player get realPlayer => _realMaze.player;

  Player get shadowPlayer => _shadowMaze.player;

  final ControlModePanel controlModePanel = ControlModePanel(
    controlMode: ControlMode.together,
  );

  final AudioHandler audio;

  GameBoard({required this.audio}) : super(priority: -1);

  // TODO(any): add randomization for loading mazes

  int get level {
    final random = Random();
    const min = 1;
    const max = 2;
    return min + random.nextInt(max - min);
  }

  String realMazeLevel(int level) {
    switch (level) {
      case 1:
        return realMazeMapLayoutLevel1;
      default:
        return realMazeMapLayoutLevel2;
    }
  }

  String shadowMazeLevel(int level) {
    switch (level) {
      case 1:
        return shadowMazeMapLayoutLevel1;
      default:
        return shadowMazeMapLayoutLevel2;
    }
  }

  @override
  Future<void> onLoad() async {
    final _realMazeAsset = realMazeLevel(level);
    final _shadowMazeAsset = shadowMazeLevel(level);

    final realPlayer = RealPlayer(audio);
    final shadowPlayer = ShadowPlayer(audio);

    realPlayer.other = shadowPlayer;
    shadowPlayer.other = realPlayer;
    final startPosition = Vector2(50, 50);

    _realMaze = Maze(position: startPosition, asset: _realMazeAsset);
    _realMaze.setPlayer(realPlayer);

    _shadowMaze = Maze(
      position: Vector2(
        _realMaze.position.x + _realMaze.width + _mazeGap,
        _realMaze.position.y,
      ),
      asset: _shadowMazeAsset,
    );

    _shadowMaze.setPlayer(shadowPlayer);

    add(_realMaze);
    add(_shadowMaze);

    add(controlModePanel);

    size = Vector2(
      _realMaze.size.x * 2 + _mazeGap + _realMaze.position.x * 2,
      _realMaze.size.y + _realMaze.position.y * 2,
    );
  }
}
