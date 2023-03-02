import 'package:chatgpt_playlist_download/viewmodels/list_view_model.dart';
import 'package:chatgpt_playlist_download/views/list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListViewModel(context),
      child: MaterialApp(
        title: 'MVVM Example',
        home: Scaffold(
          appBar: AppBar(
            title: Text('MVVM Example'),
          ),
          body: ListViewWidget(),
        ),
      ),
    );
  }
}
