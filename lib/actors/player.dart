import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:my_app/pixel_adventure.dart';

enum PlayerState { idle, running }

enum PlayerDirection { left, right, none }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  String character;

  Player({position, this.character = 'Ninja Frog'}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  // control player moving
  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  double horizontalMovement = 0;

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimation() {
    idleAnimation = _spriteAnimation('Idle', 11);

    runningAnimation = _spriteAnimation('Run', 12);

    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(
    String state,
    int amount, {
    double stepTime = 0.05,
  }) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2(32, 32),
      ),
    );
  }

  void _updatePlayerState(){
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0){
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x <0){
      flipHorizontallyAroundCenter();
    }

    // check moving set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }
}
