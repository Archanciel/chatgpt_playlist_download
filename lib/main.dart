import 'package:chatgpt_playlist_download/utils/dir_util.dart';
import 'package:chatgpt_playlist_download/viewmodels/video_download_view_model.dart';
import 'package:flutter/material.dart';

import 'models/download_playlist.dart';

Future<void> main(List<String> args) async {
  List<String> myArgs = [];

  if (args.isNotEmpty) {
    myArgs = args;
  } else {
    // myArgs = ["delAppDir"]; // used to empty dir on emulator
    //                            app dir
  }

  bool deleteAppDir = false;

  if (myArgs.isNotEmpty) {
    if (myArgs.contains("delAppDir")) {
      deleteAppDir = true;
    }
  }

  // It was necessary to place here the asynchronous
  // TransferDataViewModel instanciation instead of locating it
  // in [_MainAppState.build()] or [_MainAppState.initState()],
  // reference is done at the beginning of the
  //_MainAppState.build() method.
  await DirUtil.createAppDirIfNotExist(isAppDirToBeDeleted: deleteAppDir);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              VideoDownloadViewModel videoDownloadViewModel =
                  VideoDownloadViewModel();
              DownloadPlaylist playlistToDownload = DownloadPlaylist(
                  url:
                      'https://youtube.com/playlist?list=PLzwWSJNcZTMTB9iwbu77FGokc3WsoxuV0');
              await videoDownloadViewModel
                  .downloadPlaylistVideos(playlistToDownload);
              print('***************** **************');
              print(playlistToDownload.downloadedVideoLst);
              print('***************** **************');
            },
            child: const Text('Click'),
          ),
        ),
      ),
    );
  }
}
