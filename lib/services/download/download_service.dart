// Copyright 2020 Irawansyah. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:Podcastin/entities/episode.dart';
import 'package:Podcastin/repository/repository.dart';
import 'package:flutter/foundation.dart';

abstract class DownloadService {
  final Repository repository;

  DownloadService({
    @required this.repository,
  });

  Future<bool> downloadEpisode(Episode episode);
  Future<Episode> findEpisodeByTaskId(String taskId);

  void dispose();
}
