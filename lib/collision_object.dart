import 'dart:async';

import 'package:dino_game/game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class CollisionObject extends RectangleComponent with HasGameReference<Game> {
  CollisionObject()
    : super(
        size: Vector2.all(20),
        paint: Paint()..color = Colors.redAccent,
      );

  double speed = 200;

  @override
  FutureOr<void> onLoad() {
    add(RectangleHitbox());

    position = Vector2(
      game.size.x - size.x,
      game.size.y - size.y,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 3. Move left: Subtract from the X-axis
    position.x -= speed * dt;

    // 4. Optional: Remove the component if it goes off-screen to the left
    if (position.x + size.x < 0) {
      game.increaseScore();
      removeFromParent();
    }
  }
}
