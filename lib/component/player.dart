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
  final bool _winning = false;

  // Movement
  bool _doMoveSouth = false;
  bool _doMoveNorth = false;
  bool _doMoveEast = false;
  bool _doMoveWest = false;

  bool _isMoving = false;

  // Facing direction (for sprites animation)
  bool _facingSouth = true; // otherwise is north
  bool _facingEast = true; // otherwise is west

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

  void _move(Vector2 position) {
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
      _handleCrash();
    } else {
      _handleMovement();
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
    if (_doMoveSouth) {
      if (!_facingSouth) {
        flipVertically();
        _facingSouth = true;
      }

      if (children.query<MoveByEffect>().isEmpty) {
        _oldPosition = position.clone();
        _move(Vector2(0, Tile.spriteSize + Maze.pixelGap));
      }
    } else if (_doMoveNorth) {
      if (_facingSouth) {
        flipVertically();
        _facingSouth = false;
      }

      if (children.query<MoveByEffect>().isEmpty) {
        _oldPosition = position.clone();
        _move(Vector2(0, -(Tile.spriteSize + Maze.pixelGap)));
      }
    } else if (_doMoveEast) {
      if (!_facingEast) {
        flipHorizontally();
        _facingEast = true;
      }

      if (children.query<MoveByEffect>().isEmpty) {
        _oldPosition = position.clone();
        _move(Vector2(Tile.spriteSize + Maze.pixelGap, 0));
      }
    } else if (_doMoveWest) {
      if (_facingEast) {
        flipHorizontally();
        _facingEast = false;
      }

      if (children.query<MoveByEffect>().isEmpty) {
        _oldPosition = position.clone();
        _move(Vector2(-(Tile.spriteSize + Maze.pixelGap), 0));
      }
    } else {
      _isMoving = false;
    }
  }

  void _setAnimationState() {
    if (_crashing) {
      current = AnimationState.crashing;
    } else if (_isMoving) {
      current = AnimationState.moving;
    } else if (_winning) {
      current = AnimationState.winning;
    } else {
      current = AnimationState.idle;
    }
  }

  void moveSouth(bool b) {
    _doMoveSouth = b;
    _isMoving = b;
    _setAnimationState();
  }

  void moveNorth(bool b) {
    _doMoveNorth = b;
    _isMoving = b;
    _setAnimationState();
  }

  void moveEast(bool b) {
    _doMoveEast = b;
    _isMoving = b;
    _setAnimationState();
  }

  void moveWest(bool b) {
    _doMoveWest = b;
    _isMoving = b;
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
