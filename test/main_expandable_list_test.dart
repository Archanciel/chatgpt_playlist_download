import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:chatgpt_playlist_download/models/list_model.dart';
import 'package:chatgpt_playlist_download/views/list_view_widget.dart';
import 'package:chatgpt_playlist_download/viewmodels/list_view_model.dart';

void main() {
  group('ListViewWidget', () {
    testWidgets('should render ListViewWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ListViewModel()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: ListViewWidget(),
            ),
          ),
        ),
      );

      expect(find.byType(ListViewWidget), findsOneWidget);
    });

    testWidgets('should toggle list on press', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ListViewModel()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: ListViewWidget(),
            ),
          ),
        ),
      );

      final toggleButton = find.byKey(ValueKey('toggle_button'));
      await tester.tap(toggleButton);
      await tester.pump();

      final listTile = find.byType(ListTile);
      expect(listTile, findsWidgets);

      await tester.tap(toggleButton);
      await tester.pump();

      expect(listTile, findsNothing);
    });

    testWidgets('should disable buttons when no item selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ListViewModel()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: ListViewWidget(),
            ),
          ),
        ),
      );

      final deleteButton = find.byKey(ValueKey('delete_button'));
      expect(deleteButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(deleteButton).enabled, isFalse);

      final upButton = find.byIcon(Icons.arrow_drop_up);
      expect(upButton, findsOneWidget);
//      expect(tester.widget<IconButton>(upButton).enabled, isFalse);

      final downButton = find.byIcon(Icons.arrow_drop_down);
      expect(downButton, findsOneWidget);
//      expect(tester.widget<IconButton>(downButton).enabled, isFalse);
    });

    testWidgets('should enable buttons when item selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ListViewModel()),
          ],
          child: MaterialApp(
            title: 'MVVM Example',
            home: Scaffold(
              appBar: AppBar(
                title: const Text('MVVM Example'),
              ),
              body: ListViewWidget(),
            ),
          ),
        ),
      );

      final listItem = find.byType(ListTile).first;
      await tester.tap(listItem);
      await tester.pump();

      final deleteButton = find.byKey(ValueKey('delete_button'));
      expect(deleteButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(deleteButton).enabled, isTrue);

      final upButton = find.byIcon(Icons.arrow_drop_up);
      expect(upButton, findsOneWidget);
    });
    testWidgets('should select and delete item', (WidgetTester tester) async {
      // Build ListViewWidget with a list containing one item
      final viewModel = ListViewModel();
      viewModel.items.add(ListItem(name: 'Test', isSelected: false));

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: viewModel),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: ListViewWidget(),
            ),
          ),
        ),
      );

      // Verify that the Delete button is disabled
      expect(find.text('Delete'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Delete'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Delete')),
        isA<ElevatedButton>().having((b) => b.enabled, 'enabled', false),
      );

      // Tap the Checkbox to select the item
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Verify that the Delete button is now enabled
      expect(
        tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Delete')),
        isA<ElevatedButton>().having((b) => b.enabled, 'enabled', true),
      );

      // Tap the Delete button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
      await tester.pump();

      // Verify that the item was deleted
      expect(find.byType(ListTile), findsNothing);
      expect(viewModel.items.length, equals(0));
    });
  });
}
