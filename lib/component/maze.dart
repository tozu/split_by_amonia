import 'package:flame/components.dart';
import 'package:split/component/gameboard.dart';
import 'package:split/component/player.dart';
import 'package:split/component/tile.dart';

class Maze extends PositionComponent with ParentIsA<GameBoard> {
  static const int mazeWidth = 13;
  static const int mazeHeight = 20;

  late final Player player;

  Maze({Vector2? position})
      : super(
          position: position ?? Vector2(50, 50),
          size: _getPositionOf(mazeWidth, mazeHeight),
          priority: 2,
        );

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    children.register<Tile>(); //
    final goalPosition = _getPositionOf((Maze.mazeWidth / 2).floor(), 0);

    for (var x = 0; x < mazeWidth; x++) {
      for (var y = 0; y < mazeHeight; y++) {
        var curretPosition = _getPositionOf(x, y);
        if (goalPosition == curretPosition) {
          await add(Tile(MazeType.goal, curretPosition));
        } else {
          await add(Tile(MazeType.path, curretPosition));
        }
      }
    }
  }

  void setPlayer(Player mazePlayer) {
    player = mazePlayer;

    player.position = _getPositionOf(
          (Maze.mazeWidth / 2).floor(),
          Maze.mazeHeight - 1,
        )
        // puts it in the middle of maze square
        +
        (Vector2.all(Tile.spriteSize) / 2);

    add(player);
  }
}

Vector2 _getPositionOf(
  int x,
  int y, {
  double xPos = Tile.spriteSize,
  double yPos = Tile.spriteSize,
}) {
  final xPosition = x * xPos;
  final yPosition = y * yPos;

  return Vector2(xPosition, yPosition);
}
