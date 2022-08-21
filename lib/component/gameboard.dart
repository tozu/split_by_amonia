import 'package:flame/components.dart';
import 'package:split/component/maze.dart';
import 'package:split/component/player.dart';
import 'package:split/component/real_player.dart';
import 'package:split/component/shadow_player.dart';

class GameBoard extends PositionComponent {
  static const _mazeGap = 10;

  late Maze _realMaze;
  late Maze _shadowMaze;

  Player get realPlayer => _realMaze.player;

  Player get shadowPlayer => _shadowMaze.player;

  GameBoard() : super(priority: -1);

  @override
  Future<void> onLoad() async {
    final realPlayer = RealPlayer();
    final shadowPlayer = ShadowPlayer();

    realPlayer.other = shadowPlayer;
    shadowPlayer.other = realPlayer;
    final startPosition = Vector2(50, 50);
    _realMaze = Maze(position: startPosition);

    _realMaze.setPlayer(realPlayer);

    _shadowMaze = Maze(
      position: Vector2(
        _realMaze.position.x + _realMaze.width + _mazeGap,
        _realMaze.position.y,
      ),
    );

    _shadowMaze.setPlayer(shadowPlayer);

    add(_realMaze);
    add(_shadowMaze);

    size = Vector2(
      _realMaze.size.x * 2 + _mazeGap + _realMaze.position.x * 2,
      _realMaze.size.y + _realMaze.position.y * 2,
    );
  }
}
