import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:split/component/maze.dart';
import 'package:split/component/tile.dart';
import 'package:split/data/player_sprites_path.dart';
import 'package:split/utils/utils.dart';

abstract class Player extends SpriteAnimationGroupComponent<AnimationState>
    with CollisionCallbacks, ParentIsA<Maze> {
  PlayerSpritesPath sprites;
  static const _playerSize = 10.0;

  bool _crashing = false;
  bool winning = false;

  // Movement
  bool doMoveSouth = false;
  bool doMoveNorth = false;
  bool doMoveEast = false;
  bool doMoveWest = false;
  bool moving = false;

  // Facing direction (for sprites animation)
  bool facingSouth = true; // otherwise is north
  bool facingEast = true; // otherwise is west

  // Previous position (for collision calculation)
  late Vector2 oldPosition;

  Player(this.sprites)
      : super(
          current: AnimationState.idle,
          anchor: Anchor.center,
          size: Vector2.all(_playerSize),
          priority: 3,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(RectangleHitbox());

    animations = {
      AnimationState.idle: await Utils.loadAnimation(sprites.idle),
      AnimationState.moving: await Utils.loadAnimation(sprites.moving),
      AnimationState.crashing: await Utils.loadAnimation(sprites.crashing),
    };

    children.register<MoveByEffect>();

    debugMode = true;
  }

  void addEffectOnMove(Vector2 position) {
    final effect = MoveByEffect(
      position,
      EffectController(duration: 0.5, curve: Curves.easeInOutQuart),
    );

    add(effect);
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Tile) {
      if (other.current == MazeType.wall) {
        _crashing = true;
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    final length = children.query<MoveByEffect>().length;
    if (length > 1) {
      print('wee have more than one effect ($length) ');
    }

    if (_crashing) {
      handleCrash();
    } else {
      handleMovement();
    }
  }

  void handleCrash() {
    print('CRAAAAAASH');

    children.query<MoveByEffect>().forEach((element) {
      element.removeFromParent();
    });

    position = oldPosition;
    _crashing = false;
  }

  void handleMovement() {
    if (doMoveSouth) {
      if (!facingSouth) {
        flipVertically();
        facingSouth = true;
      }

      if (children.query<MoveByEffect>().isEmpty) {
        oldPosition = position.clone();
        addEffectOnMove(Vector2(0, Tile.spriteSize + Maze.pixelGap));
      }
    } else if (doMoveNorth) {
      if (facingSouth) {
        flipVertically();
        facingSouth = false;
      }

      if (children.query<MoveByEffect>().isEmpty) {
        oldPosition = position.clone();
        addEffectOnMove(Vector2(0, -(Tile.spriteSize + Maze.pixelGap)));
      }
    } else if (doMoveEast) {
      if (!facingEast) {
        flipHorizontally();
        facingEast = true;
      }

      if (children.query<MoveByEffect>().isEmpty) {
        oldPosition = position.clone();
        addEffectOnMove(Vector2(Tile.spriteSize + Maze.pixelGap, 0));
      }
    } else if (doMoveWest) {
      if (facingEast) {
        flipHorizontally();
        facingEast = false;
      }

      if (children.query<MoveByEffect>().isEmpty) {
        oldPosition = position.clone();
        addEffectOnMove(Vector2(-(Tile.spriteSize + Maze.pixelGap), 0));
      }
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
    } else {
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
  RealPlayer()
      : super(
          PlayerSpritesPath(
            idle: 'playerIdle',
            moving: 'playerMoving',
            crashing: 'playerCrashing',
          ),
        );
}

class ShadowPlayer extends Player {
  ShadowPlayer()
      : super(
          // TODO(any): add sprites for shadow player
          PlayerSpritesPath(
            idle: 'playerIdle',
            moving: 'playerMoving',
            crashing: 'playerCrashing',
          ),
        );
}

enum AnimationState { idle, moving, winning, crashing }
