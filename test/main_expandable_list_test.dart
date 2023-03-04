import 'package:chatgpt_playlist_download/main_expandable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:chatgpt_playlist_download/models/list_model.dart';
import 'package:chatgpt_playlist_download/views/list_view_widget.dart';
import 'package:chatgpt_playlist_download/viewmodels/list_view_model.dart';

void main() {
  group('ListViewWidget', () {
    testWidgets(
        'should render ListViewWidget, not using MyApp but ListViewWidget',
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

      expect(find.byType(ListViewWidget), findsOneWidget);
    });

    testWidgets('should render ListViewWidget using MyApp',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MyApp(),
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

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      final Finder listTileFinder = find.byType(ListTile);
      expect(listTileFinder, findsWidgets);

      final List<Widget> listTileLst =
          tester.widgetList(listTileFinder).toList();
      expect(listTileLst.length, 9);

      // hidding the list
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      expect(listTileFinder, findsNothing);
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

      // displaying the list
      final toggleButton = find.byKey(ValueKey('toggle_button'));
      await tester.tap(toggleButton);
      await tester.pump();

      final deleteButton = find.byKey(ValueKey('delete_button'));
      expect(deleteButton, findsOneWidget);
      expect(tester.widget<ElevatedButton>(deleteButton).enabled, isFalse);

      final upButton = find.byIcon(Icons.arrow_drop_up);
      expect(upButton, findsOneWidget);
      expect(tester.widget<Icon>(upButton).color, Colors.black38);

      final downButton = find.byIcon(Icons.arrow_drop_down);
      expect(downButton, findsOneWidget);
      expect(tester.widget<Icon>(downButton).color, Colors.black38);
    });

    testWidgets('check buttons enabled after item selected',
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

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      final Finder listItemFinder = find.byType(ListTile).first;
      await tester.tap(listItemFinder);
      await tester.pump();

      // testing that the Delete button is disabled
      Finder deleteButtonFinder = find.byKey(ValueKey('delete_button'));
      expect(deleteButtonFinder, findsOneWidget);
      expect(
          tester.widget<ElevatedButton>(deleteButtonFinder).enabled, isFalse);

      // testing that the up and down buttons are disabled
      IconButton upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNull);

      IconButton downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNull);

      // Verify that the first ListTile checkbox is not
      // selected
      Checkbox firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isFalse);

      // Tap the first ListTile checkbox to select it
      await tester.tap(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      await tester.pump();

      // Verify that the first ListTile checkbox is now
      // selected. The check box must be obtained again
      // since the widget has been recreated !
      firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isTrue);

      // Verify that the Delete button is now enabled.
      // The Delete button must be obtained again
      // since the widget has been recreated !
      expect(
        tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Delete')),
        isA<ElevatedButton>().having((b) => b.enabled, 'enabled', true),
      );

      // Verify that the up and down buttons are now enabled.
      // The Up and Down buttons must be obtained again
      // since the widget has been recreated !
      upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNotNull);

      downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNotNull);
    });
    testWidgets('ensure only one checkbox is settable',
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

      // displaying the list
      final Finder toggleButtonFinder = find.byKey(ValueKey('toggle_button'));
      await tester.tap(toggleButtonFinder);
      await tester.pump();

      final Finder listItem = find.byType(ListTile).first;
      await tester.tap(listItem);
      await tester.pump();

      // Verify that the first ListTile checkbox is not
      // selected
      Checkbox firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isFalse);

      // Tap the first ListTile checkbox to select it
      await tester.tap(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      await tester.pump();

      // Verify that the first ListTile checkbox is now
      // selected. The check box must be obtained again
      // since the widget has been recreated !
      firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isTrue);

      // Find the ListTile with text 'Item 4'
      Finder listItemFourTileFinder = find.widgetWithText(ListTile, 'Item 4');

      // Find the Checkbox widget inside the ListTile
      Finder checkboxFinder = find.descendant(
        of: listItemFourTileFinder,
        matching: find.byType(Checkbox),
      );

      // Assert that the checkbox is not selected
      expect(tester.widget<Checkbox>(checkboxFinder).value, false);

      // now tap the fourth item checkbox
      await tester.tap(find.descendant(
        of: listItemFourTileFinder,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      await tester.pump();

      // Assert that the fourth item checkbox is selected
      expect(tester.widget<Checkbox>(checkboxFinder).value, true);

      // Verify that the first ListTile checkbox is no longer
      // selected. The check box must be obtained again
      // since the widget has been recreated !
      firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isFalse);
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
