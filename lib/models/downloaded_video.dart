import 'dart:io';

/// Video downloaded informations
class DownloadedVideo {
  final String id;
  final String title;
  final String audioFilePath;
  final DateTime downloadDate;

  DownloadedVideo({
    required this.id,
    required this.title,
    required this.audioFilePath,
    required this.downloadDate,
  });
}
