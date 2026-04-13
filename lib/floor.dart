import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class Floor extends ParallaxComponent {
  Floor() : super(priority: -1);

  @override
  FutureOr<void> onLoad() async {
    // We assign the parallax data directly to the inherited 'parallax' property
    parallax = await game.loadParallax(
      [
        ParallaxImageData('floor.png'),
      ],
      alignment: Alignment.bottomCenter,
      fill: LayerFill.none,
      velocityMultiplierDelta: Vector2(1.8, 0),
      repeat: ImageRepeat.repeatX,
    );

    return super.onLoad();
  }

  void stop() {
    parallax?.baseVelocity = Vector2(0, 0);
  }

  void start() {
    parallax?.baseVelocity = Vector2(40, 0);
  }

  void updateSpeed(double newSpeed) {
    parallax?.baseVelocity = Vector2(newSpeed, 0);
  }
}
