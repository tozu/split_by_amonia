import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_mini_sprite/flame_mini_sprite.dart';
import 'package:flutter/material.dart';
import 'package:mini_sprite/mini_sprite.dart';
import 'package:split/component/square.dart';

import 'component/maze.dart';

class MyGame extends FlameGame with HasTappables {
  @override
  Future<void> onLoad() async {
    final miniLibrary = MiniLibrary.fromDataString(libraryAssets);
    final sprites = miniLibrary.toSprites(pixelSize: 1, color: Colors.green);
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
