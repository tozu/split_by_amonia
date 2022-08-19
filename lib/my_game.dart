import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:split/square.dart';

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
class MyGame extends FlameGame with HasTappables {
  @override
  Future<void> onLoad() async {
    add(Square(Vector2(100, 200)));
  }

  @override
  void onTapUp(int id, TapUpInfo info) {
    super.onTapUp(id, info);
    if (!info.handled) {
      final touchPoint = info.eventPosition.game;
      add(Square(touchPoint));
    }
  }
}
