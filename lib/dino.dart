import 'dart:async';
import 'dart:ui';

import 'package:dino_game/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum DinoState {
  idle,
  running,
}

class Dino extends SpriteAnimationGroupComponent with HasGameReference<Game> {
  Dino() : super();

  late final SpriteAnimation _runningAnim = _loadAnim(
    filename: 'dino_run.png',
    amount: 2,
    stepTime: 0.1,
    textureSize: Vector2(44, 48),
  );

  @override
  FutureOr<void> onLoad() {
    animations = {
      DinoState.running: _runningAnim,
    };

    current = DinoState.running;

    return super.onLoad();
  }

  SpriteAnimation _loadAnim({
    required String filename,
    required int amount,
    required double stepTime,
    required Vector2 textureSize,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache(filename),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
  }
}
