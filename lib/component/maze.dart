import 'package:flame/components.dart';
import 'package:split/component/square.dart';

class Maze extends PositionComponent with HasGameRef {
  static const int mazeWidth = 31;
  static const int mazeHeight = 30;

  static const pixelGap = 1;

  Maze({Vector2? position})
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
        final xPixelGap = pixelGap * x;
        final yPixelGap = pixelGap * y;

        final xPosition = x * Square.squareSize + xPixelGap;
        final yPosition = y * Square.squareSize + yPixelGap;

        await add(Square(Vector2(xPosition, yPosition)));
      }
    }
  }
}
