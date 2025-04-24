import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  final String blockType;

  CollisionBlock({position, size, required this.blockType})
    : super(position: position, size: size);

  @override
  void onLoad() {
    debugMode = true;
    final hitBox = RectangleHitbox();
    hitBox.collisionType = CollisionType.passive;
    add(hitBox);
  }
}
