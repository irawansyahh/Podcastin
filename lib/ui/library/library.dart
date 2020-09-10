// Copyright 2020 Irawansyah. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:Podcastin/bloc/podcast/podcast_bloc.dart';
import 'package:Podcastin/entities/podcast.dart';
import 'package:Podcastin/l10n/L.dart';
import 'package:Podcastin/ui/widgets/podcast_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  Widget build(BuildContext context) {
    final _podcastBloc = Provider.of<PodcastBloc>(context);

    return StreamBuilder<List<Podcast>>(
        stream: _podcastBloc.subscriptions,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.headset,
                        size: 75,
                        color: Colors.blue[900],
                      ),
                      Text(
                        L.of(context).no_subscriptions_message,
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return SliverList(
                delegate: SliverChildListDelegate([
                  ListView.builder(
                    padding: EdgeInsets.all(0.0),
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PodcastTile(
                          podcast: snapshot.data.elementAt(index));
                    },
                  ),
                ]),
              );
            }
          } else {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Container(),
            );
          }
        });
  }
}
