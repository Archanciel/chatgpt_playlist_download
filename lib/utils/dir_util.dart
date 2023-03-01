import 'dart:io';

import '../constants.dart';

class DirUtil {
  static Future<String> getPlaylistDownloadHomePath() async {
    if (await Directory(kDownloadAppDir).exists()) {
      return kDownloadAppDir;
    } else {
      return kDownloadAppTestDir;
    }
  }
}
