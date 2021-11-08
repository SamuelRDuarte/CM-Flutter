import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

var selectedIndex = 3;
var panelOpen = false;
var appBarTxt = "MusicBuddies";

var credentials = SpotifyApiCredentials("1820d0285c9247e5ae4dbc7912bd585b", "3145ca9038f4450f89ab55dd7a8ebc08");
var spotify = SpotifyApi(credentials);

Future<Playlist> getPlaylist({String id = "6W6G0AjXgZfiJ5R2W9NEru"}) async{
  print('Artists:');
  var playlist = await spotify.playlists.get(id);
  var name = playlist.owner?.displayName;
  //if(playlist.owner != null) name = ;
  print(playlist.name.toString() + " by "+ name.toString());
  return playlist;
}

List map = [
  {
    "title" : "podcast chart",
    "img" : "images/eminem.jpeg",
  },
  {
    "title" : "New's & Politic",
    "img" : "images/billie.jpeg",
  },
  {
    "title" : "Raps",
    "img" : "images/sixnine.jpg",
  },
  {
    "title" : "Raps & hip hop",
    "img" : "images/drake.jpg",
  },
];
