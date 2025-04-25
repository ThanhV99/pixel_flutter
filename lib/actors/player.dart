import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:my_app/components/fruit.dart';
import 'package:my_app/components/saw.dart';
import 'package:my_app/levels/collision_block.dart';
import 'package:my_app/pixel_adventure.dart';

enum PlayerState { idle, running }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler, CollisionCallbacks {
  String character;

  Player({position, this.character = 'Ninja Frog'}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;

  // control player moving
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;
  int horizontalDirection = 0;

  final Vector2 fromAbove = Vector2(0, -1);
  bool isOnGround = false;
  final double gravity = 15;
  final double jumpSpeed = 300;
  final double terminalVelocity = 150;
  bool hasJumped = false;
  Vector2 startingPosition = Vector2.zero();

  late final RectangleHitbox hitbox;

  @override
  void update(double dt) {
    _applyGravity(dt);
    _applyJump();
    _updatePlayerState();
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimation();

    // Update the hitbox position with the offset
    hitbox = RectangleHitbox();
    add(hitbox);

    startingPosition = Vector2(position.x, position.y);
    debugMode = true;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    horizontalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.keyA) ||
                keysPressed.contains(LogicalKeyboardKey.arrowLeft))
            ? -1
            : 0;
    horizontalDirection +=
        (keysPressed.contains(LogicalKeyboardKey.keyD) ||
                keysPressed.contains(LogicalKeyboardKey.arrowRight))
            ? 1
            : 0;
    hasJumped = keysPressed.contains(LogicalKeyboardKey.arrowUp);

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Fruit){
      other.isCollected = true;
      other.collectedByPlayer();
    } else if (other is Saw){
      _respawn();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is CollisionBlock) {
      // Calculate overlap and minimum translation vector (MTV)
      final playerRect = toRect();
      // final playerRect = hitbox.toRect();
      final wallRect = other.toRect();
      final overlap = playerRect.intersect(wallRect);

      if (overlap.isEmpty) return; // No overlap (edge case)

      // Determine MTV: smallest axis to push player out
      Vector2 mtv;
      if (overlap.width < overlap.height) {
        // Push out horizontally
        // toa do x cua diem center
        mtv = Vector2(
          playerRect.center.dx < wallRect.center.dx
              ? -overlap.width
              : overlap.width,
          0,
        );
      } else {
        // Push out vertically
        // toa do y cua diem center
        mtv = Vector2(
          0,
          playerRect.center.dy < wallRect.center.dy
              ? -overlap.height
              : overlap.height,
        );
      }

      // Apply MTV to correct position
      position += mtv;

      // Stop velocity in the direction of collision

      // player collision left
      // if (mtv.x > 0 && velocity.x < 0) {
      //   velocity.x = 0;
      //   print('left');
      // }
      // // player collision right
      // if (mtv.x < 0 && velocity.x > 0) {
      //   velocity.x = 0;
      //   print('right');
      // }
      // player collision top
      if (mtv.y > 0 && velocity.y < 0) {
        velocity.y = 0;
        isOnGround = false;
      }
      // player collision bottom
      if (mtv.y < 0 && velocity.y > 0) {
        velocity.y = 0;
        isOnGround = true;
      }
    }
    super.onCollision(intersectionPoints, other);
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

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    // check moving set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x = horizontalDirection * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _applyGravity(double dt) {
    velocity.y += gravity;
    position.y += velocity.y * dt;
  }

  void _applyJump() {
    if (hasJumped) {
      if (isOnGround) {
        velocity.y = -jumpSpeed;
        isOnGround = false;
      }
      hasJumped = false;
    }

    velocity.y = velocity.y.clamp(-jumpSpeed, terminalVelocity);
  }

  void _respawn(){
    position = startingPosition;
  }
}
