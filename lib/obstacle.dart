import 'dart:async';

import 'package:dino_game/game.dart';
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
  ;

  Vector2 get size {
    const double bigHeight = 52;
    const double smallHeight = 37;

    return switch (this) {
      ObstacleCase.cactusBig1 => Vector2(25, bigHeight),
      ObstacleCase.cactusBig2 => Vector2(49, bigHeight),
      ObstacleCase.cactusBig3 => Vector2(75, bigHeight),
      ObstacleCase.cactusSmall1 => Vector2(17, smallHeight),
      ObstacleCase.cactusSmall2 => Vector2(34, smallHeight),
      ObstacleCase.cactusSmall3 => Vector2(51, smallHeight),
    };
  }

  Future<Component> getComponent({
    required Game game,
  }) async {
    return switch (this) {
      ObstacleCase.cactusBig1 => SpriteComponent(
        sprite: await game.loadSprite('cactus_big_1.png'),
      ),

      ObstacleCase.cactusBig2 => SpriteComponent(
        sprite: await game.loadSprite('cactus_big_2.png'),
      ),

      ObstacleCase.cactusBig3 => SpriteComponent(
        sprite: await game.loadSprite('cactus_big_3.png'),
      ),

      ObstacleCase.cactusSmall1 => SpriteComponent(
        sprite: await game.loadSprite('cactus_small_1.png'),
      ),

      ObstacleCase.cactusSmall2 => SpriteComponent(
        sprite: await game.loadSprite('cactus_small_2.png'),
      ),

      ObstacleCase.cactusSmall3 => SpriteComponent(
        sprite: await game.loadSprite('cactus_small_3.png'),
      ),
    };
  }
}

class ObstacleGenerator {
  int? _lastIndex;

  Obstacle generate() {
    int newIndex = ObstacleCase.values.random().index;
    if (newIndex == _lastIndex) {
      newIndex++;
    }
    _lastIndex = newIndex;

    return Obstacle(
      obstacleCase: ObstacleCase.values[newIndex],
    );
  }
}

class Obstacle extends PositionComponent with HasGameReference<Game> {
  Obstacle({
    required this.obstacleCase,
  }) : super(
         size: obstacleCase.size,
       );

  final ObstacleCase obstacleCase;

  double _speed = 200;

  @override
  FutureOr<void> onLoad() async {
    add(RectangleHitbox());
    add(
      await obstacleCase.getComponent(
        game: game,
      ),
    );

    position = Vector2(
      // Load it a bit outside so that it isn't rendered
      // for the first time when already moving inside.
      game.size.x + 20,
      game.size.y - size.y,
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 3. Move left: Subtract from the X-axis
    position.x -= _speed * dt;

    // 4. Optional: Remove the component if it goes off-screen to the left
    if (position.x + size.x < 0) {
      game.increaseScore();
      removeFromParent();
    }
  }

  void changeSpeed(double value) {
    _speed = value;
  }
}
