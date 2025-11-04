import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:pixel_adventure/components/jump_button.dart';
import 'package:pixel_adventure/components/left_button.dart';
import 'package:pixel_adventure/components/level.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/right_button.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, HasCollisionDetection, TapCallbacks {
  @override
  Color backgroundColor() => Color(0xff211f30);
  CameraComponent? cam;
  Player player = Player();
  bool showControls = false;
  bool playSounds = true;
  double soundVolume = 1.0;

  double mapWidth = 120 * 16; // 1920
  double mapHeight = 46 * 16; // 736

  double deadzoneX = 50.0;
  double deadzoneY = 50.0;

  List<String> levelNames = ["Level-01", "Level-01"];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    // load all images into cache
    await images.loadAllImages();

    _loadLevel();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    _followPlayer();

    super.update(dt);
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // no more levels
      currentLevelIndex = 0;
      _loadLevel();
    }
  }

  Future<void> _loadLevel() async {
    Future.delayed(Duration(seconds: 1), () {
      Level world = Level(levelName: levelNames[currentLevelIndex], player: player);

      cam = CameraComponent(world: world);

      cam?.viewfinder.zoom = 1.7;

      // cam.follow(player);

      cam?.setBounds(Rectangle.fromLTWH(0, 216, mapWidth, mapHeight));

      cam?.priority = 0;

      addAll([cam!, world]);

      if (showControls) {
        add(LeftButton());
        add(RightButton());
        add(JumpButton());
      }
    });
  }

  void _followPlayer() {
    if (cam != null) {
      // Get viewport size accounting for zoom
      final viewportWidth = cam!.viewport.virtualSize.x / cam!.viewfinder.zoom;
      final viewportHeight = cam!.viewport.virtualSize.y / cam!.viewfinder.zoom;

      // Current camera position (center)
      final camCenterX = cam!.viewfinder.position.x;
      final camCenterY = cam!.viewfinder.position.y;

      // Calculate player position relative to camera center
      final playerRelativeX = player.position.x - camCenterX;
      final playerRelativeY = player.position.y - camCenterY;

      // Calculate new camera position
      double newCamX = camCenterX;
      double newCamY = camCenterY;

      // Check horizontal bounds
      if (player.scale.x > 0 && playerRelativeX > deadzoneX) {
        newCamX += playerRelativeX - deadzoneX;
      } else if (player.scale.x < 0 && playerRelativeX < -deadzoneX) {
        newCamX += playerRelativeX + deadzoneX;
      }

      // Check vertical bounds
      if (playerRelativeY > deadzoneY) {
        newCamY += playerRelativeY - deadzoneY;
      } else if (playerRelativeY < -deadzoneY) {
        newCamY += playerRelativeY + deadzoneY;
      }

      // Clamp to map boundaries
      final halfViewportWidth = viewportWidth / 2;
      final halfViewportHeight = viewportHeight / 2;

      newCamX = newCamX.clamp(halfViewportWidth, mapWidth - halfViewportWidth);
      newCamY = newCamY.clamp(halfViewportHeight, mapHeight - halfViewportHeight);

      // Smoothly move camera to new position
      cam?.viewfinder.position = Vector2(newCamX, newCamY);
    }
  }
}
