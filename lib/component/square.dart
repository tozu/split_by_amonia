import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

class Square extends RectangleComponent with Tappable {
  static const squareSize = 16.0;

  static Paint white = BasicPalette.white.paint();

  Square(Vector2 position)
      : super(
          position: position,
          paint: white,
          size: Vector2(squareSize, squareSize),
        );

  @override
  bool onTapUp(TapUpInfo info) {
    paint = BasicPalette.red.paint();
    info.handled = true;
    return true;
  }
}
