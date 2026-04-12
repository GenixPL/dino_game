import 'dart:async';
import 'dart:math';

import 'package:dino_game/game.dart';
import 'package:dino_game/iterable_extensions.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

enum ObstacleCase {
  cactusBig1,
  cactusBig2,
  cactusBig3,
  cactusSmall1,
  cactusSmall2,
  cactusSmall3,
  ptero,
  ;

  Vector2 get size {
    const double bigHeight = 50;
    const double smallHeight = 35;

    return switch (this) {
      ObstacleCase.cactusBig1 => Vector2(25, bigHeight),
      ObstacleCase.cactusBig2 => Vector2(49, bigHeight),
      ObstacleCase.cactusBig3 => Vector2(75, bigHeight),
      ObstacleCase.cactusSmall1 => Vector2(17, smallHeight),
      ObstacleCase.cactusSmall2 => Vector2(34, smallHeight),
      ObstacleCase.cactusSmall3 => Vector2(51, smallHeight),
      ObstacleCase.ptero => Vector2(46, 40),
    };
  }

  Component getComponent({
    required Game game,
  }) {
    return switch (this) {
      ObstacleCase.cactusBig1 => SpriteComponent(
        sprite: Sprite(
          game.images.fromCache('cactus_big_1.png'),
        ),
      ),

      ObstacleCase.cactusBig2 => SpriteComponent(
        sprite: Sprite(
          game.images.fromCache('cactus_big_2.png'),
        ),
      ),

      ObstacleCase.cactusBig3 => SpriteComponent(
        sprite: Sprite(
          game.images.fromCache('cactus_big_3.png'),
        ),
      ),

      ObstacleCase.cactusSmall1 => SpriteComponent(
        sprite: Sprite(
          game.images.fromCache('cactus_small_1.png'),
        ),
      ),

      ObstacleCase.cactusSmall2 => SpriteComponent(
        sprite: Sprite(
          game.images.fromCache('cactus_small_2.png'),
        ),
      ),

      ObstacleCase.cactusSmall3 => SpriteComponent(
        sprite: Sprite(
          game.images.fromCache('cactus_small_3.png'),
        ),
      ),

      ObstacleCase.ptero => SpriteAnimationComponent(
        animation: SpriteAnimation.fromFrameData(
          game.images.fromCache('ptero.png'),
          SpriteAnimationData.sequenced(
            amount: 2,
            stepTime: 0.18,
            textureSize: size,
          ),
        ),
      ),
    };
  }
}

class ObstacleGenerator {
  int? _lastIndex;
  int _counter = 0;

  Obstacle generate() {
    int newIndex = _getCase().index;
    if (newIndex == _lastIndex) {
      newIndex++;
    }
    _lastIndex = newIndex;

    final obstacle = Obstacle(
      obstacleCase: ObstacleCase.values[newIndex % ObstacleCase.values.length],
      speed: switch (_counter) {
        < 5 => 200,
        < 10 => 300,
        < 15 => 400,
        < 20 => 500,
        _ => 600,
      },
    );

    _counter++;

    return obstacle;
  }

  ObstacleCase _getCase() {
    if (_counter == 0) {
      return ObstacleCase.cactusSmall1;
    }

    if (_counter < 3) {
      return ObstacleCase.values.whereList((c) {
        switch (c) {
          case ObstacleCase.cactusBig1:
          case ObstacleCase.cactusBig2:
          case ObstacleCase.cactusBig3:
          case ObstacleCase.ptero:
            return false;

          case ObstacleCase.cactusSmall1:
          case ObstacleCase.cactusSmall2:
          case ObstacleCase.cactusSmall3:
            return true;
        }
      }).random();
    }

    if (_counter < 7) {
      return ObstacleCase.values.whereList((c) {
        switch (c) {
          case ObstacleCase.ptero:
            return false;

          case ObstacleCase.cactusBig1:
          case ObstacleCase.cactusBig2:
          case ObstacleCase.cactusBig3:
          case ObstacleCase.cactusSmall1:
          case ObstacleCase.cactusSmall2:
          case ObstacleCase.cactusSmall3:
            return true;
        }
      }).random();
    }

    return ObstacleCase.values.random();
  }
}

class Obstacle extends PositionComponent with HasGameReference<Game> {
  Obstacle({
    required this.obstacleCase,
    required this.speed,
  }) : super(
         size: obstacleCase.size,
       );

  final ObstacleCase obstacleCase;
  final double speed;

  @override
  FutureOr<void> onLoad() async {
    // debugMode = true;

    add(_getHitbox());

    add(
      obstacleCase.getComponent(
        game: game,
      ),
    );

    position = Vector2(
      // Load it a bit outside so that it isn't rendered
      // for the first time when already moving inside.
      game.size.x + 20,
      _getPositionY(),
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

  double _getPositionY() {
    switch (obstacleCase) {
      case ObstacleCase.cactusBig1:
      case ObstacleCase.cactusBig2:
      case ObstacleCase.cactusBig3:
      case ObstacleCase.cactusSmall1:
      case ObstacleCase.cactusSmall2:
      case ObstacleCase.cactusSmall3:
        // 4 wont be generated
        return game.size.y - size.y - 1 - Random().nextInt(4);

      case ObstacleCase.ptero:
        return game.size.y - size.y - Random().nextInt(30);
    }
  }

  PolygonHitbox _getHitbox() {
    return PolygonHitbox([
      Vector2(switch (obstacleCase) {
        ObstacleCase.cactusBig1 => 9,
        ObstacleCase.cactusBig2 => 8,
        ObstacleCase.cactusBig3 => 9,
        ObstacleCase.cactusSmall1 => 6,
        ObstacleCase.cactusSmall2 => 6,
        ObstacleCase.cactusSmall3 => 6,
        ObstacleCase.ptero => 15,
      }, 0),

      Vector2(
        size.x -
            switch (obstacleCase) {
              ObstacleCase.cactusBig1 => 9,
              ObstacleCase.cactusBig2 => 8,
              ObstacleCase.cactusBig3 => 9,
              ObstacleCase.cactusSmall1 => 6,
              ObstacleCase.cactusSmall2 => 6,
              ObstacleCase.cactusSmall3 => 6,
              ObstacleCase.ptero => 27,
            },
        0,
      ),

      Vector2(
        size.x,
        switch (obstacleCase) {
          ObstacleCase.cactusBig1 => 14,
          ObstacleCase.cactusBig2 => 10,
          ObstacleCase.cactusBig3 => 12,
          ObstacleCase.cactusSmall1 => 5,
          ObstacleCase.cactusSmall2 => 5,
          ObstacleCase.cactusSmall3 => 5,
          ObstacleCase.ptero => 19,
        },
      ),

      Vector2(size.x, size.y),
      Vector2(0, size.y),

      Vector2(
        0,
        switch (obstacleCase) {
          ObstacleCase.cactusBig1 => 6,
          ObstacleCase.cactusBig2 => 13,
          ObstacleCase.cactusBig3 => 13,
          ObstacleCase.cactusSmall1 => 9,
          ObstacleCase.cactusSmall2 => 9,
          ObstacleCase.cactusSmall3 => 9,
          ObstacleCase.ptero => 15,
        },
      ),
    ]);
  }
}
