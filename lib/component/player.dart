import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:split/component/maze.dart';
import 'package:split/component/player_border.dart';
import 'package:split/component/tile.dart';
import 'package:split/data/player_sprites_path.dart';
import 'package:split/my_game.dart';
import 'package:split/utils/utils.dart';

enum Direction {
  north,
  south,
  east,
  west,
}

abstract class Player extends SpriteAnimationGroupComponent<AnimationState>
    with CollisionCallbacks, ParentIsA<Maze>, HasGameRef<MyGame> {
  PlayerSpritesPath sprites;
  static const _playerSize = 10.0;

  late final PlayerBorder border;
  late final Player other;

  bool _hasCrashed = false;
  final bool _winning = false;
  bool _isBoarderReached = false;

  Direction? _moveDirection;

  // for animation
  bool _inMovingState = false;

  // Previous position (for collision calculation)
  late Vector2 _oldPosition;

  // Player settings
  bool isManualModeActive = true; // is controlled by player

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

    border = PlayerBorder(player: this);
    parent.add(border);

    // TODO(any): Boarder reached animation

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
        _hasCrashed = true;
      }
    } else if (other is PlayerBorder) {
      _isBoarderReached = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // currently in manual mode -> deactivates the other player temporarily,
    // so it does not move
    if (!isManualModeActive) {
      return;
    }

    if (_hasCrashed) {
      _handleCrash();
    } else if (_moveDirection != null) {
      _handleMovement();
      _handleMovementAnimation(moveDirection: _moveDirection!);
    } else if (_isBoarderReached) {
      _didReachBoarder();
    }
  }

  void _didReachBoarder() {
    position = _oldPosition;
    _isBoarderReached = false;
  }

  void _handleCrash() {
    children.query<MoveByEffect>().forEach((element) {
      element.removeFromParent();
    });

    position = _oldPosition;
    _hasCrashed = false;
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
    switch (moveDirection) {
      case Direction.north:
        break;
      case Direction.south:
        break;
      case Direction.east:
        if (!isFlippedHorizontally) {
          flipHorizontally();
        }
        break;
      case Direction.west:
        if (isFlippedHorizontally) {
          flipHorizontally();
        }
        break;
    }
  }

  void enableManualMode(bool activation) {
    isManualModeActive = activation;
  }

  void _setAnimationState() {
    if (_hasCrashed) {
      current = AnimationState.crashing;
    } else if (_inMovingState) {
      current = AnimationState.moving;
    } else if (_winning) {
      current = AnimationState.winning;
    } else {
      current = AnimationState.idle;
    }
  }

  bool isLegalMove(Vector2 deltaPosition) {
    final nextPosition = absolutePosition + deltaPosition;
    if (!border.containsPoint(nextPosition)) {
      return false;
    }

    // check if we are within in game borders
    if (!parent.containsPoint(nextPosition)) {
      return false;
    }

    // check whether we walked into a wall
    for (final tile in parent.children.query<Tile>()) {
      if (tile.containsPoint(nextPosition) && tile.current == MazeType.wall) {
        return false;
      }
    }
    return true;
  }

  bool _isBothLegalMove(Vector2 deltaPosition) {
    if (active && other.active) {
      return isLegalMove(deltaPosition) && other.isLegalMove(deltaPosition);
    } else {
      return isLegalMove(deltaPosition);
    }
  }

  void _movePlayerPosition(Vector2 deltaPosition) {
    if (children.query<MoveByEffect>().isEmpty &&
        _isBothLegalMove(deltaPosition)) {
      _oldPosition = position.clone();

      final effect = MoveByEffect(
        deltaPosition,
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

enum AnimationState { idle, moving, winning, crashing }
