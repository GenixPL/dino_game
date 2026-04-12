import 'dart:async';

import 'package:dino_game/game.dart';
import 'package:dino_game/obstacle.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

enum _DinoState {
  idle,
  running,
  dead,
}

class Dino extends SpriteAnimationGroupComponent with CollisionCallbacks, HasGameReference<Game> {
  Dino()
    : super(
        size: Vector2(44, 47),
      );

  double velocityY = 0;
  final double gravity = 1000; // Pixels per second squared
  final double jumpForce = -460; // Initial upward "kick"
  bool isOnGround = false;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;

    add(
      PolygonHitbox([
        Vector2(0, 0),
        Vector2(size.x, 0),
        Vector2(size.x, 15),
        Vector2(28, size.y),
        Vector2(10, size.y),
        Vector2(0, size.y - 17),
        Vector2(0, size.y),
      ]),
    );

    animations = Map.fromEntries(
      _DinoState.values.map((_DinoState state) {
        return MapEntry(
          state,
          switch (state) {
            _DinoState.idle => SpriteAnimation.fromFrameData(
              game.images.fromCache('dino_idle.png'),
              SpriteAnimationData.variable(
                amount: 6,
                textureSize: size,
                // 1 slower blink, and 2 faster ones
                stepTimes: [0.8, 0.2, 0.6, 0.2, 0.1, 0.2],
              ),
            ),

            _DinoState.running => SpriteAnimation.fromFrameData(
              game.images.fromCache('dino_run.png'),
              SpriteAnimationData.sequenced(
                amount: 2,
                stepTime: 0.1,
                textureSize: size,
              ),
            ),

            _DinoState.dead => SpriteAnimation.fromFrameData(
              game.images.fromCache('dino_dead.png'),
              SpriteAnimationData.sequenced(
                amount: 1,
                stepTime: 1,
                textureSize: size,
              ),
            ),
          },
        );
      }),
    );

    current = _DinoState.idle;

    position = Vector2(
      4,
      game.size.y - size.y - 1,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateJump(dt);

    if (isOnGround) {
      animationTicker?.paused = false;
    } else {
      animationTicker?.paused = true;
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Obstacle) {
      game.gameLost();
    }
  }

  void jump() {
    if (isOnGround) {
      velocityY = jumpForce;
      isOnGround = false;
    }
  }

  void run() {
    current = _DinoState.running;
  }

  void markDead() {
    current = _DinoState.dead;
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
    if (position.y >= game.size.y - size.y - 1) {
      position.y = game.size.y - size.y - 1;
      isOnGround = true;
    }
  }
}
