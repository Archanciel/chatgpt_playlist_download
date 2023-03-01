import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';

import '../models/downloaded_video.dart';
import '../models/playlist.dart';
import '../models/playlist_video.dart';

class PlaylistViewModel extends ChangeNotifier {
  final List<DownloadedVideo> downloadedVideos = [];

  Future<void> downloadVideo(PlaylistVideo video) async {
    // Vérifie si la vidéo a déjà été téléchargée
    final alreadyDownloaded = downloadedVideos
        .any((downloadedVideo) => downloadedVideo.id == video.id);
    if (alreadyDownloaded) {
      return;
    }

    // Récupère le fichier audio de la vidéo
    final audioFile = await _getAudioFile(video);

    // Ajoute la vidéo téléchargée à la liste
    final downloadedVideo = DownloadedVideo(
      id: video.id,
      title: video.title,
      audioFilePath: audioFile,
      downloadDate: DateTime.now(),
    );

    downloadedVideos.add(downloadedVideo);

    // Avertissement de modification de la liste des vidéos téléchargées
    notifyListeners();
  }

  Future<File> _getAudioFile(PlaylistVideo video) async {
    // Crée le répertoire de stockage des fichiers audio téléchargés
    final directory = await getApplicationDocumentsDirectory();
    final audioDirectory = Directory('${directory.path}/audio');
    await audioDirectory.create(recursive: true);

    // Crée un nouveau fichier audio pour la vidéo
    final audioFilePath = '${audioDirectory.path}/${video.id}.mp3';
    final audioFile = File(audioFilePath);

    // Vérifie si le fichier audio existe déjà
    if (await audioFile.exists()) {
      return audioFile;
    }

    // Télécharge l'audio de la vidéo avec just_audio
    final audioSource = AudioSource.uri(Uri.parse(video.audioUrl));
    final player = AudioPlayer();
    await player.setAudioSource(audioSource);
    await player.load();
    final audioData = await player.;
    await audioFile.writeAsBytes(audioData);

    // Retourne le fichier audio téléchargé
    return audioFile;
  }
}
