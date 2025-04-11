import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

import 'levels/level.dart';

class PixelAdventure extends FlameGame {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  late final CameraComponent cam;

  final world = Level();

  @override
  FutureOr<void> onLoad() async{
    // load image to cache
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(width: 480, height: 320, world: world);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);
  }
}