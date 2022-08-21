import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:split/my_game.dart';

class TimerUntilFailure extends TimerComponent with HasGameRef<MyGame> {
  final TextPaint textPaint = TextPaint(
    style: const TextStyle(
        color: Colors.white, fontSize: 20, fontFamily: "Butcherman"),
  );

  late final TextComponent textComponent;
  final double period = 240;
  TimerUntilFailure(double duration)
      : super(
          period: duration,
          removeOnFinish: false,
        );

  @override
  Future<void>? onLoad() {
    textComponent = TextComponent(
        position: gameRef.size / 2 + Vector2(150, -180),
        anchor: Anchor.center,
        textRenderer: _myFont);
    add(textComponent);
    return super.onLoad();
  }

  final _myFont = TextPaint(
    style: TextStyle(
      fontFamily: 'Butcherman',
      color: BasicPalette.white.color,
    ),
  );

  @override
  void update(double dt) {
    super.update(dt);
    textComponent.text = 'Time Left : ${(period - timer.current).round()}';

    if (timer.current.round() == period) {
      gameRef.loosingState = true;
    }
  }
}
