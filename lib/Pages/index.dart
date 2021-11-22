import 'package:deezer_music_clone/global.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotify_auth_player/spotify_auth_player.dart';


var credentials = SpotifyApiCredentials("1820d0285c9247e5ae4dbc7912bd585b", "3145ca9038f4450f89ab55dd7a8ebc08");
var spotify = SpotifyApi(credentials);

Future<Playlist> teste() async{
  print('Artists:');
  var playlist = await spotify.playlists.get("6W6G0AjXgZfiJ5R2W9NEru");
  var name = playlist.owner?.displayName;
  //if(playlist.owner != null) name = ;
  print(playlist.name.toString() + " by "+ name.toString());
  return playlist;
}

void getConnection() async {
  //print("AAAAAAA");
  await Spotifire.init(clientid: client_id);
  await Spotifire.getAccessToken.then(print);

  await Spotifire.connectRemote.then(print).whenComplete(() => print("compl"));
  try {
    if (await Spotifire.isRemoteConnected) {
      await Spotifire.playPlaylist(playlistUri: "");
      await Spotifire.pauseMusic;
    }
  } catch (e) {
    print(e);
  }
}


class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  I_ndexState createState() => I_ndexState();
}

class I_ndexState extends State<Index> {
  var _playlist = teste();
  var _rnbPlaylists = getRnBPlaylists();
  var _userPlaylists = getUsersPlaylists();
  var _savedAlbums = getSavedAlbums();
  Music? _music;
  int totaldurationinmilli = 0;
  bool ispaused = true;



  @override
  void initState() {
    super.initState();
    getConnection();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    print("INIT PLATFORM STATE");

    //Spotifire.positonStream.listen(print);
    if (!mounted) return;

    Spotifire.musicStream.listen((music) {
      //print(music.runtimeType);

      if (mounted) {

        setState(() {
          totaldurationinmilli = music.duration.inMilliseconds;
          print(music.duration);
          _music = music;
        });
      }
    }).onError((error) {
      print(error);
    });
  }

  double val = 0.01;

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

