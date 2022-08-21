import 'dart:math';

abstract class Helpers {
  static final random = Random();

  static String randomPictureUrl() {
    final randomInt = random.nextInt(1000);
    return 'https://picsum.photos/seed/$randomInt/200/200';
  }

  static DateTime randomDateTime() {
    final randomInt = random.nextInt(20000000);
    return DateTime.now().subtract(Duration(seconds: randomInt));
  }
}
