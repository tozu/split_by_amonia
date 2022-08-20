import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:split/component/maze.dart';

class PlayerSpritesPath {
  final String idle;
  final String moving;
  final String crashing;

  PlayerSpritesPath({
    required this.idle,
    required this.moving,
    required this.crashing,
  });
}

abstract class Player extends SpriteAnimationGroupComponent<AnimationState>
    with CollisionCallbacks, ParentIsA<Maze> {
  PlayerSpritesPath sprites;

  final int _speed = 100;
  bool _crashing = false;
  bool winning = false;

  // Movement
  bool doMoveSouth = false;
  bool doMoveNorth = false;
  bool doMoveEast = false;
  bool doMoveWest = false;
  bool moving = false;

  // Facing
  bool facingSouth = true; // otherwise is north
  bool facingEast = true; // otherwise is west

  // Previous position (for collision calculation)
  double xOld = 0;
  double yOld = 0;

  Player(this.sprites)
      : super(
          current: AnimationState.idle,
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());

    animations = {
      AnimationState.idle: SpriteAnimation.spriteList(
        await getSpriteList('${sprites.idle}[0-9]+.png'),
        stepTime: 0.1,
      ),
      AnimationState.moving: SpriteAnimation.spriteList(
        await getSpriteList('${sprites.moving}[0-9]+.png'),
        stepTime: 0.1,
      ),
      AnimationState.crashing: SpriteAnimation.spriteList(
        await getSpriteList('${sprites.crashing}[0-9]+.png'),
        stepTime: 0.1,
      ),
    };
  }

  // TODO(any): extract to util class
  Future<List<Sprite>> getSpriteList(String pattern) async {
    final imageList = await Flame.images.loadAllFromPattern(
      RegExp(
        pattern,
        caseSensitive: false,
      ),
    );
    final spriteList = imageList.map(Sprite.new).toList();

    return spriteList;
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Wall) {
      _crashing = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_crashing) {
      handleCrash(dt);
    } else {
      handleMovement(dt);
    }
  }

  void handleCrash(double dt) {
    position.x = xOld;
    position.y = yOld;
    _crashing = false;
  }

  void handleMovement(double dt) {
    //maybe add some acceleration?
    if (doMoveSouth) {
      if (!facingSouth) {
        flipVertically();
        facingSouth = true;
      }
      yOld = position.y;
      position.y -= _speed * dt;
    } else if (doMoveNorth) {
      if (facingSouth) {
        flipVertically();
        facingSouth = false;
      }
      yOld = position.y;
      position.y -= _speed * dt;
    } else if (doMoveEast) {
      if (!facingEast) {
        flipHorizontally();
        facingEast = true;
      }
      xOld = position.x;
      position.x += _speed * dt;
    } else if (doMoveWest) {
      if (facingEast) {
        flipHorizontally();
        facingEast = false;
      }
      xOld = position.x;
      position.x -= _speed * dt;
    } else {
      moving = false;
    }
  }

  void setAnimation() {
    if (_crashing) {
      current = AnimationState.crashing;
    } else if (moving) {
      current = AnimationState.moving;
    } else if (winning) {
      current = AnimationState.winning;
    } else if (current != AnimationState.crashing) {
      current = AnimationState.idle;
    }
  }

  void moveSouth(bool b) {
    doMoveSouth = b;
    moving = b;
    setAnimation();
  }

  void moveNorth(bool b) {
    doMoveNorth = b;
    moving = b;
    setAnimation();
  }

  void moveEast(bool b) {
    doMoveEast = b;
    moving = b;
    setAnimation();
  }

  void moveWest(bool b) {
    doMoveWest = b;
    moving = b;
    setAnimation();
  }
}

class RealPlayer extends Player {
  @override
  final Paint paint = BasicPalette.red.paint();

  RealPlayer()
      : super(
          PlayerSpritesPath(
            idle: 'playerCrashing',
            moving: 'playerMoving',
            crashing: 'playerCrashing',
          ),
        );
}

class ShadowPlayer extends Player {
  @override
  final Paint paint = BasicPalette.blue.paint();

  ShadowPlayer()
      : super(
          // TODO(any): add sprites for shadow player
          PlayerSpritesPath(
            idle: 'playerCrashing',
            moving: 'playerMoving',
            crashing: 'playerCrashing',
          ),
        );
}

enum AnimationState { idle, moving, winning, crashing }

class Wall {}
