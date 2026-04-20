import 'package:dino_game/game.dart';
import 'package:flame/game.dart' show GameWidget;
import 'package:flutter/material.dart';

class DinoGame extends StatefulWidget {
  const DinoGame({
    super.key,
    this.scoreTextStyle,
  });

  final TextStyle? scoreTextStyle;

  @override
  State<DinoGame> createState() => _DinoGameState();
}

class _DinoGameState extends State<DinoGame> {
  late final Game _game = Game(
    scoreTextStyle: widget.scoreTextStyle,
  );

  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _game.loadImages().then((_) {
      _loaded = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _game.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return GameWidget(
      game: _game,
    );
  }
}
