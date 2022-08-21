import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:split/my_game.dart';

class VictoryScreen extends PositionComponent with HasGameRef<MyGame> {
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

    addAll(
      [
        RectangleComponent(
          position: size / 2,
          anchor: Anchor.center,
          size: Vector2(300, 500),
          paint: Paint()..color = Colors.black.withOpacity(0.8),
        ),
        TextComponent(text: 'Hooray!', textRenderer: _myFont)
          ..anchor = Anchor.center
          ..position = size / 2 - Vector2(0, 180),
        TextComponent(
          text: 'Create more?',
          textRenderer: _myFont,
          anchor: Anchor.center,
          position: size / 2 + Vector2(0, 120),
        ),
        SpriteButtonComponent(
          button: await Sprite.load('RestartUp.png'),
          buttonDown: await Sprite.load('RestartDown.png'),
          onPressed: () {
            gameRef.restart();
          },
          size: Vector2(50, 50),
          position: size / 2 + Vector2(0, 180),
          anchor: Anchor.center,
        ),
      ],
    );
    debugMode = true;
    return super.onLoad();
  }
}
