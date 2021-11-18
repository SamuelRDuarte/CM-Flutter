import 'package:deezer_music_clone/global.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Search1 extends StatefulWidget {
  const Search1({Key? key}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search1> {
  @override
  Widget build(BuildContext context) {
    authenticate();
    return
          Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new NetworkImage("https://logosmarcas.net/wp-content/uploads/2020/09/Spotify-Logo.png"),
                  )
              )
    );
  }
}
