import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:my_app/actors/player.dart';

import 'levels/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents {
  @override
  Color backgroundColor() => const Color(0xFF211F30);

  Player player = Player(character: 'Pink Man');
  String levelName = 'level_2';
  late final CameraComponent cam;

  // joystick
  late JoystickComponent joystick;
  bool isShowJoyStick = false;

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
    if (isShowJoyStick) {
      addJoyStick();
    }
  }

  @override
  void update(double dt) {
    if (isShowJoyStick) {
      updateJoyStick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 20, paint: Paint()..color = Colors.grey),
      background: CircleComponent(
        radius: 50,
        paint: Paint()..color = Colors.grey.withValues(alpha: 0.3),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    cam.viewport.add(joystick);
  }

  void updateJoyStick() {
    switch (joystick.direction) {
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
      case JoystickDirection.left:
        player.horizontalDirection = -1;
        break;
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
      case JoystickDirection.right:
        player.horizontalDirection = 1;
        break;
      default:
        player.horizontalDirection = 0;
        break;
    }
  }
}
