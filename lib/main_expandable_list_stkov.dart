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
                onPressed: Provider.of<ListViewModel>(context).isButton1Enabled
                    ? () {
                        Provider.of<ListViewModel>(context, listen: false)
                            .deleteSelectedItem(context);
                      }
                    : null,
                child: const Text('Delete'),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: Provider.of<ListViewModel>(context).isButton2Enabled
                    ? () {
                        Provider.of<ListViewModel>(context, listen: false)
                            .moveSelectedItemUp();
                      }
                    : null,
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.arrow_drop_up,
                  size: 50,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: Provider.of<ListViewModel>(context).isButton3Enabled
                    ? () {
                        Provider.of<ListViewModel>(context, listen: false)
                            .moveSelectedItemDown();
                      }
                    : null,
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
  bool _isButton1Enabled = false;
  bool _isButton2Enabled = false;
  bool _isButton3Enabled = false;

  bool get isListExpanded => _isListExpanded;
  bool get isButton1Enabled => _isButton1Enabled;
  bool get isButton2Enabled => _isButton2Enabled;
  bool get isButton3Enabled => _isButton3Enabled;

  final ListModel _model = ListModel();
  List<ListItem> get items => _model.items;

  void toggleList() {
    _isListExpanded = !_isListExpanded;

    if (!_isListExpanded) {
      _disableButtons();
    } else {
      if (_model.isListItemSelected) {
        _enableButtons();
      } else {
        _disableButtons();
      }
    }

    notifyListeners();
  }

  void selectItem(BuildContext context, int index) {
    bool isOneItemSelected = _model.selectItem(index);

    if (!isOneItemSelected) {
      _disableButtons();
    } else {
      _enableButtons();
    }

    notifyListeners();
  }

  void deleteSelectedItem(BuildContext context) {
    int selectedIndex = _getSelectedIndex();

    if (selectedIndex != -1) {
      _model.deleteItem(selectedIndex);
      _disableButtons();

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

  void _enableButtons() {
    _isButton1Enabled = true;
    _isButton2Enabled = true;
    _isButton3Enabled = true;
  }

  void _disableButtons() {
    _isButton1Enabled = false;
    _isButton2Enabled = false;
    _isButton3Enabled = false;
  }
}

class ListItem {
  String name;
  bool isSelected;

  ListItem({required this.name, required this.isSelected});
}

class ListModel extends ChangeNotifier {
  bool _isListItemSelected = false;

  bool get isListItemSelected => _isListItemSelected;
  set isListItemSelected(bool value) => _isListItemSelected = value;

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

    _isListItemSelected = _items[index].isSelected;

    return _isListItemSelected;
  }

  void deleteItem(int index) {
    _items.removeAt(index);
    _isListItemSelected = false;
    
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