  @override
  Widget build(BuildContext context) {
    var hei = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;
    final controller = TextEditingController();
    return SlidingUpPanel(
      onPanelOpened: () {
        setState(() {
          panelOpen = true;
        });
      },
      onPanelClosed: () {
        setState(() {
          panelOpen = false;
        });
      },
      onPanelSlide: (val) {
        print("$val");
      },
      panel: Center(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.indigoAccent],
            ),
          ),
          width: wid,
          height: 700,
          child: Column(
            children: [
              panelOpen == false
                 ?Center(
                        child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              isThreeLine: false,
                              leading: Icon(
                                Ionicons.play,
                                size: 35,
                              ),
                              title: Text(_music != null ? _music!.name : "Loading ... "),
                              subtitle: Text(_music != null ? _music!.artists.first.name + (_music!.artists.length > 1 ? " feat. " +_music!.artists.sublist(1).map((e) => e.name).join(","): "") : "Loading ... "),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                    margin: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            const Icon(
                              Ionicons.chevron_down_outline,
                              size: 30,
                              color: Colors.white,
                            ),

                            Center(
                              child: Column(
                              children: [
                                //if (_music != null)
                                Text(_music != null ? _music!.name : "Loading ... ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14)),
                                Text(_music != null ? _music!.album : "Loading ... ",
                                  //autor.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),)
                          ],
                        ),
                        Container(
                          height: 200,
                          width: wid,
                          // decoration: BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius:
                          //   BorderRadius.all(Radius.circular(8)),
                          //   image: DecorationImage(
                          //     image:  AssetImage("images/eminem.jpeg"),//NetworkImage(),
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          child: Material(
                              elevation: 7.0,
                              child: Image.memory(_music!.musicImage)),
                          margin: const EdgeInsets.only(
                              left: 60, right: 60, top: 30, bottom: 25),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 300.0),
                          child: Text(
                            _music != null
                                ? _music!.duration.toString().split(".")[0]
                                : "Loading ... ",
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                        StreamBuilder<Duration>(
                            stream: Spotifire.positonStream,
                            // initialData: Duration.zero,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return Slider.adaptive(
                                  value: 0.0,
                                  onChanged: (d) {},
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(
                                Ionicons.play_skip_back_outline,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                await Spotifire.skipPrevious;
                              },
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            AnimatedCrossFade(
                                firstChild: IconButton(
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onPressed: () async {
                                      await Spotifire.resumeMusic.whenComplete(() {
                                        //initPlatformState();
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
                            SizedBox(
                              width: 30,
                            ),
                            IconButton(
                                icon: Icon(
                                  Ionicons.play_skip_forward_outline,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                    await Spotifire.skipNext;
                                  }),
                            // FloatingActionButton(
                            //     child: Icon(
                            //       Icons.playlist_play,
                            //       size: 35,
                            //     ),
                            //     onPressed: () async {
                            //       //print("AAAAAAA");
                            //       await Spotifire.getAccessToken.then(print);
                            //
                            //       await Spotifire.connectRemote
                            //           .then(print)
                            //           .whenComplete(() => print("compl"));
                            //       try {
                            //         if (await Spotifire.isRemoteConnected)
                            //           await Spotifire.playPlaylist(
                            //               playlistUri: Spotifire.getSpotifyUri("spotify:album:37i9dQZEVXbKyJS56d1pgi"));
                            //       } catch (e) {
                            //         print(e);
                            //       }
                            //     }),
                          ],
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 15, left: 20),
              child: const Text(
                "Saved Albums",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
              height: 260,

              // color: Colors.black,
              child: FutureBuilder<Map<String,dynamic>>(
                future: _savedAlbums,
                builder: (BuildContext context, AsyncSnapshot<Map<String,dynamic>> snapshot){
                  var children;
                  if(snapshot.hasData && (snapshot.data!.keys.first != "a")){
                    List<Container> lista = [];
                    for(var p in snapshot.data!['items']){
                      //print("AQUIIIIII-> "+ p['images'].toString());
                      Container cont = Container(
                        child: Column( children: [

                          InkWell(
                            child: Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(p['album']['images'][0]['url']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              margin: const EdgeInsets.only(
                                  left: 20, top: 30, bottom: 10),
                            ),
                            onTap: () {
                              child: showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                      child: QrImage(
                                        data : p['album']['uri'],
                                        backgroundColor: Colors.white,
                                      )
                                  )
                              );
                            },
                          ),
                          Container(
                            // color: Colors.red,
                              width: 180,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 24),
                              child:  Text(p['album']['name']))
                        ],
                        ),
                      );
                      lista.add(cont);
                    }
                    children = ListView(scrollDirection: Axis.horizontal, children: lista,);
                  }else{
                    children = Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  const <Widget>[
                          SizedBox(height: 50,),
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 30,
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting data...'),
                          )
                        ],
                      ),
                    );
                  }
                  return  children;
                },
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 15, left: 20),
              child: const Text(
                "Top R&B Playlists of the Month",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
              height: 260,
              // color: Colors.black,
              child: FutureBuilder<Map<String,dynamic>>(
                future: _rnbPlaylists,
                builder: (BuildContext context, AsyncSnapshot<Map<String,dynamic>> snapshot){
                  var children;
                  if(snapshot.hasData && (snapshot.data!.keys.first != "a")){
                    List<Container> lista = [];
                    for(var p in snapshot.data!['playlists']['items']){
                      //print("AQUIIIIII-> "+ p['images'].toString());
                      Container cont = Container(
                        child: Column( children: [

                          InkWell(
                            child: Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(p['images'][0]['url']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              margin: const EdgeInsets.only(
                                  left: 20, top: 30, bottom: 10),
                            ),
                            onTap: () {
                              child: showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  child: QrImage(
                                    data : p['uri'],
                                    backgroundColor: Colors.white,
                                  )
                                )
                              );
                            },
                          ),
                          Container(
                            // color: Colors.red,
                              width: 180,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 24),
                              child:  Text(p['name']))
                        ],
                        ),
                      );
                      lista.add(cont);
                    }
                    children = ListView(scrollDirection: Axis.horizontal, children: lista,);
                  }else{
                    children = Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  const <Widget>[
                          SizedBox(height: 50,),
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 30,
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting data...'),
                          )
                        ],
                      ),
                    );
                  }
                  return  children;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, left: 20),
              child: const Text(
                "User Playlists",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
              height: 260,
              // color: Colors.black,
              child: FutureBuilder<Map<String,dynamic>>(
                future: _userPlaylists,
                builder: (BuildContext context, AsyncSnapshot<Map<String,dynamic>> snapshot){
                  var children;
                  if(snapshot.hasData && (snapshot.data!.keys.first != "a")){
                    List<Container> lista = [];
                    for(var p in snapshot.data!['items']){
                      //print("AQUIIIIII-> "+ p['images'].toString());
                      Container cont = Container(
                        child: Column( children: [

                          InkWell(
                            child: Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(p['images'][0]['url']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              margin: const EdgeInsets.only(
                                  left: 20, top: 30, bottom: 10),
                            ),
                            onTap: () {
                              child: showDialog(
                                  context: context,
                                  builder: (BuildContext context) => Dialog(
                                      child: QrImage(
                                        data : p['uri'],
                                        backgroundColor: Colors.white,
                                      )
                                  )
                              );
                            },
                          ),
                          Container(
                            // color: Colors.red,
                              width: 180,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 24),
                              child:  Text(p['name']))
                        ],
                        ),
                      );
                      lista.add(cont);
                    }
                    children = ListView(scrollDirection: Axis.horizontal, children: lista,);
                  }else{
                    children = Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:  const <Widget>[
                          SizedBox(height: 50,),
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 30,
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting data...'),
                          )
                        ],
                      ),
                    );
                  }
                  return  children;
                },
              ),
            ),
              Container(
                  color: Colors.white,
                  height: 300.0,// This is optional

              )
              ],
            ),
          )
        );
  }
}
