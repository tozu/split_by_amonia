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
  // TODO(Tobias): extract moving into separate class
  PlayerSpritesPath sprites;
  static const _playerSize = 10.0;

  late PlayerBorder border;

  bool _crashing = false;
  final bool _winning = false;
  bool _boarderReached = false;

  Direction? _moveDirection;

  // for animation
  bool _inMovingState = false;

  // Previous position (for collision calculation)
  late Vector2 _oldPosition;

  // Player settings
  bool active = true; // is controlled by player
  int distance2other = 0; //

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
    // TODO: Boarderreached animation
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
    } else if (other is PlayerBorder) {
      _boarderReached = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // currently in manual mode -> deactivates the other player temporarily,
    // so it does not move
    // TODO(Tobias): fix logic
    // if (!active) {
    //   return;
    // }

    if (active) {
      if (_crashing) {
        _handleCrash();
      } else if (_moveDirection != null) {
        _handleMovement();
        _handleMovementAnimation(moveDirection: _moveDirection!);
      } else if (_boarderReached) {
        handleBoarder();
      }
    }
  }

  void handleBoarder() {
    position = _oldPosition;
    _boarderReached = false;
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
    switch (moveDirection) {
      case Direction.north:
      // if (!isFlippedVertically) {
      //   flipVertically();
      // }
      // break;
      case Direction.south:
      // if (isFlippedVertically) {
      //   flipVertically();
      // }
      // break;
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

  void setActivation(bool activation) {
    active = activation;
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

  bool _isLegalMove(Vector2 nextPosition) {
    if (!border.containsPoint(nextPosition)) {
      return false;
    }

    if (!parent.containsPoint(nextPosition)) {
      return false;
    }

    for (final tile in parent.children.query<Tile>()) {
      if (tile.containsPoint(nextPosition) && tile.current == MazeType.wall) {
        return false;
      }
    }
    return true;
  }

  void _movePlayerPosition(Vector2 deltaPosition) {
    if (children.query<MoveByEffect>().isEmpty &&
        _isLegalMove(absolutePosition + deltaPosition)) {
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

  // TODO(tobias): make smarter
  // void listenToOtherPlayerPosition();
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

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position.addListener(() {
      gameRef.shadowPlayer.border.position = position;
    });
  }
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

  @override
  Future<void> onLoad() async {
    super.onLoad();
    position.addListener(() {
      gameRef.realPlayer.border.position = position;
    });
  }
}

enum AnimationState { idle, moving, winning, crashing }
