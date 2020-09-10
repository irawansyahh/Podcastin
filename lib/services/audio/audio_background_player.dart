// Copyright 2020 Irawansyah. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:Podcastin/services/audio/mobile_audio_player.dart';
import 'package:audio_service/audio_service.dart';
import 'package:logging/logging.dart';

/// This is the implementation of the Podcastin Audio Service for Android. This
/// version uses AudioService and AudioPlayer packages to provide the audio
/// playback and Android services for continuing playback in the background.
class BackgroundPlayerTask extends BackgroundAudioTask {
  final log = Logger('BackgroundPlayerTask');
  final _PodcastinAudioPlayer = MobileAudioPlayer();

  /// As we are running in a separate Isolate, we need a separate Logger -
  /// or we'll not see anything in the console/logs!.
  BackgroundPlayerTask() {
    Logger.root.level = Level.FINE;

    Logger.root.onRecord.listen((record) {
      print(
          '${record.level.name}: - ${record.time}: ${record.loggerName}: ${record.message}');
    });
  }

  @override
  Future<void> onStart(Map<String, dynamic> params) {
    log.fine('onStart()');
    return _PodcastinAudioPlayer.start();
  }

  @override
  void onStop() async {
    log.fine('onStop()');
    await _PodcastinAudioPlayer.stop();
  }

  @override
  void onPlay() {
    log.fine('onPlay()');
    _PodcastinAudioPlayer.play();
  }

  @override
  void onPause() {
    log.fine('onPause()');
    _PodcastinAudioPlayer.pause();
  }

  @override
  void onSeekTo(Duration position) {
    log.fine('onSeekTo()');
    _PodcastinAudioPlayer.seekTo(position);
  }

  @override
  void onAudioBecomingNoisy() {
    _PodcastinAudioPlayer.onNoise();
  }

  @override
  Future<dynamic> onCustomAction(String name, dynamic arguments) async {
    log.fine('onCustomAction()');
    switch (name) {
      case 'track':
        await _PodcastinAudioPlayer.setMediaItem(arguments);
        break;
      case 'position':
        await _PodcastinAudioPlayer.updatePosition();
        break;
      case 'kill':
        await _PodcastinAudioPlayer.stop();
        break;
    }
  }

  @override
  void onFastForward() async {
    log.fine('onFastForward()');
    await _PodcastinAudioPlayer.fastforward();
  }

  @override
  void onRewind() async {
    log.fine('onRewind()');
    await _PodcastinAudioPlayer.rewind();
  }
}
