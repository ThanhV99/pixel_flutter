import 'dart:async';

import 'package:flame/components.dart';
import 'package:my_app/pixel_adventure.dart';

enum PlayerState {
  idle,
  running,
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {

  String character;
  Player({position, required this.character}): super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
  }

  void _loadAllAnimation() {
    idleAnimation = _spriteAnimation('Idle', 11);

    runningAnimation = _spriteAnimation('Run', 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation
    };

    current = PlayerState.running;
  }

  SpriteAnimation _spriteAnimation(String state, int amount,
      {double stepTime = 0.05}){
    return SpriteAnimation.fromFrameData(
        game.images.fromCache('Main Characters/$character/$state (32x32).png'),
        SpriteAnimationData.sequenced(
            amount: amount,
            stepTime: stepTime,
            textureSize: Vector2(32, 32)
        )
    );
  }
}
