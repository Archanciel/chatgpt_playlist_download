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
                child: Text('Toggle List'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<ListViewModel>(context, listen: false)
                      .deleteSelectedItem(context);
                },
                child: Text('Delete Selected Item'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<ListViewModel>(context, listen: false)
                      .moveSelectedItemUp();
                },
                child: Text('Move Selected Item Up'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<ListViewModel>(context, listen: false)
                      .moveSelectedItemDown();
                },
                child: Text('Move Selected Item Down'),
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
