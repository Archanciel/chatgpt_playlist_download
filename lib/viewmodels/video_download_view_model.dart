// dart file located in lib\viewmodels

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../models/downloaded_video.dart';

class VideoDownloadViewModel extends ChangeNotifier {
  final List<DownloadedVideo> _downloadedVideoLst = [];
  List<DownloadedVideo> get downloadedVideoLst => _downloadedVideoLst;

  YoutubeExplode _yt = YoutubeExplode();
  YoutubeExplode get yt => _yt;
  set yt(YoutubeExplode yt) => _yt = yt;

  final Directory _audioDownloadDir = Directory('/storage/emulated/0/Download');

  Future<void> downloadPlaylistVideos(String playlistUrl) async {
    final String? playlistId = PlaylistId.parsePlaylistId(playlistUrl);
    final Playlist playlist = await _yt.playlists.get(playlistId);

    await for (Video video in _yt.playlists.getVideos(playlistId)) {
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

      final String filePath = '${_audioDownloadDir.path}/${video.title}.mp3';

      final downloadedVideo = DownloadedVideo(
        id: video.id.toString(),
        title: video.title,
        audioFilePath: filePath,
        downloadDate: DateTime.now(),
      );

      _downloadedVideoLst.add(downloadedVideo);

      // Download the DownloadedVideo file
      await _downloadAudioFile(video, audioStreamInfo, filePath);
      // Do something with the downloaded file

      notifyListeners();
    }

//    notifyListeners();
  }

  Future<void> _downloadAudioFile(
      Video video, AudioStreamInfo audioStreamInfo, String filePath) async {
    final YoutubeExplode yt = YoutubeExplode();

    final IOSink output = File(filePath).openWrite();
    final Stream<List<int>> stream = yt.videos.streamsClient.get(audioStreamInfo);

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
