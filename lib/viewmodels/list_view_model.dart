import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/list_model.dart';

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
