// dart file located in lib\viewmodels

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/download_playlist.dart';
import '../models/downloaded_video.dart';
import '../utils/dir_util.dart';

class VideoDownloadViewModel extends ChangeNotifier {
  final List<DownloadedVideo> _downloadedVideoLst = [];
  List<DownloadedVideo> get downloadedVideoLst => _downloadedVideoLst;

  YoutubeExplode _yt = YoutubeExplode();
  YoutubeExplode get yt => _yt;
  set yt(YoutubeExplode yt) => _yt = yt;

  Future<void> downloadPlaylistVideos(
      DownloadPlaylist playlistToDownload) async {
    playlistToDownload.id =
        PlaylistId.parsePlaylistId(playlistToDownload.url) ?? '';
    final Playlist youtubePlaylist =
        await _yt.playlists.get(playlistToDownload.id);
    playlistToDownload.title = youtubePlaylist.title;
    playlistToDownload.downloadPath =
        '${DirUtil.getPlaylistDownloadHomePath()}${Platform.pathSeparator}${playlistToDownload.title}';

    await for (Video video in _yt.playlists.getVideos(playlistToDownload.id)) {
      final alreadyDownloaded = _downloadedVideoLst
          .any((downloadedVideo) => downloadedVideo.id == video.id.toString());

      if (alreadyDownloaded) {
        continue;
      }

      final StreamManifest streamManifest =
          await _yt.videos.streamsClient.getManifest(video.id);
      final AudioOnlyStreamInfo audioStreamInfo =
          streamManifest.audioOnly.first;

      final String audioTitle = video.title;
      final Duration? audioDuration = video.duration;

      String validAudioFileName =
          _replaceUnauthorizedDirOrFileNameChars(video.title);

      final String downloadVideoFilePathName =
          '${playlistToDownload.downloadPath}${Platform.pathSeparator}${video.title}.mp3';

      final downloadedVideo = DownloadedVideo(
        id: video.id.toString(),
        title: video.title,
        audioFilePath: downloadVideoFilePathName,
        downloadDate: DateTime.now(),
      );

      // Download the DownloadedVideo file
      await _downloadAudioFile(
          video, audioStreamInfo, downloadVideoFilePathName);

      playlistToDownload.addDownloadedVideo(downloadedVideo);

      notifyListeners();
    }
  }

  Future<void> _downloadAudioFile(
      Video video, AudioStreamInfo audioStreamInfo, String filePath) async {
    final YoutubeExplode yt = YoutubeExplode();

    final IOSink output = File(filePath).openWrite();
    final Stream<List<int>> stream =
        yt.videos.streamsClient.get(audioStreamInfo);

    await stream.pipe(output);
  }

  String _replaceUnauthorizedDirOrFileNameChars(String rawFileName) {
    // Replace '|' by ' if '|' is located at end of file name
    if (rawFileName.endsWith('|')) {
      rawFileName = rawFileName.substring(0, rawFileName.length - 1);
    }

    // Replace '||' by '_' since YoutubeDL replaces '||' by '_'
    rawFileName = rawFileName.replaceAll('||', '|');

    // Replace '//' by '_' since YoutubeDL replaces '//' by '_'
    rawFileName = rawFileName.replaceAll('//', '/');

    final charToReplace = {
      '\\': '',
      '/': '_', // since YoutubeDL replaces '/' by '_'
      ':': ' -', // since YoutubeDL replaces ':' by ' -'
      '*': ' ',
      // '.': '', point is not illegal in file name
      '?': '',
      '"': "'", // since YoutubeDL replaces " by '
      '<': '',
      '>': '',
      '|': '_', // since YoutubeDL replaces '|' by '_'
      // "'": '_', apostrophe is not illegal in file name
    };

    // Replace all multiple characters in a string based on translation table created by dictionary
    String validFileName = rawFileName;
    charToReplace.forEach((key, value) {
      validFileName = validFileName.replaceAll(key, value);
    });

    // Since YoutubeDL replaces '?' by ' ', determining if a video whose title
    // ends with '?' has already been downloaded using
    // replaceUnauthorizedDirOrFileNameChars(videoTitle) + '.mp3' can be executed
    // if validFileName.trim() is NOT done.
    return validFileName.trim();
  }
}

void main() {
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
            },
            child: const Text('Click'),
          ),
        ),
      ),
    );
  }
}
