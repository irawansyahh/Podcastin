// Copyright 2020 Irawansyah. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:Podcastin/api/podcast/podcast_api.dart';
import 'package:Podcastin/entities/episode.dart';
import 'package:Podcastin/entities/podcast.dart';
import 'package:Podcastin/repository/repository.dart';
import 'package:Podcastin/state/episode_state.dart';
import 'package:meta/meta.dart';
import 'package:podcast_search/podcast_search.dart' as pcast;

abstract class PodcastService {
  final PodcastApi api;
  final Repository repository;

  PodcastService({
    @required this.api,
    @required this.repository,
  });

  Future<pcast.SearchResult> search({
    @required String term,
    String country,
    String attribute,
    int limit,
    String language,
    int version = 0,
    bool explicit = false,
  });

  Future<pcast.SearchResult> charts({
    @required int size,
  });

  Future<Podcast> loadPodcast({
    @required Podcast podcast,
    bool refresh,
  });

  Future<Podcast> loadPodcastById({
    @required int id,
  });

  Future<List<Episode>> loadDownloads();

  Future<void> deleteDownload(Episode episode);
  Future<void> toggleEpisodePlayed(Episode episode);
  Future<List<Podcast>> subscriptions();
  Future<Podcast> subscribe(Podcast podcast);
  Future<void> unsubscribe(Podcast podcast);
  Future<Podcast> save(Podcast podcast);
  Future<Episode> saveEpisode(Episode episode);

  /// Event listeners
  Stream<Podcast> podcastListener;
  Stream<EpisodeState> episodeListener;
}
