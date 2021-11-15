import 'package:deezer_music_clone/global.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:spotify/spotify.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


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

class Index extends StatefulWidget {
  const Index({Key? key}) : super(key: key);

  @override
  I_ndexState createState() => I_ndexState();
}

class I_ndexState extends State<Index> {
  var _playlist = getPlaylist();
  var _rnbPlaylists = getRnBPlaylists();

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
                  ?FutureBuilder<Playlist>(
                    future: _playlist,
                    builder: (BuildContext context, AsyncSnapshot<Playlist> snapshot){
                    List<Widget> children = [];
                    if(snapshot.hasData){
                    children = [Center(
                        child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              isThreeLine: false,
                              leading: Icon(
                                Ionicons.play,
                                size: 35,
                              ),
                              title: Text("${snapshot.data?.tracks?.itemsNative?.first['track']['name']}"),
                              subtitle: Text("${snapshot.data?.tracks?.itemsNative?.first['track']['artists'][0]["name"]}"),
                            ),
                          ),
                          Icon(Ionicons.heart_outline),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Ionicons.information_circle_outline),
                          SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    )];
                    }else{
                        children = const <Widget>[
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
                        ];
                      }
                    return  Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: children,
                      ),
                    );
                    })
                  : FutureBuilder<Playlist>(
                      future: _playlist,
                      builder: (BuildContext context, AsyncSnapshot<Playlist> snapshot){
                        List<Widget> children = [];
                        if (snapshot.hasData){
                          var namePlaylist = snapshot.data?.name;
                          var autor = snapshot.data?.owner?.displayName;
                          var image = snapshot.data?.images?.first.url;
                          print( "${snapshot.data?.tracks?.itemsNative?.first['track']['album']['images'][0]['url']}");
                          children = [Container(
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
                                        Text( namePlaylist.toString(),
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 14)),
                                        Text(
                                          //playlist?.owner.displayName.toString(),
                                          autor.toString(),
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
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                    image: DecorationImage(
                                      image: NetworkImage("${snapshot.data?.tracks?.itemsNative?.first['track']['album']['images'][0]['url']}"),//AssetImage("images/eminem.jpeg"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  margin: const EdgeInsets.only(
                                      left: 60, right: 60, top: 30, bottom: 15),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Ionicons.share_social_outline,
                                      size: 30,
                                      color: Colors.white,
                                    ),

                                    Icon(
                                      Ionicons.ellipsis_vertical_circle_outline,
                                      size: 55,
                                      color: Colors.white,
                                    ),

                                    Icon(
                                      Ionicons.heart_outline,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "1.30",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        "3.21",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 15, right: 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        height: 4,
                                        width: 100,
                                      ),
                                      const CircleAvatar(
                                        radius: 5,
                                        backgroundColor: Colors.white,
                                      ),
                                      Expanded(
                                        child: Container(
                                          color: const Color(0xB9A5A5A5),
                                          height: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 22),
                                  child: Column(
                                    children: [
                                      Text(
                                        "${snapshot.data?.tracks?.itemsNative?.first['track']['name']}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 25),
                                      ),

                                      Text(
                                        "${snapshot.data?.tracks?.itemsNative?.first['track']['artists'][0]["name"]}",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Ionicons.play_skip_back_outline,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Icon(
                                      Ionicons.play,
                                      size: 55,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Icon(
                                      Ionicons.play_skip_forward_outline,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),];
                        }else{
                          children = const <Widget>[
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
                          ];
                        }
                        return  Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: children,
                          ),
                        );


                      }),
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
                "Your friends",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Container(
              height: 150,
              // color: Colors.black,
              child:
                  ListView(scrollDirection: Axis.horizontal, children: const [
                SizedBox(
                  width: 12,
                ),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.red,
                  backgroundImage: AssetImage("images/billie.jpeg"),
                ),
                SizedBox(
                  width: 12,
                ),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.greenAccent,
                  backgroundImage: AssetImage("images/eminem.jpeg"),
                ),
                SizedBox(
                  width: 12,
                ),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.indigoAccent,
                  backgroundImage: AssetImage("images/drake.jpg"),
                ),
                SizedBox(
                  width: 12,
                ),
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.amber,
                  backgroundImage: AssetImage("images/sixnine.jpg"),
                ),
              ]),
            ),

            Container(
              margin: const EdgeInsets.only(top: 15, left: 20),
              child: const Text(
                "Top Playlists of the Month",
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
                  if(snapshot.hasData){
                    List<Container> lista = [];
                    for(var p in snapshot.data!['playlists']['items']){
                      print("AQUIIIIII-> "+ p['images'].toString());
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
                                    data : p['external_urls']['spotify'],
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 20),
                  child: const Text(
                    "Your favorite artists",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Container(
                    height: 150,
                    // color: Colors.black,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: map.length,
                        itemBuilder: (context, i) {
                          return Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                              image: DecorationImage(
                                image: AssetImage("${map[i]['img']}"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            margin:
                            const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                          );
                        })),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 20),
                  child: const Text(
                    "All categorie",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                            image: AssetImage(map[0]['img']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          map[0]['title'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        margin: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                            image: AssetImage(map[1]['img']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          map[1]['title'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        margin: const EdgeInsets.only(right: 10, top: 30, bottom: 15),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                            image: AssetImage(map[2]['img']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          map[2]['title'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        margin: const EdgeInsets.only(left: 20, top: 30, bottom: 15),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          image: DecorationImage(
                            image: AssetImage(map[3]['img']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Text(
                          map[3]['title'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        margin: const EdgeInsets.only(right: 10, top: 30, bottom: 15),
                      ),
                    )
                  ],
                ),

                Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFB6AFAF),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  margin: const EdgeInsets.only(top: 15, left: 100),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: const Text(
                    "View More",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
          )
          ],
        ),
      ),
    );
  }
}
