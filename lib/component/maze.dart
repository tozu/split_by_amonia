import 'package:flame/components.dart';
import 'package:split/component/player.dart';
import 'package:split/component/square.dart';

class Maze extends PositionComponent {
  static const int mazeWidth = 13;
  static const int mazeHeight = 20;

  static const pixelGap = 1;

  Player player;

  Maze(this.player, {Vector2? position})
      : super(
          position: position ?? Vector2(50, 50),
          size: Vector2(
            (mazeWidth * Square.squareSize) + (mazeWidth * pixelGap),
            (mazeHeight * Square.squareSize) + (mazeHeight * pixelGap),
          ),
        );

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    for (var x = 0; x < mazeWidth; x++) {
      for (var y = 0; y < mazeHeight; y++) {
        await add(Square(_getPositionOf(x, y)));
      }
    }

    player.position = _getPositionOf(
          (Maze.mazeWidth / 2).floor(),
          Maze.mazeHeight - 1,
        )
        // puts it in the middle of maze square
        + (Vector2.all(Square.squareSize) / 2);

    add(player);
  }

  Vector2 _getPositionOf(int x, int y) {
    final xPixelGap = pixelGap * x;
    final yPixelGap = pixelGap * y;

    final xPosition = x * Square.squareSize + xPixelGap;
    final yPosition = y * Square.squareSize + yPixelGap;

    return Vector2(xPosition, yPosition);
  }
}
