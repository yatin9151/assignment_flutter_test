import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_app/main.dart';

const text29Key = Key('text_29');

Finder _scrollable() => find.byType(Scrollable);
Finder _demoText() => find.text('demo');
Finder _demoTile() =>
    find.ancestor(of: _demoText(), matching: find.byType(ListTile));
Finder _demoLikeButton() =>
    find.descendant(of: _demoTile(), matching: find.byType(IconButton));

Future<void> _ensureOnHome(WidgetTester tester) async {
  final backButton = find.byTooltip('Back');
  if (backButton.evaluate().isNotEmpty) {
    await tester.tap(backButton);
    await tester.pumpAndSettle();
  }
}

Future<void> _scrollToBottom(WidgetTester tester) async {
  await tester.dragUntilVisible(
    find.byKey(text29Key),
    _scrollable(),
    const Offset(0, -200),
  );
  await tester.pumpAndSettle();
}

Future<void> _addDemoItem(WidgetTester tester) async {
  await _scrollToBottom(tester);
  final addFabFinder = find.byIcon(Icons.add);
  expect(addFabFinder, findsOneWidget);

  await tester.tap(addFabFinder);
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField), 'demo');
  await tester.tap(find.text('Add'));
  await tester.pumpAndSettle();
}

void main() {
  group('Testing App', () {
    testWidgets('Favorites operations test', (tester) async {
      await tester.pumpWidget(const TestingApp());
      await _ensureOnHome(tester);

      final iconKeys = ['icon_0', 'icon_1', 'icon_2'];

      for (var icon in iconKeys) {
        await tester.tap(find.byKey(ValueKey(icon)));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Added to favorites.'), findsOneWidget);
      }

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();

      final removeIconKeys = [
        'remove_icon_0',
        'remove_icon_1',
        'remove_icon_2',
      ];

      for (final iconKey in removeIconKeys) {
        await tester.tap(find.byKey(ValueKey(iconKey)));
        await tester.pumpAndSettle(const Duration(seconds: 1));

        expect(find.text('Removed from favorites.'), findsOneWidget);
      }
    });

    testWidgets('Add button is only visible at end of list', (tester) async {
      await tester.pumpWidget(const TestingApp());
      await _ensureOnHome(tester);
      final addButtonFinder = find.byIcon(Icons.add);
      expect(addButtonFinder, findsNothing);

      await tester.dragUntilVisible(
        find.byKey(text29Key),
        _scrollable(),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      expect(addButtonFinder, findsOneWidget);
    });

    testWidgets('User can add a demo item and sees toast', (tester) async {
      await tester.pumpWidget(const TestingApp());
      await _ensureOnHome(tester);

      await _addDemoItem(tester);
      expect(find.text('Item added.'), findsOneWidget);
    });

    testWidgets('Added demo item appears in the list', (tester) async {
      await tester.pumpWidget(const TestingApp());
      await _ensureOnHome(tester);

      await _addDemoItem(tester);

      await tester.dragUntilVisible(
        _demoText(),
        _scrollable(),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(_demoText(), findsOneWidget);
    });

    testWidgets('Liking demo shows it in favorites page', (tester) async {
      await tester.pumpWidget(const TestingApp());
      await _ensureOnHome(tester);

      await _addDemoItem(tester);

      await tester.dragUntilVisible(
        _demoText(),
        _scrollable(),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(_demoLikeButton());
      await tester.pumpAndSettle();

      expect(find.text('Added to favorites.'), findsOneWidget);

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(_demoText(), findsOneWidget);
    });

    testWidgets('Unliking demo removes it from favorites page', (tester) async {
      await tester.pumpWidget(const TestingApp());
      await _ensureOnHome(tester);
      await _addDemoItem(tester);
      await tester.dragUntilVisible(
        _demoText(),
        _scrollable(),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(_demoLikeButton());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(_demoText(), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        _demoText(),
        _scrollable(),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      await tester.tap(_demoLikeButton());
      await tester.pumpAndSettle();
      expect(find.text('Removed from favorites.'), findsOneWidget);

      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(_demoText(), findsNothing);
    });

    testWidgets('Removing demo via favorites page unlikes it on home page', (
      tester,
    ) async {
      await tester.pumpWidget(const TestingApp());
      await _ensureOnHome(tester);

      await _addDemoItem(tester);
      await tester.dragUntilVisible(
        _demoText(),
        _scrollable(),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await tester.tap(_demoLikeButton());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(_demoText(), findsOneWidget);

      final demoFavoriteTile = find.ancestor(
        of: _demoText(),
        matching: find.byType(ListTile),
      );
      final demoRemoveButton = find.descendant(
        of: demoFavoriteTile,
        matching: find.byIcon(Icons.close),
      );
      await tester.tap(demoRemoveButton);
      await tester.pumpAndSettle();
      expect(find.text('Removed from favorites.'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        _demoText(),
        _scrollable(),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      final demoFilledHeart = find.descendant(
        of: _demoTile(),
        matching: find.byIcon(Icons.favorite),
      );
      final demoBorderHeart = find.descendant(
        of: _demoTile(),
        matching: find.byIcon(Icons.favorite_border),
      );

      expect(demoFilledHeart, findsNothing);
      expect(demoBorderHeart, findsOneWidget);
    });
  });
}
