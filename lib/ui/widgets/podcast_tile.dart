// Copyright 2020 Irawansyah. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:Podcastin/bloc/podcast/podcast_bloc.dart';
import 'package:Podcastin/entities/podcast.dart';
import 'package:Podcastin/ui/podcast/podcast_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PodcastTile extends StatelessWidget {
  final Podcast podcast;

  const PodcastTile({
    @required this.podcast,
  });

  @override
  Widget build(BuildContext context) {
    final _podcastBloc = Provider.of<PodcastBloc>(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (context) =>
                        PodcastDetails(podcast, _podcastBloc)),
              );
            },
            leading: Hero(
              tag: '${podcast.imageUrl}:${podcast.link}',
              child: CachedNetworkImage(
                fadeInDuration: Duration(seconds: 0),
                fadeOutDuration: Duration(seconds: 0),
                imageUrl: podcast.thumbImageUrl,
                width: 60,
                placeholder: (context, url) {
                  return Container(
                    constraints: BoxConstraints.expand(height: 60, width: 60),
                    child: Placeholder(
                      color: Colors.grey,
                      strokeWidth: 1,
                      fallbackWidth: 60,
                      fallbackHeight: 60,
                    ),
                  );
                },
                errorWidget: (_, __, dynamic ___) {
                  return Container(
                    constraints: BoxConstraints.expand(height: 60, width: 60),
                    child: Placeholder(
                      color: Colors.grey,
                      strokeWidth: 1,
                      fallbackWidth: 60,
                      fallbackHeight: 60,
                    ),
                  );
                },
              ),
            ),
            title: Text(
              podcast.title,
              maxLines: 1,
            ),
            subtitle: Text(
              podcast.copyright ?? '',
              maxLines: 2,
            ),
            isThreeLine: false,
          ),
        ],
      ),
    );
  }
}
