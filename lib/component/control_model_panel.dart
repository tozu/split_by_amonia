import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:split/component/player.dart';
import 'package:split/component/shadow_player.dart';

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

  late SpriteGroupComponent enabledPicture;

  // Control mode
  ControlMode _controlMode;
  late TextComponent modeComponent;

  String get controlModeText {
    final mode = _controlMode == ControlMode.single ? 'Single' : 'Together';
    return 'Mode: $mode';
  }

  // player name
  Player? _activePlayer;

  final Vector2 playerNamePosition = Vector2(12.0, 32.0);
  late TextComponent playerNameComponent;

  String get activePlayerText {
    final activePlayer = _activePlayer == null
        ? ''
        // TODO(any): clarify player type name
        : _activePlayer is ShadowPlayer
            ? '1'
            : '2';

    return 'Player $activePlayer';
  }

  ControlModePanel({required ControlMode controlMode})
      : _controlMode = controlMode;

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

    modeComponent = createTextComponent(
      controlModeText,
      Vector2(size.x / 2, 32.0),
    );

    playerNameComponent = createTextComponent(
      activePlayerText,
      playerNamePosition,
    );

    addAll([
      // TODO(Tobias): move to right positions
      enabledPicture,
      modeComponent,
      playerNameComponent,
    ]);
  }

  void updateControlMode({required ControlMode mode, Player? player}) {
    _controlMode = mode;

    enabledPicture.current = _controlMode == ControlMode.single
        ? ControlState.enabled
        : ControlState.disabled;

    updateTextComponent(modeComponent, controlModeText);

    if (player != null) {
      _updateActivePlayer(player);
    }
  }

  void _updateActivePlayer(Player player) {
    _activePlayer = player;

    if (_activePlayer == null) {
      // hide Player name
      remove(playerNameComponent);
    } else {
      playerNameComponent = createTextComponent(
        activePlayerText,
        playerNamePosition,
      );
      // updateTextComponent(playerNameComponent, activePlayerText);
    }
  }

  void updateTextComponent(TextComponent component, String text) {
    component.text = text;
  }

  TextComponent createTextComponent(String text, Vector2 position) {
    return TextComponent(text: text, textRenderer: _regular)
      ..anchor = Anchor.topCenter
      ..x = position.x //size.x / 2
      ..y = position.y; //32.0;
  }
}
