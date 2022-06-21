import 'dart:math';

class Emojies {
  Emojies();
  String getAnEmmoji(bool cool) {
    var coolEmojies = ['😇', '🤩', '🥳', '😎', '😊'];
    var notCoolEmojies = ['🥺', '😕', '😅', '😩', '😢'];
    // generates a new Random object
    final _random = Random();
    String element;
    // generate a random index based on the list length
    // and use it to retrieve the element
    if (cool) {
      element = coolEmojies[_random.nextInt(coolEmojies.length)];
    } else {
      element = notCoolEmojies[_random.nextInt(notCoolEmojies.length)];
    }
    return element;
  }
}