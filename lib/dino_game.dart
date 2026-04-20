import 'package:dino_game/game.dart';
import 'package:flame/game.dart' show GameWidget;
import 'package:flutter/material.dart';

class DinoGame extends StatefulWidget {
  const DinoGame({
    super.key,
    this.scoreTextStyle,
    this.jumpForceMultiplier,
  });

  final TextStyle? scoreTextStyle;
  final double? jumpForceMultiplier;

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

    _game.changeJumpForceMultiplier(widget.jumpForceMultiplier);
  }

  @override
  void dispose() {
    _game.clearCache();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant DinoGame oldWidget) {
    if (oldWidget.jumpForceMultiplier != widget.jumpForceMultiplier) {
      _game.changeJumpForceMultiplier(widget.jumpForceMultiplier);
    }

    super.didUpdateWidget(oldWidget);
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
