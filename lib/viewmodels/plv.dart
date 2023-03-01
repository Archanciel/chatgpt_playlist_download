import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:my_app/models/playlist_video.dart';

import '../models/playlist_video.dart';

class PlaylistViewModel extends ChangeNotifier {
  late AudioPlayer _audioPlayer;

  List<PlaylistVideo> _playlistVideos = [];
  List<PlaylistVideo> get playlistVideos => _playlistVideos;

  Future<void> downloadVideo(PlaylistVideo video) async {
    // Use the PlaylistVideo class
    final videoId = video.id;
    final videoTitle = video.title;
    final downloadUrl = 'https://www.youtube.com/watch?v=$videoId';

    // Get the app directory for saving the file
    final appDir = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${appDir.path}/downloads');
    await downloadsDir.create(recursive: true);

    // Check if the file already exists
    final file = File('${downloadsDir.path}/$videoTitle.mp3');
    
    if (await file.exists()) {
      return;
    }

    // Download the audio
    final response = await http.get(Uri.parse(downloadUrl));
    final html = response.body;
    final regExp = RegExp('"url_encoded_fmt_stream_map":"(.+?)"');
    final match = regExp.firstMatch(html);
    if (match == null) {
      throw Exception('Could not find video URL');
    }
    final urlEncodedFmtStreamMap = match.group(1);
    final streamInfos = urlEncodedFmtStreamMap
        .split(',')
        .where((info) => info.contains('audio/mp4'))
        .map((info) => Uri.splitQueryString(info))
        .toList();
    final url = streamInfos.first['url'];
    final headers = {'Referer': 'https://www.youtube.com/'};
    final audioRequest = http.Request('GET', Uri.parse(url!))..headers.addAll(headers);
    final audioResponse = await audioRequest.send();
    final audioStream = audioResponse.stream;
    await audioStream.pipe(file.openWrite());

    // Add the video to the list of downloaded videos
    _playlistVideos.add(video);
    notifyListeners();
  }
}
