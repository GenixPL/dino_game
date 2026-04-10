import 'dart:async';

import 'package:dino_game/dino.dart';
import 'package:flame/game.dart';

class Game extends FlameGame {
  @override
  FutureOr<void> onLoad() async {
    add(Dino());

    return super.onLoad();
  }

  Future<void> loadImages() async {
    images.prefix = 'packages/dino_game/assets/images/';
    await images.loadAllImages();
  }

  void clearCache() {
    images.clearCache();
  }
}


