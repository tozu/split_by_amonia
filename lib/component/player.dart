import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/animation.dart';
import 'package:split/component/PlayerBorder.dart';
import 'package:split/component/maze.dart';
import 'package:split/component/square.dart';

import '../my_game.dart';

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
    with CollisionCallbacks, ParentIsA<Maze>, HasGameRef<MyGame> {
  PlayerSpritesPath sprites;
  static const _playerSize = 10.0;

  late PlayerBorder border;

  bool _crashing = false;
  bool winning = false;
  bool _boarderReached = false;

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

  // Player settings
  bool active = true; // is controlled by player
  int distance2other = 0; //

  Player(this.sprites)
      : super(
          current: AnimationState.idle,
          anchor: Anchor.center,
          size: Vector2.all(_playerSize),
        );

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    border = PlayerBorder(player: this);
    parent.add(border);
    // TODO: Boarderreached animation
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

    children.register<MoveByEffect>();

    debugMode = true;
  }

  void addEffectOnMove(Vector2 deltaPosition) {
    final nextPosition = absolutePosition + deltaPosition;
    if (isLegalMove(nextPosition)) {
      final effect = MoveByEffect(
        deltaPosition,
        EffectController(duration: 0.5, curve: Curves.easeInOutQuart),
      );
      add(effect);
    }
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
    // TODO(any): impl. proper class
    if (other is PlayerBorder) {
      _boarderReached = true;
    }
    if (other is Wall) {
      _crashing = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (active) {
      if (_crashing) {
        handleCrash();
      } else if (_boarderReached) {
        handleBoarder();
      } else {
        handleMovement();
      }
    }
  }

  void handleBoarder() {
    position = oldPosition;
    _boarderReached = false;
  }

  void handleCrash() {
    position = oldPosition;
    _crashing = false;
  }

  bool isLegalMove(Vector2 nextPosition) {
    return border.containsPoint(nextPosition);
  }

  void handleMovement() {
    oldPosition = position.clone();

    //maybe add some acceleration?
    if (doMoveSouth) {
      if (!facingSouth) {
        flipVertically();
        facingSouth = true;
      }

      // position.y += _speed * dt;
      if (children.query<MoveByEffect>().isEmpty) {
        addEffectOnMove(Vector2(0, Square.squareSize + Maze.pixelGap));
      }
    } else if (doMoveNorth) {
      if (facingSouth) {
        flipVertically();
        facingSouth = false;
      }

      if (children.query<MoveByEffect>().isEmpty) {
        addEffectOnMove(Vector2(0, -(Square.squareSize + Maze.pixelGap)));
      }
    } else if (doMoveEast) {
      if (!facingEast) {
        flipHorizontally();
        facingEast = true;
      }
      if (children.query<MoveByEffect>().isEmpty) {
        addEffectOnMove(Vector2(Square.squareSize + Maze.pixelGap, 0));
      }
    } else if (doMoveWest) {
      if (facingEast) {
        flipHorizontally();
        facingEast = false;
      }

      if (children.query<MoveByEffect>().isEmpty) {
        addEffectOnMove(Vector2(-(Square.squareSize + Maze.pixelGap), 0));
      }
    } else {
      moving = false;
    }
  }

  void setDistance(Player p) {
    //;
  }

  void setActivation(bool b) {
    active = b;
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
  @override
  final Paint paint = BasicPalette.red.paint();

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
  @override
  final Paint paint = BasicPalette.blue.paint();

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

class Wall {}
