import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:split/component/maze.dart';

abstract class Player extends RectangleComponent with ParentIsA<Maze> {
  static const _playerSize = 10.0;

  Player()
      : super(
          size: Vector2(_playerSize, _playerSize),
          anchor: Anchor.center,
        );
}

class RealPlayer extends Player {
  @override
  final Paint paint = BasicPalette.red.paint();

  RealPlayer();
}

class ShadowPlayer extends Player {
  @override
  final Paint paint = BasicPalette.blue.paint();

  ShadowPlayer();
}
