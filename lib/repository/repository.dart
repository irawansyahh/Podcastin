// Copyright 2020 Irawansyah. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:Podcastin/entities/episode.dart';
import 'package:Podcastin/entities/podcast.dart';
import 'package:Podcastin/state/episode_state.dart';

/// An abstract class that represent the actions supported by the chosen
/// database or storage implementation.
abstract class Repository {
  /// General
  Future<void> close();

  /// Podcasts
  Future<Podcast> findPodcastById(num id);
  Future<Podcast> findPodcastByGuid(String guid);
  Future<Podcast> savePodcast(Podcast podcast);
  Future<void> deletePodcast(Podcast podcast);
  Future<List<Podcast>> subscriptions();

  /// Episodes
  Future<Episode> findEpisodeByGuid(String guid);
  Future<List<Episode>> findEpisodesByPodcastGuid(String pguid);
  Future<Episode> findEpisodeByTaskId(String taskId);
  Future<Episode> saveEpisode(Episode episode);
  Future<void> deleteEpisode(Episode episode);
  Future<List<Episode>> findDownloadsByPodcastGuid(String pguid);
  Future<List<Episode>> findDownloads();

  /// Event listeners
  Stream<Podcast> podcastListener;
  Stream<EpisodeState> episodeListener;
}
