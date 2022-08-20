import 'package:flame/game.dart';
import 'package:split/component/maze.dart';

class MyGame extends FlameGame with HasTappables {
  @override
  Future<void> onLoad() async {
    // TODO(Tobias): extract into separate GameBoard class
    final mazeOnePosition = Vector2(50, 50);

    const mazeGap = 10;

    final mazeOne = Maze(position: mazeOnePosition);
    final mazeTwo = Maze(
      position: Vector2(mazeOnePosition.x + mazeOne.width + mazeGap, 50),
    );

    add(mazeOne);
    add(mazeTwo);

    final gameSize = Vector2(
      mazeOne.size.x * 2 + mazeGap + mazeOne.position.x * 2,
      mazeOne.size.y + mazeOne.position.y * 2,
    );

    camera.viewport = FixedResolutionViewport(gameSize);
  }
}
