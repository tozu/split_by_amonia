import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:split/my_game.dart';

class StartScreen extends PositionComponent with HasGameRef<MyGame> {
  StartScreen()
      : super(
          priority: 4,
          size: Vector2(300, 300),
          anchor: Anchor.center,
        );

  @override
  Future<void>? onLoad() async {
    position = gameRef.size / 2;
    anchor = Anchor.center;
    final _myFont = TextPaint(
      style: TextStyle(
        fontFamily: 'Butcherman',
        color: BasicPalette.white.color,
      ),
    );

    addAll([
      // black background
      RectangleComponent(
        position: size / 2,
        anchor: Anchor.center,
        size: Vector2(300, 500),
        paint: Paint()..color = Colors.black.withOpacity(0.8),
      ),
      // Game title

      TextComponent(text: 'Split', textRenderer: _myFont)
        ..anchor = Anchor.center
        ..position = size / 2 - Vector2(0, 180),

      // start game
      TextComponent(
        text: 'Start game!',
        textRenderer: _myFont,
        anchor: Anchor.center,
        position: size / 2 + Vector2(0, 120),
      ),

      // start button
      SpriteButtonComponent(
        // TODO(Tobias): replace buttons
        button: Sprite(await Flame.images.load('start.png')),
        buttonDown: Sprite(await Flame.images.load('start.png')),
        onPressed: () {
          gameRef.init();

          removeFromParent();
        },
        size: Vector2(50, 50),
        position: size / 2 + Vector2(0, 180),
        anchor: Anchor.center,
      ),
    ]);

    return super.onLoad();
  }
}
