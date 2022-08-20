import 'package:flame/components.dart';
import 'package:split/component/gameboard.dart';
import 'package:split/component/player.dart';
import 'package:split/component/tile.dart';

class Maze extends PositionComponent with ParentIsA<GameBoard> {
  static const int mazeWidth = 13;
  static const int mazeHeight = 20;

  static const pixelGap = 1;

  late final Player player;

  Maze({Vector2? position})
      : super(
          position: position ?? Vector2(50, 50),
          size: Vector2(
            (mazeWidth * Tile.spriteSize) + (mazeWidth * pixelGap),
            (mazeHeight * Tile.spriteSize) + (mazeHeight * pixelGap),
          ),
          priority: 2,
        );

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    for (var x = 0; x < mazeWidth; x++) {
      for (var y = 0; y < mazeHeight; y++) {
        // TODO(any): generate/load maze with wall + path
        await add(Tile(MazeType.path, _getPositionOf(x, y)));
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

  Vector2 _getPositionOf(int x, int y) {
    final xPixelGap = pixelGap * x;
    final yPixelGap = pixelGap * y;

    final xPosition = x * Tile.spriteSize + xPixelGap;
    final yPosition = y * Tile.spriteSize + yPixelGap;

    return Vector2(xPosition, yPosition);
  }
}
