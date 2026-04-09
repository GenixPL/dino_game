import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class DinoGame extends StatelessWidget {
  const DinoGame({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: _Game(),
    );
  }
}

class _Game extends FlameGame {}
