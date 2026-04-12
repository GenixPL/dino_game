import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

class Score extends TextComponent with HasGameReference {
  Score()
    : super(
        anchor: Anchor.topRight,
        textRenderer: TextPaint(
          style: TextStyle(
            color: Colors.white,
            fontSize: _fontSize,
          ),
        ),
      );

  static const double _fontSize = 24;
  int _score = 0;

  @override
  FutureOr<void> onLoad() {
    text = _score.toString();

    position = Vector2(
      game.size.x - 4,
      0,
    );

    return super.onLoad();
  }

  void reset() {
    _score = 0;
    text = _score.toString();
  }

  void increase() {
    _score++;
    text = _score.toString();
  }
}
