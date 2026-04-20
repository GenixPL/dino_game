import 'dart:async';
import 'dart:math';

import 'package:dino_game/dino.dart';
import 'package:dino_game/floor.dart';
import 'package:dino_game/iterable_extensions.dart';
import 'package:dino_game/obstacle.dart';
import 'package:dino_game/score.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/src/components/core/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum _GameState {
  initial,
  running,
  lost,
}

// TODO(genix): add sounds
// TODO(genix): add more background
// TODO(genix): add highest score
// TODO(genix): add controls
// TODO(genix): stop the timer when out of focus
class Game extends FlameGame with HasCollisionDetection, KeyboardEvents, TapCallbacks {
  Game({
    required this.scoreTextStyle,
  });

  final TextStyle? scoreTextStyle;

  final Dino _dino = Dino();
  late final Score _score = Score(
    textStyle: scoreTextStyle,
  );
  final Floor _floor = Floor();
  final ObstacleGenerator _obstacleGenerator = ObstacleGenerator();

  _GameState _state = _GameState.initial;
  Timer? _obstacleTimer;

  // region Overrides

  @override
  FutureOr<void> onLoad() async {
    add(_dino);
    add(_score);
    add(_floor);

    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // Define the clipping area
    canvas.clipRect(size.toRect());

    // Everything drawn after this line will be clipped to the component's size
    super.render(canvas);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final bool jumpKeyPressed = keysPressed.containsAny({
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.keyW,
      LogicalKeyboardKey.space,
    });
    if (jumpKeyPressed) {
      switch (_state) {
        case _GameState.initial:
        case _GameState.lost:
          _start();
          break;

        case _GameState.running:
          _dino.jump();
          break;
      }
    }

    // TODO(genix): when adding bending, dino and ptero's hitboxes need to change.

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onTapDown(TapDownEvent event) {
    switch (_state) {
      case _GameState.initial:
      case _GameState.lost:
        _start();
        break;

      case _GameState.running:
        _dino.jump();
        break;
    }

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

  void _start() {
    _score.reset();
    removeWhere((c) => c is Obstacle);
    paused = false;
    _state = _GameState.running;
    _floor.start();
    _dino.jump();
    _dino.run();
    _obstacleGenerator.reset();
    _startCollisionTimer();
  }

  void gameLost() {
    _obstacleTimer?.cancel();
    _state = _GameState.lost;
    _dino.markDead();
    _floor.stop();
    for (Component child in children) {
      if (child is Obstacle) {
        child.stop();
      }
    }
  }

  void increaseScore() {
    _score.increase();
  }

  void changeJumpForceMultiplier(double? value) {
    _dino.changeJumpForceMultiplier(value);
  }

  void _startCollisionTimer() {
    _obstacleTimer?.cancel();
    _obstacleTimer = Timer(
      Duration(
        milliseconds: 1000 + Random().nextInt(1000),
      ),
      () {
        final hasObstacle = children.any((c) => c is Obstacle);
        if (hasObstacle) {
          _obstacleTimer = Timer(
            Duration(milliseconds: 100),
            _startCollisionTimer,
          );
          return;
        }

        add(_obstacleGenerator.generate());
        _startCollisionTimer();
      },
    );
  }
}
