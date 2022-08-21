import 'package:flame/components.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:split/component/gameboard.dart';
import 'package:split/component/player.dart';
import 'package:split/component/tile.dart';

class Maze extends PositionComponent with ParentIsA<GameBoard> {
  static const int mazeWidth = 13;
  static const int mazeHeight = 20;

  late final Player player;

  final String asset;

  Maze({Vector2? position, required this.asset})
      : super(
          position: position ?? Vector2(50, 50),
          size: _getPositionOf(mazeWidth, mazeHeight),
          priority: 2,
        );

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    children.register<Tile>();

    await _loadMaze(asset: asset);
  }

  Future<void> _loadMaze({required String asset}) async {
    final miniMap = MiniMap.fromDataString(asset);

    for (final entry in miniMap.objects.entries) {
      final miniMapPositionX = entry.key.x;
      final miniMapPositionY = entry.key.y;
      final spriteName = entry.value['sprite'] as String;

      final currentPosition =
          _getPositionOf(miniMapPositionX, miniMapPositionY);

      if (spriteName == 'wall') {
        await add(Tile(MazeType.wall, currentPosition));
      } else if (spriteName == 'goal') {
        await add(Tile(MazeType.goal, currentPosition));
      } else {
        await add(Tile(MazeType.path, currentPosition));
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
