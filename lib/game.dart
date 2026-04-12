import 'dart:async';

import 'package:dino_game/dino.dart';
import 'package:dino_game/floor.dart';
import 'package:dino_game/iterable_extensions.dart';
import 'package:dino_game/score.dart';
import 'package:dino_game/square.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Game extends FlameGame with HasCollisionDetection, KeyboardEvents, TapCallbacks {
  final Dino _dino = Dino();
  final Score _score = Score();

  Timer? _collisionSpawnTimer;

  // region Overrides

  @override
  FutureOr<void> onLoad() async {
    add(_dino);
    add(_score);
    add(Floor());

    _startCollisionTimer();

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

  // endregion

  // region Images

  Future<void> loadImages() async {
    images.prefix = 'packages/dino_game/assets/images/';
    await images.loadAllImages();
  }

  void clearCache() {
    images.clearCache();
  }

  // endregion

  void gameLost() {
    _dino.markDead();
    paused = true;
  }

  void increaseScore() {
    _score.increase();
  }

  void _startCollisionTimer() {
    _collisionSpawnTimer?.cancel();
    _collisionSpawnTimer = Timer(Duration(seconds: 2), () {
      add(Square());
      _startCollisionTimer();
    });
  }
}
