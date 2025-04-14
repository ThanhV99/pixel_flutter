import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:my_app/actors/player.dart';

import 'levels/level.dart';

class PixelAdventure extends FlameGame with HasKeyboardHandlerComponents {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  Player player = Player(character: 'Pink Man');
  String levelName = 'level_1';
  late final CameraComponent cam;

  @override
  FutureOr<void> onLoad() async {
    // load image to cache
    await images.loadAllImages();

    final world = Level(levelName: levelName, player: player);

    cam = CameraComponent.withFixedResolution(
      width: 480,
      height: 320,
      world: world,
    );
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
  }
}
