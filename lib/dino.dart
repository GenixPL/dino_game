import 'dart:async';

import 'package:dino_game/game.dart';
import 'package:flame/components.dart';

enum DinoState {
  idle,
  running,
}

class Dino extends SpriteAnimationGroupComponent with HasGameReference<Game> {
  Dino()
    : super(
        size: Vector2(44, 48),
      );

  double velocityY = 0;
  final double gravity = 800;      // Pixels per second squared
  final double jumpForce = -400;   // Initial upward "kick"
  bool isOnGround = false;

  DinoState _state = DinoState.running;

  @override
  FutureOr<void> onLoad() {
    animations = {
      DinoState.idle: SpriteAnimation.fromFrameData(
        game.images.fromCache('dino_idle.png'),
        SpriteAnimationData.variable(
          amount: 6,
          textureSize: size,
          // 1 slower blink, and 2 faster ones
          stepTimes: [0.8, 0.2, 0.6, 0.2, 0.1, 0.2],
        ),
      ),
      DinoState.running: SpriteAnimation.fromFrameData(
        game.images.fromCache('dino_run.png'),
        SpriteAnimationData.sequenced(
          amount: 2,
          stepTime: 0.1,
          textureSize: size,
        ),
      ),
    };

    position = Vector2(0, game.size.y - size.y);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    current = _state;

    _updateJump(dt);

    if (isOnGround) {
      animationTicker?.paused = false;
    } else {
      animationTicker?.paused = true;
    }

    super.update(dt);
  }

  void jump() {
    if (isOnGround) {
      velocityY = jumpForce;
      isOnGround = false;
    }
  }

  void _updateJump(double dt) {
    // 1. Apply Gravity if in the air
    if (!isOnGround) {
      velocityY += gravity * dt;
    } else {
      velocityY = 0;
    }

    // 2. Update Position
    position.y += velocityY * dt;

    // 3. Simple Ground Check (replace with real collision logic)
    if (position.y >= game.size.y - size.y) {
      position.y = game.size.y - size.y;
      isOnGround = true;
    }
  }
}
