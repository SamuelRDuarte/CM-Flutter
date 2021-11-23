import 'package:musicBuddies/favorite_model.dart';
import 'package:musicBuddies/global.dart';
import 'package:musicBuddies/Pages/favorites.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:qr_code_scanner/qr_code_scanner.dart';
//import 'package:spotify/spotify.dart';
import 'package:spotify_auth_player/spotify_auth_player.dart';

//void main() => runApp(SpotifirePage());

class SpotifirePage extends StatefulWidget {
  const SpotifirePage({Key? key, required this.barcode}) : super(key: key);

  final Barcode? barcode;

  @override
  _SpotifireState createState() => _SpotifireState();
}

class _SpotifireState extends State<SpotifirePage> {
  Music? _music;
  int totaldurationinmilli = 0;
  bool ispaused = false;
  bool isFavourite = true;


  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    print("INIT PLATFORM STATE");
    await Spotifire.init(clientid: client_id);


    //Spotifire.positonStream.listen(print);
    if (!mounted) return;

    Spotifire.musicStream.listen((music) async {
      //print(music.runtimeType);

      if (mounted){
        isFavourite = await isInFavaorites(music!.name);
          setState(() {
            totaldurationinmilli = music.duration.inMilliseconds;
            print(music.duration);
            _music = music;
          });

      };
    }).onError((error) {
      print(error);
    });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
  }

  Future<void> addFavorite(Favorite fav) async {
    var box = await Hive.openBox<Favorite>('favorites');
    box.put(fav.name, fav);
  }

  Future<Favorite?> getFavorite(String fav) async{
    var box = await Hive.openBox<Favorite>('favorites');
    return box.get(fav);
  }

  Future<bool> isInFavaorites(String music) async{
    var fav = await getFavorite(music);
    return fav == null ? false : true;
  }

  void deleteFavorite(String key) async{
    var box = await Hive.openBox<Favorite>('favorites');
    box.delete(key);
  }

  double val = 0.01;
  @override
  Widget build(BuildContext context) {
    var date = DateTime.now();
    Future.sync(() async => isFavourite = await isInFavaorites(_music!.name));
    print("barcode: " + widget.barcode!.code.toString());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text('MusicBuddies'),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: 900,
              // width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                      colors: <Color>[
                        Color.fromRGBO(29, 185, 84, 1.0),
                        Color.fromRGBO(25, 20, 20, 1.0)
                      ])),
            ),
            ListView(
              padding: const EdgeInsets.all(12),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    if (_music != null)

                      Material(
                          elevation: 7.0,
                          child: Image.memory(_music!.musicImage)),
                    Text(_music != null ? _music!.name : "Loading ... ",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            ?.copyWith(color: Colors.white.withOpacity(0.95))),
                    Text(
                      _music != null ? _music!.album : "Loading ... ",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: Colors.white70),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 228.0),
                      child: Text(
                        _music != null
                            ? _music!.duration.toString().split(".")[0]
                            : "Loading ... ",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    StreamBuilder<Duration>(
                        stream: Spotifire.positonStream,
                        // initialData: Duration.zero,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Slider.adaptive(
                              value: 0.0,
                              onChanged: (d) { },
                            );
                          print(snapshot.hasData);
                          val = snapshot.hasData
                              ? _getValue(snapshot.data!.inMilliseconds)
                              : val;

                          return Slider.adaptive(
                            value: val,
                            onChanged: (double cv) async {
                              final int skd =
                              (totaldurationinmilli * cv).floor();
                              final Duration dur = Duration(milliseconds: skd);
                              await Spotifire.seekTo(
                                  seekDuration: dur,
                                  totalDuration: Duration(
                                      milliseconds: totaldurationinmilli));
                            },
                          );
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        AnimatedCrossFade(
                            firstChild: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  size: 40,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  //TODO
                                  deleteFavorite(_music!.name);
                                  setState(() {
                                    isFavourite = false;
                                  });
                                }),
                            secondChild: IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  size: 40,
                                  color: Colors.white70,
                                ),
                                onPressed: () async {
                                  //TODO
                                  var fav = Favorite(name: _music!.name, album: _music!.album,date: date);
                                  addFavorite(fav);
                                  setState(() {
                                    isFavourite = true;
                                  });
                                  print("FAVORITE: " + fav.name);

                                }),
                            crossFadeState: isFavourite
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 700)),
                        IconButton(
                            icon: Icon(
                              Icons.skip_previous,
                              size: 40,
                              color: Colors.white70,
                            ),
                            onPressed: () async {
                              await Spotifire.skipPrevious;
                            }),
                        AnimatedCrossFade(
                            firstChild: IconButton(
                                icon: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                onPressed: () async {
                                  await Spotifire.resumeMusic.whenComplete(() {
                                    setState(() {
                                      ispaused = false;
                                    });
                                  });
                                }),
                            secondChild: IconButton(
                                icon: Icon(Icons.pause,
                                    size: 40, color: Colors.white),
                                onPressed: () async {
                                  await Spotifire.pauseMusic.whenComplete(() {
                                    setState(() {
                                      ispaused = true;
                                    });
                                  });
                                }),
                            crossFadeState: ispaused
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 700)),
                        IconButton(
                            icon: Icon(Icons.skip_next,
                                size: 40, color: Colors.white70),
                            onPressed: () async {
                              await Spotifire.skipNext;
                            }),
                      ],
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(
              Icons.playlist_play,
              size: 35,
            ),
            onPressed: () async {
              //print("AAAAAAA");
              await Spotifire.getAccessToken.then(print);

              await Spotifire.connectRemote
                  .then(print)
                  .whenComplete(() => print("compl"));
              try {
                if (await Spotifire.isRemoteConnected)
                  await Spotifire.playPlaylist(
                      playlistUri: widget.barcode!.code.toString());
              } catch (e) {
                print(e);
              }
            }),
      ),
    );
  }

  double _getValue(int milliseconds) {
    double percentage = (milliseconds / totaldurationinmilli) * 100;

    print(percentage.toString() + " % ");

    double tpo = (percentage / 100) * 1.0;
    return tpo;
  }

  @override
  void dispose() {
    Spotifire.close();

    super.dispose();
  }
}