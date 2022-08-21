import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:split/component/player.dart';

enum ControlState {
  enabled,
  disabled,
}

enum ControlMode {
  single,
  together,
}

class ControlModePanel extends PositionComponent {
  // image: active state
  // text: Manual mode (active/inactive)
  // text: player 1/2

  // image: active state
  // text: automatic mode (active/inactive)
  // text: moving both players

  static const controlStateSize = 28.0;

  final _regular = TextPaint(
    style: TextStyle(
      fontSize: 18,
      color: BasicPalette.white.color,
    ),
  );

  ControlMode controlMode;
  late Player? activePlayer;

  late SpriteGroupComponent enabledPicture;

  ControlModePanel({required this.controlMode});

  String get controlModeText =>
      controlMode == ControlMode.single ? 'Single' : 'Together';

  // TODO(any): clarify player type name
  String get playerText => activePlayer is ShadowPlayer ? '1' : '2';

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final sprites = {
      ControlState.enabled: Sprite(await Flame.images.load('enabled.png')),
      ControlState.disabled: Sprite(await Flame.images.load('disabled.png')),
    };

    enabledPicture = SpriteGroupComponent<ControlState>(
      sprites: sprites,
      size: Vector2(controlStateSize, controlStateSize),
    );

    enabledPicture.current = ControlState.disabled;

    addAll([
      // TODO(Tobias): move to right positions
      enabledPicture,
      TextComponent(text: 'Mode: $controlModeText', textRenderer: _regular)
        ..anchor = Anchor.topCenter
        ..x = size.x / 2
        ..y = 32.0,
      if (controlMode == ControlMode.single) ...[
        TextComponent(text: 'Player $playerText', textRenderer: _regular)
          ..anchor = Anchor.topCenter
          ..x = size.x / 2
          ..y = 32.0,
      ],
    ]);
  }

  void updateControlMode({required ControlMode mode, Player? player}) {
    enabledPicture.current = mode == ControlMode.single
        ? ControlState.enabled
        : ControlState.disabled;

    activePlayer = player;
  }
}
