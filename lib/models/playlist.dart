import 'package:chatgpt_playlist_download/models/playlist_video.dart';

class Playlist {
  final String id;
  final String title;
  final List<PlaylistVideo> videos;

  Playlist({
    required this.id,
    required this.title,
    required this.videos,
  });
}
