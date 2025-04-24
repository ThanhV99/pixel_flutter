import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:my_app/actors/player.dart';
import 'package:my_app/components/background_tile.dart';
import 'package:my_app/components/fruit.dart';
import 'package:my_app/levels/collision_block.dart';
import 'package:my_app/pixel_adventure.dart';

class Level extends World
    with HasCollisionDetection, HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;

  Level({required this.levelName, required this.player});

  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2(16, 16));
    add(level);

    // spawn point of player
    _spawningObjects();
    _collisionObject();
    _scrollingBackground();

    return super.onLoad();
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoint');
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            break;
          case 'fruit':
            final fruit = Fruit(fruit: spawnPoint.name,
                position: Vector2(spawnPoint.x, spawnPoint.y),
                size: Vector2(spawnPoint.width, spawnPoint.height));
            add(fruit);
          default:
        }
      }
    }
  }

  void _collisionObject() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              blockType: 'platform',
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          case 'Wall':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              blockType: 'wall',
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              blockType: "death",
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
  }

  void _scrollingBackground() {
    final backgroundLayer = level.tileMap.getLayer('BackGround');
    const tileSize = 64;
    final numTilesX = (game.size.x / tileSize).floor();
    final numTilesY = (game.size.y / tileSize).floor();

    if (backgroundLayer != null) {
      final backgroundColor = backgroundLayer.properties.getValue('Color');

      for (double y = 0; y < game.size.y / numTilesY; y++) {
        for (double x = 0; x < numTilesX; x++) {
          final backgroundTile = BackgroundTile(
            color: backgroundColor ?? 'Gray',
            position: Vector2(x * tileSize, y * tileSize - tileSize),
          );

          add(backgroundTile);
        }
      }
    }
  }
}
