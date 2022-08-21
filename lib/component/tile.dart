import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';

class Tile extends SpriteGroupComponent<MazeType>
    with CollisionCallbacks, Tappable {
  static const spriteSize = 16.0;

  MazeType startingType;

  Tile(this.startingType, Vector2 position)
      : super(
          position: position,
          size: Vector2(spriteSize, spriteSize),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprites = {
      MazeType.path: Sprite(await Flame.images.load('path.png')),
      MazeType.wall: Sprite(await Flame.images.load('wall.png')),
      MazeType.goal: Sprite(await Flame.images.load('goal.png')),
    };

    current = startingType;

    final hitbox = RectangleHitbox();
    hitbox.collisionType = CollisionType.passive;

    add(hitbox);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    current = (MazeType.path == current) ? MazeType.wall : MazeType.path;

    priority = 1;

    info.handled = true;
    return true;
  }
}

enum MazeType {
  path,
  wall,
  goal,
}
