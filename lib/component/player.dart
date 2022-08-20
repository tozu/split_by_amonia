import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:split/component/maze.dart';
import 'package:split/component/tile.dart';
import 'package:split/data/player_sprites_path.dart';
import 'package:split/utils/utils.dart';

enum Direction {
  north,
  south,
  east,
  west,
}

abstract class Player extends SpriteAnimationGroupComponent<AnimationState>
    with CollisionCallbacks, ParentIsA<Maze> {
  // TODO(Tobias): extract moving into separate class

  PlayerSpritesPath sprites;
  static const _playerSize = 10.0;

  bool _crashing = false;
  final bool _winning = false;

  Direction? _moveDirection;

  // for animation
  bool _inMovingState = false;

  // Previous position (for collision calculation)
  late Vector2 _oldPosition;

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

    if (_crashing) {
      _handleCrash();
    } else if (_moveDirection != null) {
      _handleMovement();
      _handleMovementAnimation(moveDirection: _moveDirection!);
    }
  }

  void _handleCrash() {
    print('CRAAAAAASH');

    children.query<MoveByEffect>().forEach((element) {
      element.removeFromParent();
    });

    position = _oldPosition;
    _crashing = false;
  }

  void _handleMovement() {
    switch (_moveDirection) {
      case Direction.north:
        _movePlayerPosition(Vector2(0, -Tile.spriteSize));
        break;
      case Direction.south:
        _movePlayerPosition(Vector2(0, Tile.spriteSize));
        break;
      case Direction.east:
        _movePlayerPosition(Vector2(Tile.spriteSize, 0));
        break;
      case Direction.west:
        _movePlayerPosition(Vector2(-Tile.spriteSize, 0));
        break;
      default:
        break;
    }
  }

  void _handleMovementAnimation({required Direction moveDirection}) {
    // TODO(any): fix animation

    switch (moveDirection) {
      case Direction.north:
      case Direction.south:
        flipVertically();
        break;
      case Direction.east:
      case Direction.west:
        flipHorizontally();
        break;
    }
  }

  void _setAnimationState() {
    if (_crashing) {
      current = AnimationState.crashing;
    } else if (_inMovingState) {
      current = AnimationState.moving;
    } else if (_winning) {
      current = AnimationState.winning;
    } else {
      current = AnimationState.idle;
    }
  }

  void _movePlayerPosition(Vector2 moveTo) {
    if (children.query<MoveByEffect>().isEmpty) {
      _oldPosition = position.clone();

      final effect = MoveByEffect(
        moveTo,
        EffectController(duration: 0.5, curve: Curves.easeInOutQuart),
      );

      add(effect);
    }
  }

  void moveToDirection({required Direction? direction}) {
    _moveDirection = direction;
    _inMovingState = direction != null;

    _setAnimationState();
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
