import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pixel_adventure.dart';

void main() {
  final game = PixelAdventure();

  runApp(GameWidget(game: game));
}
