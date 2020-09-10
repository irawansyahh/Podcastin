// Copyright 2020 Irawansyah. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:Podcastin/api/podcast/mobile_podcast_api.dart';
import 'package:Podcastin/bloc/discovery/discovery_bloc.dart';
import 'package:Podcastin/bloc/podcast/audio_bloc.dart';
import 'package:Podcastin/bloc/podcast/episode_bloc.dart';
import 'package:Podcastin/bloc/podcast/podcast_bloc.dart';
import 'package:Podcastin/bloc/search/search_bloc.dart';
import 'package:Podcastin/l10n/L.dart';
import 'package:Podcastin/pages/login.dart';
import 'package:Podcastin/repository/repository.dart';
import 'package:Podcastin/repository/sembast/sembast_repository.dart';
import 'package:Podcastin/services/audio/audio_player_service.dart';
import 'package:Podcastin/services/audio/mobile_audio_service.dart';
import 'package:Podcastin/services/auth.dart';
import 'package:Podcastin/services/download/download_service.dart';
import 'package:Podcastin/services/download/mobile_download_service.dart';
import 'package:Podcastin/services/podcast/mobile_podcast_service.dart';
import 'package:Podcastin/services/podcast/podcast_service.dart';
import 'package:Podcastin/state/pager_bloc.dart';
import 'package:Podcastin/ui/library/discovery.dart';
import 'package:Podcastin/ui/library/downloads.dart';
import 'package:Podcastin/ui/library/library.dart';
import 'package:Podcastin/ui/search/search.dart';
import 'package:Podcastin/ui/themes.dart';
import 'package:Podcastin/ui/widgets/mini_player_widget.dart';
import 'package:Podcastin/ui/widgets/search_slide_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final theme = Themes.lightTheme().themeData;

/// Podcastin is a Podcast player. You can search and subscribe to podcasts,
/// download and stream episodes and view the latest podcast charts.
// ignore: must_be_immutable
class PodcastinPodcastApp extends StatelessWidget {
  final Repository repository;
  final MobilePodcastApi podcastApi;
  DownloadService downloadService;
  PodcastService podcastService;
  AudioPlayerService audioPlayerService;

  // Initialise all the services our application will need.
  PodcastinPodcastApp()
      : repository = SembastRepository(),
        podcastApi = MobilePodcastApi() {
    downloadService = MobileDownloadService(repository: repository);
    podcastService =
        MobilePodcastService(api: podcastApi, repository: repository);
    audioPlayerService = MobileAudioPlayerService(repository: repository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SearchBloc>(
          create: (_) => SearchBloc(
              podcastService: MobilePodcastService(
                  api: podcastApi, repository: repository)),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<DiscoveryBloc>(
          create: (_) => DiscoveryBloc(
              podcastService: MobilePodcastService(
                  api: podcastApi, repository: repository)),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<EpisodeBloc>(
          create: (_) => EpisodeBloc(
              podcastService:
                  MobilePodcastService(api: podcastApi, repository: repository),
              audioPlayerService: audioPlayerService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<PodcastBloc>(
          create: (_) => PodcastBloc(
              podcastService: podcastService,
              audioPlayerService: audioPlayerService,
              downloadService: downloadService),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<PagerBloc>(
          create: (_) => PagerBloc(),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<AudioBloc>(
          create: (_) => AudioBloc(audioPlayerService: audioPlayerService),
          dispose: (_, value) => value.dispose(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Podcastin Podcast Player',
        localizationsDelegates: [
          const LocalisationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('de', ''),
        ],
        theme: theme,
        home: PodcastinHomePage(title: 'Podcastin Podcast Player'),
      ),
    );
  }
}

class PodcastinHomePage extends StatefulWidget {
  final String title;

  PodcastinHomePage({this.title});

  @override
  _PodcastinHomePageState createState() => _PodcastinHomePageState();
}

class _PodcastinHomePageState extends State<PodcastinHomePage>
    with WidgetsBindingObserver {
  Widget library;

  @override
  void initState() {
    super.initState();

    final audioBloc = Provider.of<AudioBloc>(context, listen: false);

    WidgetsBinding.instance.addObserver(this);

    audioBloc.transitionLifecycleState(LifecyleState.resume);
  }

  @override
  void dispose() {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    audioBloc.transitionLifecycleState(LifecyleState.pause);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final audioBloc = Provider.of<AudioBloc>(context, listen: false);
    switch (state) {
      case AppLifecycleState.resumed:
        audioBloc.transitionLifecycleState(LifecyleState.resume);

        // We need to update the chrome on resume as otherwise if
        // another application (or the launcher) changes them, when
        // we switch back it will stay as the other app put them.
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
          statusBarBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.dark,
        ));

        break;
      case AppLifecycleState.paused:
        audioBloc.transitionLifecycleState(LifecyleState.pause);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pager = Provider.of<PagerBloc>(context);
    final searchBloc = Provider.of<EpisodeBloc>(context);
    AuthService auth = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  title: TitleWidget(),
                  brightness: Brightness.light,
                  backgroundColor: Colors.white,
                  floating: false,
                  pinned: true,
                  snap: false,
                  actions: <Widget>[
                    IconButton(
                      tooltip: L.of(context).search_button_label,
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          SlideRightRoute(widget: Search()),
                        );
                      },
                    ),
                    FlatButton.icon(
                        icon: Icon(Icons.person),
                        label: Text('Logout'),
                        onPressed: () {
                          auth.signOut();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage(),
                                fullscreenDialog: true),
                          );
                        }),
                  ],
                ),
                StreamBuilder<int>(
                    stream: pager.currentPage,
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      return _fragment(snapshot.data, searchBloc);
                    }),
              ],
            ),
          ),
          MiniPlayer(),
        ],
      ),
      bottomNavigationBar: StreamBuilder<int>(
          stream: pager.currentPage,
          initialData: 0,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: snapshot.data,
              onTap: pager.changePage,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.library_music),
                  title: Text(L.of(context).library),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  title: Text(L.of(context).discover),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.file_download),
                  title: Text(L.of(context).downloads),
                ),
              ],
            );
          }),
    );
  }

  Widget _fragment(int index, EpisodeBloc searchBloc) {
    if (index == 0) {
      return Library();
    } else if (index == 1) {
      return Discovery();
    } else {
      return Downloads();
    }
  }

  void _menuSelect(String choice) async {
    final packageInfo = await PackageInfo.fromPlatform();

    switch (choice) {
      case 'about':
        showAboutDialog(
            context: context,
            applicationName: 'Podcastin Podcast Player',
            applicationVersion:
                'v${packageInfo.version} Alpha build ${packageInfo.buildNumber}',
            applicationIcon: Image.asset(
              'assets/images/Podcastin-logo-s.png',
              width: 52.0,
              height: 52.0,
            ),
            children: <Widget>[
              Text('\u00a9 2020 Irawansyah'),
              GestureDetector(
                  child: Text('Irawansyah',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue)),
                  onTap: () {
                    _launchEmail();
                  }),
            ]);
        break;
    }
  }

  void _launchEmail() async {
    const url = 'mailto:Irawansyah';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class TitleWidget extends StatelessWidget {
  final TextStyle _titleTheme1 = theme.textTheme.bodyText2.copyWith(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontFamily: 'MontserratRegular',
      fontSize: 18);

  final TextStyle _titleTheme2 = theme.textTheme.bodyText2.copyWith(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'MontserratRegular',
      fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Row(
        children: <Widget>[
          Text(
            'Podcastin ',
            style: _titleTheme1,
          ),
          Text(
            'Player',
            style: _titleTheme2,
          ),
        ],
      ),
    );
  }
}
