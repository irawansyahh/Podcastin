// Copyright 2020 Irawansyah. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:Podcastin/bloc/podcast/episode_bloc.dart';
import 'package:Podcastin/entities/episode.dart';
import 'package:Podcastin/l10n/L.dart';
import 'package:Podcastin/state/bloc_state.dart';
import 'package:Podcastin/ui/widgets/episode_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  @override
  void initState() {
    super.initState();

    final bloc = Provider.of<EpisodeBloc>(context, listen: false);

    bloc.fetchDownloads(false);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<EpisodeBloc>(context);

    return StreamBuilder<BlocState>(
      stream: bloc.downloads,
      builder: (BuildContext context, AsyncSnapshot<BlocState> snapshot) {
        final state = snapshot.data;

        if (state is BlocPopulatedState) {
          return buildResults(context, state.results as List<Episode>);
        } else {
          if (state is BlocLoadingState) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else if (state is BlocErrorState) {
            return SliverFillRemaining(
              hasScrollBody: false,
              child: Text('ERROR'),
            );
          }

          return SliverFillRemaining(
            hasScrollBody: false,
            child: Container(),
          );
        }
      },
    );
  }

  Widget buildResults(BuildContext context, List<Episode> episodes) {
    if (episodes.isNotEmpty) {
      return SliverList(
          delegate: SliverChildListDelegate([
        ListView.builder(
          padding: EdgeInsets.all(0.0),
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: episodes.length,
          itemBuilder: (BuildContext context, int index) {
            return EpisodeTile(
              episode: episodes[index],
              download: false,
              play: true,
            );
          },
        )
      ]));
    } else {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cloud_download,
                size: 75,
                color: Colors.blue[900],
              ),
              Text(
                L.of(context).no_downloads_message,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
}
