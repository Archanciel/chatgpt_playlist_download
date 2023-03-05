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

    testWidgets(
        'check checkbox remains selected after toggling list up and down',
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

      // Tap the first ListTile checkbox to select it
      await tester.tap(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      await tester.pump();

      // Verify that the first ListTile checkbox is now
      // selected. The check box must be obtained again
      // since the widget has been recreated !
      Checkbox firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isTrue);

      // hidding the list
      await tester.tap(toggleButtonFinder);
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

      // redisplaying the list
      await tester.tap(toggleButtonFinder);
      await tester.pump();

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

      // Verify that the first ListTile checkbox is always
      // selected. The check box must be obtained again
      // since the widget has been recreated !
      firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isTrue);
    });

    testWidgets('check buttons disabled after item unselected',
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
      IconButton upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNotNull);

      IconButton downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNotNull);

      // Retap the first ListTile checkbox to unselect it
      await tester.tap(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      await tester.pump();

      // Verify that the first ListTile checkbox is now
      // unselected. The check box must be obtained again
      // since the widget has been recreated !
      firstListItemCheckbox = tester.widget<Checkbox>(find.descendant(
        of: find.byType(ListTile).first,
        matching: find.byWidgetPredicate((widget) => widget is Checkbox),
      ));
      expect(firstListItemCheckbox.value, isFalse);

      // testing that the Delete button is now disabled
      Finder deleteButtonFinder = find.byKey(ValueKey('delete_button'));
      expect(deleteButtonFinder, findsOneWidget);
      expect(
          tester.widget<ElevatedButton>(deleteButtonFinder).enabled, isFalse);

      // testing that the up and down buttons are now disabled
      upButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_up));
      expect(upButton.onPressed, isNull);

      downButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.arrow_drop_down));
      expect(downButton.onPressed, isNull);
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

      // Find and select the ListTile with text 'Item 4'
      String itemTextStr = 'Item 4';
      await findSelectAndTestListTileCheckbox(
        tester: tester,
        itemTextStr: itemTextStr,
      );

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

      Finder listViewFinder = find.byType(ListViewWidget);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      ListViewModel listViewModel =
          Provider.of<ListViewModel>(tester.element(listViewFinder), listen: false);
      expect(listViewModel.items.length, 10);

      // Verify that the Delete button is disabled
      expect(find.text('Delete'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Delete'), findsOneWidget);
      expect(
        tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Delete')),
        isA<ElevatedButton>().having((b) => b.enabled, 'enabled', false),
      );

      // Find and select the ListTile with text 'To delete'
      const String itemToDeleteTextStr = 'Item 3';

      await findSelectAndTestListTileCheckbox(
        tester: tester,
        itemTextStr: itemToDeleteTextStr,
      );

      // Verify that the Delete button is now enabled
      expect(
        tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Delete')),
        isA<ElevatedButton>().having((b) => b.enabled, 'enabled', true),
      );

      // Tap the Delete button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Delete'));
      await tester.pump();

      // Verify that the item was deleted by checking that
      // the ListViewModel.items getter return a list whose
      // length is 10 minus 1 and secondly verify that 
      // the deleted ListTile is no longer displayed.

      listViewFinder = find.byType(ListViewWidget);

      // tester.element(listViewFinder) returns a StatefulElement
      // which is a BuildContext
      listViewModel =
          Provider.of<ListViewModel>(tester.element(listViewFinder), listen: false);
      expect(listViewModel.items.length, 9);

      expect(find.widgetWithText(ListTile, itemToDeleteTextStr), findsNothing);
    });

    testWidgets('should select and move down item',
        (WidgetTester tester) async {
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

    testWidgets('should select and move down last item',
        (WidgetTester tester) async {
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

    testWidgets('should select and move up item', (WidgetTester tester) async {
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

    testWidgets('should select and move up first item',
        (WidgetTester tester) async {
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

Future<void> findSelectAndTestListTileCheckbox({
  required WidgetTester tester,
  required String itemTextStr,
}) async {

  Finder listItemFourTileFinder = find.widgetWithText(ListTile, itemTextStr);
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
}
