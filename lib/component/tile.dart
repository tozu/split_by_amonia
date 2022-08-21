import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:split/assets.dart';

class Tile extends SpriteGroupComponent<MazeType> with CollisionCallbacks {
  static const spriteSize = 16.0;

  MazeType startingType;

  Tile(this.startingType, Vector2 position)
      : super(
          position: position,
          size: Vector2(spriteSize, spriteSize),
        );

  Future<Sprite> loadSprite(String assetPath) async {
    final spriteString = MiniSprite.fromDataString(path);
    return spriteString.toSprite(
      color: Colors.white,
      pixelSize: spriteSize,
    );
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprites = {
      MazeType.path: Sprite(await Flame.images.load('path.png')),
      MazeType.wall: Sprite(await Flame.images.load('wall.png')),
      // trying to load with MiniSprites
      // MazeType.path: await loadSprite(path),
      // MazeType.wall: await loadSprite(wall),
      MazeType.goal: Sprite(await Flame.images.load('goal.png')),
    };

    current = startingType;

    final hitbox = RectangleHitbox();
    hitbox.collisionType = CollisionType.passive;

    add(hitbox);
  }
}

enum MazeType {
  path,
  wall,
  goal,
}
