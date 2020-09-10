// Copyright 2020 Irawansyah. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:Podcastin/ui/Podcastin_podcast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:Podcastin/app.dart';
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   Logger.root.level = Level.FINE;

//   Logger.root.onRecord.listen((record) {
//     print(
//         '${record.level.name}: - ${record.time}: ${record.loggerName}: ${record.message}');
//   });

//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     statusBarIconBrightness: Brightness.light,
//     systemNavigationBarColor: Colors.white,
//     statusBarBrightness: Brightness.light,
//     systemNavigationBarIconBrightness: Brightness.dark,
//   ));

//   runApp(PodcastinPodcastApp());
// }

void main() {
  runApp(DemoApp());
}
