import 'package:flame/game.dart';
import 'package:split/component/maze.dart';
import 'package:split/component/player.dart';

class MyGame extends FlameGame with HasTappables {
  final mazeOnePosition = Vector2(50, 50);
  static const mazeGap = 10;

  @override
  Future<void> onLoad() async {
    final realPlayer = RealPlayer();
    final shadowPlayer = ShadowPlayer();

    // TODO(Tobias): extract into separate GameBoard class
    final mazeOne = Maze(
      realPlayer,
      position: mazeOnePosition,
    );
    final mazeTwo = Maze(
      shadowPlayer,
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
