import 'dart:async';

import 'package:dino_game/dino.dart';
import 'package:dino_game/floor.dart';
import 'package:dino_game/iterable_extensions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Game extends FlameGame with KeyboardEvents, TapCallbacks {
  final Dino _dino = Dino();

  @override
  FutureOr<void> onLoad() async {
    add(_dino);
    add(Floor());

    return super.onLoad();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final bool jumpKeyPressed = keysPressed.containsAny({
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.keyW,
      LogicalKeyboardKey.space,
    });
    if (jumpKeyPressed) {
      _dino.jump();
    }

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onTapDown(TapDownEvent event) {
    _dino.jump();
    super.onTapDown(event);
  }

  Future<void> loadImages() async {
    images.prefix = 'packages/dino_game/assets/images/';
    await images.loadAllImages();
  }

  void clearCache() {
    images.clearCache();
  }
}
