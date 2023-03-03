import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chatgpt_playlist_download/viewmodels/list_view_model.dart';
import 'package:chatgpt_playlist_download/views/list_view_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
    );
  }
}

/// Named ListViewWidget since ListView is a Flutter class !
class ListViewWidget extends StatefulWidget {
  @override
  State<ListViewWidget> createState() => _ListViewWidgetState();
}

class _ListViewWidgetState extends State<ListViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<ListViewModel>(context, listen: false)
                      .toggleList();
                },
                child: const Text('Toggle List'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<ListViewModel>(context, listen: false)
                      .deleteSelectedItem(context);
                },
                child: const Text('Delete'),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Provider.of<ListViewModel>(context, listen: false)
                      .moveSelectedItemUp();
                },
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.arrow_drop_up,
                  size: 50,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  Provider.of<ListViewModel>(context, listen: false)
                      .moveSelectedItemDown();
                },
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
        Consumer<ListViewModel>(
          builder: (context, model, child) {
            if (model.isListExpanded) {
              return Expanded(
                child: ListView.builder(
                  itemCount: model.items.length,
                  itemBuilder: (context, index) {
                    ListItem item = model.items[index];
                    return ListTile(
                      title: Text(item.name),
                      trailing: Checkbox(
                        value: item.isSelected,
                        onChanged: (value) {
                          model.selectItem(context, index);
                        },
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}

class ListViewModel extends ChangeNotifier {
  bool _isListExpanded = false;
  ListModel _model = ListModel();

  List<ListItem> get items => _model.items;

  bool get isListExpanded => _isListExpanded;

  void toggleList() {
    _isListExpanded = !_isListExpanded;
    notifyListeners();
  }

  void selectItem(BuildContext context, int index) {
    bool isOneItemSelected =_model.selectItem(index);

    if (!isOneItemSelected) {
      _disableButtons(context);
    }

    notifyListeners();
  }

  void deleteSelectedItem(BuildContext context) {
    int selectedIndex = _getSelectedIndex();

    if (selectedIndex != -1) {
      _model.deleteItem(selectedIndex);
      _disableButtons(context);
      notifyListeners();
    }
  }

  void moveSelectedItemUp() {
    int selectedIndex = _getSelectedIndex();
    if (selectedIndex != -1) {
      _model.moveItemUp(selectedIndex);
      notifyListeners();
    }
  }

  void moveSelectedItemDown() {
    int selectedIndex = _getSelectedIndex();
    if (selectedIndex != -1) {
      _model.moveItemDown(selectedIndex);
      notifyListeners();
    }
  }

  int _getSelectedIndex() {
    for (int i = 0; i < _model.items.length; i++) {
      if (_model.items[i].isSelected) {
        return i;
      }
    }
    return -1;
  }

  void _disableButtons(BuildContext context) {
    for (int i = 1; i <= 3; i++) {
      Provider.of<ListViewModel>(context, listen: false)
          .setButtonState(context, i, false);
    }
    notifyListeners();
  }

  void setButtonState(BuildContext context, int buttonIndex, bool isEnabled) {
    switch (buttonIndex) {
      case 1:
        break;
      case 2:
        Provider.of<ListViewModel>(context, listen: false)
            .setButtonState(context, 3, isEnabled);
        break;
      case 3:
        Provider.of<ListViewModel>(context, listen: false)
            .setButtonState(context, 2, isEnabled);
        break;
      case 4:
        break;
    }

    notifyListeners();
  }
}

class ListItem {
  String name;
  bool isSelected;

  ListItem({required this.name, required this.isSelected});
}

class ListModel extends ChangeNotifier {
  final List<ListItem> _items = [
    ListItem(name: 'Item 1', isSelected: false),
    ListItem(name: 'Item 2', isSelected: false),
    ListItem(name: 'Item 3', isSelected: false),
    ListItem(name: 'Item 4', isSelected: false),
    ListItem(name: 'Item 5', isSelected: false),
    ListItem(name: 'Item 6', isSelected: false),
    ListItem(name: 'Item 7', isSelected: false),
    ListItem(name: 'Item 8', isSelected: false),
    ListItem(name: 'Item 9', isSelected: false),
    ListItem(name: 'Item 10', isSelected: false),
  ];

  List<ListItem> get items => _items;

  bool selectItem(int index) {
    for (int i = 0; i < _items.length; i++) {
      if (i == index) {
        _items[i].isSelected = !_items[i].isSelected;
      } else {
        _items[i].isSelected = false;
      }
    }

    return _items[index].isSelected;
  }

  void deleteItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void moveItemUp(int index) {
    if (index == 0) {
      ListItem item = _items.removeAt(index);
      _items.add(item);
    } else {
      ListItem item = _items.removeAt(index);
      _items.insert(index - 1, item);
    }
    notifyListeners();
  }

  void moveItemDown(int index) {
    if (index == _items.length - 1) {
      ListItem item = _items.removeAt(index);
      _items.insert(0, item);
    } else {
      ListItem item = _items.removeAt(index);
      _items.insert(index + 1, item);
    }
    notifyListeners();
  }
}
