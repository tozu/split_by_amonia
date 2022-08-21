import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:split/component/winning_animation.dart';
import 'package:split/my_game.dart';

class VictoryScreen extends PositionComponent with HasGameRef<MyGame> {
  VictoryScreen({required super.size});
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
          size: size,
          paint: Paint()..color = Colors.black.withOpacity(0.8),
        ),
        TextComponent(text: "Hooray!", textRenderer: _myFont)
          ..anchor = Anchor.topCenter
          ..position = Vector2(size.x / 2, 35),
        TextComponent(
          text: "play again?",
          textRenderer: _myFont,
          anchor: Anchor.bottomCenter,
          position: Vector2(size.x / 2, size.y - 70),
        ),
        WinningAnimation(size: size, position: size / 2),
        SpriteButtonComponent(
          button: Sprite(await Flame.images.load('restart.png')),
          buttonDown: Sprite(await Flame.images.load('restart.png')),
          onPressed: () {
            gameRef.restart();
          },
          size: Vector2(50, 50),
          anchor: Anchor.bottomCenter,
          position: Vector2(size.x / 2, size.y - 10),
        ),
      ],
    );
    return super.onLoad();
  }
}
