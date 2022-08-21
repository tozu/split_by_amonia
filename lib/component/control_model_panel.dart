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
  static const _controlStateSize = 28.0;

  final _regular = TextPaint(
    style: TextStyle(
      fontSize: 12,
      color: BasicPalette.white.color,
    ),
  );

  late SpriteGroupComponent _enabledIcon;

  // Control mode
  ControlMode _controlMode;
  late TextComponent _modeComponent;

  String get _controlModeText {
    final mode = _controlMode == ControlMode.single ? 'Single' : 'Together';
    return 'Mode: $mode';
  }

  // player name
  Player? _activePlayer;

  TextComponent? _playerNameComponent;

  Vector2 get _playerNamePosition =>
      _enabledIcon.positionOfAnchor(Anchor.centerRight) + Vector2(10, 0);

  String get _activePlayerText {
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

    final enabledIconPosition = Vector2(10, 10);
    _enabledIcon = SpriteGroupComponent<ControlState>(
      sprites: sprites,
      size: Vector2(_controlStateSize, _controlStateSize),
      position: enabledIconPosition,
    );

    _enabledIcon.current = ControlState.disabled;

    final modePosition =
        _enabledIcon.positionOfAnchor(Anchor.topRight) + Vector2(10, 0);

    _modeComponent = _createTextComponent(
      _controlModeText,
      modePosition,
    );

    addAll([
      _enabledIcon,
      _modeComponent,
    ]);
  }

  void updateControlMode({required ControlMode mode, Player? player}) {
    _controlMode = mode;
    _activePlayer = player;

    _enabledIcon.current = _controlMode == ControlMode.single
        ? ControlState.enabled
        : ControlState.disabled;

    _updateTextComponent(_modeComponent, _controlModeText);

    _updateActivePlayer();
  }

  void _updateActivePlayer() {
    if (_activePlayer == null) {
      // hide Player name
      remove(_playerNameComponent!);
      _playerNameComponent = null;
    } else {
      // update Player name
      if (_playerNameComponent == null) {
        // there is no player name
        _playerNameComponent = _createTextComponent(
          _activePlayerText,
          _playerNamePosition,
        );

        add(_playerNameComponent!);
      } else {
        // update it!
        _updateTextComponent(_playerNameComponent!, _activePlayerText);
      }
    }
  }

  // TODO(any): move to Utils class
  void _updateTextComponent(TextComponent component, String text) {
    component.text = text;
  }

  // TODO(any): move to Utils class
  TextComponent _createTextComponent(String text, Vector2 position) {
    return TextComponent(text: text, textRenderer: _regular)
      ..position = position;
  }
}
