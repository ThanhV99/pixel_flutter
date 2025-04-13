import 'dart:async';

import 'package:flame/components.dart';
import 'package:my_app/pixel_adventure.dart';

enum PlayerState {
  idle,
  running,
}

enum PlayerDirection {
  left, right, none
}

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {

  String character;
  Player({position, required this.character}): super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();

  @override
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

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

  void _updatePlayerMovement(double dt){
    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        dirX += moveSpeed;
        break;
      case PlayerDirection.none:
        break;
      default:
    }
    velocity = Vector2(dirX, 0.0);
    position += velocity * dt;
  }
}
