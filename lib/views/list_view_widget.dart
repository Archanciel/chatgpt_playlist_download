import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/list_model.dart';
import '../viewmodels/list_view_model.dart';

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
