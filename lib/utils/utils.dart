import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Utils {
  static Future<List<Sprite>> getSpriteList(String pattern) async {
    final imageList = await Flame.images.loadAllFromPattern(
      RegExp(pattern, caseSensitive: false),
    );
    final spriteList = imageList.map(Sprite.new).toList();

    return spriteList;
  }

  static Future<SpriteAnimation> loadAnimation(
    String path, {
    double stepTime = 1,
  }) async =>
      SpriteAnimation.spriteList(
        await getSpriteList('$path[0-9]+.png'),
        stepTime: stepTime,
      );
}
