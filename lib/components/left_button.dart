import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LeftButton extends SpriteComponent with HasGameReference<PixelAdventure>, TapCallbacks {
  LeftButton();

  final margin = 32;
  final buttonSize = 64;
  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(game.images.fromCache('HUD/LeftButton.png'));
    position = Vector2((buttonSize).toDouble(), game.size.y - margin - buttonSize);
    priority = 1000;
    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    game.player.horizontalMovement = -1;
    super.onTapDown(event);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.player.horizontalMovement = 0;
    super.onTapUp(event);
  }
}
