import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:split/my_game.dart';

void main() {
  runApp(
    GameWidget(game: MyGame()),
  );
}

/*
      TODO:
        - draw maze(s)
        - generate maze -> background + wall (path is clear)
        - draw player(s)
        - load sprite for player(s)
        - impl. movement logic
        - impl. collision logic
        - impl. win/loose logic

        nice to have:
        - game menu (start, manual, credits, exit)
 */