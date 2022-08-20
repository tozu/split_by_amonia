import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

enum AnimationState { idle, moving, winning, crashing }

class Player extends SpriteAnimationGroupComponent<AnimationState>
    with CollisionCallbacks {
  int speed = 100;
  bool crashing = false;
  bool winning = false;

  // Movement
  bool doMoveSouth = false;
  bool doMoveNorth = false;
  bool doMoveEast = false;
  bool doMoveWest = false;
  bool moving = false;

  //Facing
  bool facingSouth = true;
  bool facingEast = true;

  //Previous position
  double xOld = 0;
  double yOld = 0;

  Player() : super(current: AnimationState.idle);

  @override
  Future<void> onLoad() async {
    add(
      RectangleHitbox(),
    );

    animations = {
      AnimationState.idle: SpriteAnimation.spriteList(
        await getSpriteList('playerIdle[0-9]+.png'),
        stepTime: 0.1,
      ),
      AnimationState.moving: SpriteAnimation.spriteList(
        await getSpriteList('playerMoving[0-9]+.png'),
        stepTime: 0.1,
      ),
      AnimationState.crashing: SpriteAnimation.spriteList(
        await getSpriteList('playerCrashing[0-9]+.png'),
        stepTime: 0.1,
      ),
    };
  }

  Future<List<Sprite>> getSpriteList(String pattern) async {
    final imageList = await Flame.images.loadAllFromPattern(pattern);
    final spriteList = imageList.map(Sprite.new).toList();

    return spriteList;
  }

  @override
  void onCollisionStart(Set<Vector2> points, PositionComponent other) {
    super.onCollisionStart(points, other);
    if (other is Wall) {
      crashing = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (crashing) {
      handleCrash(dt);
    } else {
      handleMovement(dt);
    }
  }

  void handleCrash(double dt) {
    position.x = xOld;
    position.y = yOld;
    crashing = false;
  }

  void handleMovement(double dt) {
    //maybe add some acceleration?
    if (doMoveSouth) {
      if (!facingSouth) {
        flipVertically();
        facingSouth = true;
      }
      yOld = position.y;
      position.y -= speed * dt;
    } else if (doMoveNorth) {
      if (facingSouth) {
        flipVertically();
        facingSouth = false;
      }
      yOld = position.y;
      position.y -= speed * dt;
    } else if (doMoveEast) {
      if (!facingEast) {
        flipHorizontally();
        facingEast = true;
      }
      xOld = position.x;
      position.x += speed * dt;
    } else if (doMoveWest) {
      if (facingEast) {
        flipHorizontally();
        facingEast = false;
      }
      xOld = position.x;
      position.x -= speed * dt;
    } else {
      moving = false;
    }
  }

  void setAnimation() {
    if (crashing) {
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

class Wall {}
