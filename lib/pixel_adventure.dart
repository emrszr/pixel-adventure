import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
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
  late CameraComponent cam;
  Player player = Player();
  bool showControls = true;
  List<String> levelNames = ["Level-01", "Level-01"];
  int currentLevelIndex = 0;

  @override
  FutureOr<void> onLoad() async {
    // load all images into cache
    await images.loadAllImages();

    _loadLevel();

    return super.onLoad();
  }

  void loadNextLevel() {
    removeWhere((component) => component is Level);
    if (currentLevelIndex < levelNames.length - 1) {
      currentLevelIndex++;
      _loadLevel();
    } else {
      // no more levels
    }
  }

  Future<void> _loadLevel() async {
    Future.delayed(Duration(seconds: 1), () {
      Level world = Level(levelName: levelNames[currentLevelIndex], player: player);

      cam = CameraComponent.withFixedResolution(width: 640, height: 368, world: world);

      cam.viewfinder.anchor = Anchor.topLeft;
      cam.priority = 0;

      addAll([cam, world]);

      if (showControls) {
        add(LeftButton());
        add(RightButton());
        add(JumpButton());
      }
    });
  }
}
