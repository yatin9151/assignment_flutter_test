import 'package:test/test.dart';
import 'package:testing_app/models/favorites.dart';

void main() {
  group('Testing App Provider', () {
    var favorites = Favorites();

    test('A new item should be added', () {
      var number = 35;
      favorites.add(number, 'Item $number');
      expect(
        favorites.items.any((item) => item.id == number),
        true,
      );
    });

    test('An item should be removed', () {
      var number = 45;
      favorites.add(number, 'Item $number');
      expect(
        favorites.items.any((item) => item.id == number),
        true,
      );
      favorites.remove(number);
      expect(
        favorites.items.any((item) => item.id == number),
        false,
      );
    });
  });
}