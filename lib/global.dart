import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:spotify_sdk/spotify_sdk.dart';



var selectedIndex = 3;
var panelOpen = false;
var appBarTxt = "MusicBuddies";
String client_id = "1820d0285c9247e5ae4dbc7912bd585b";
String client_secret = "3145ca9038f4450f89ab55dd7a8ebc08";
String scopes = "user-read-private user-read-email";
String auth_url = "https://accounts.spotify.com/api/token";
String spotifyUrl = "https://api.spotify.com";
var access_token = "";
var authenticationToken = "";

void authenticate() async {
  int REQUEST_CODE = 1337;
  String REDIRECT_URI = "com.example.musicBuddies://callback";
  //var result = await SpotifySdk.connectToSpotifyRemote(clientId: client_id, redirectUrl: "spotify-sdk://auth");
  authenticationToken = await SpotifySdk.getAuthenticationToken(clientId: client_id, redirectUrl: "spotify-sdk://auth", scope: "app-remote-control,user-modify-playback-state,playlist-read-private,user-library-read,user-read-private,user-read-email");
  print("ENTAO ---->"+authenticationToken);
  print("OIIIAAA");
  // Present the dialog to the user
  // "https://accounts.spotify.com/authorize?client_id=1820d0285c9247e5ae4dbc7912bd585b&response_type=token&redirect_uri=spotify-sdk%3A%2F%2Fauth&show_dialog=false&utm_source=spotify-sdk&utm_medium=android-sdk&utm_campaign=android-sdk&scope=user-read-private%20user-read-email ",
  // final result = await FlutterWebAuth.authenticate(
  //   url:
  //   "https://accounts.spotify.com/authorize?client_id="+client_id+"&redirect_uri=spotify-sdk://auth&show_dialog=false&utm_source=spotify-sdk&scope=user-read-private%20user-read-email&response_type=token",
  //
  //   callbackUrlScheme: "com.example.first_app/callback/",
  // );
// Extract token from resulting url
//   final token = Uri.parse(result);
//   String at = token.fragment;
//   at = "http://website/index.html?$at"; // Just for easy persing
//   var accesstoken = Uri.parse(at).queryParameters['access_token'];
//   print('token');
//   print(accesstoken);
}

void getToken() async{
  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };
  var request = http.Request('POST', Uri.parse('https://accounts.spotify.com/api/token'));
  request.bodyFields = {
    'grant_type': 'client_credentials',
    'client_id': '1820d0285c9247e5ae4dbc7912bd585b',
    'client_secret': '3145ca9038f4450f89ab55dd7a8ebc08',
  };
  request.headers.addAll(headers);

  var response = await request.send();

  if (response.statusCode == 200) {
    var res = await response.stream.bytesToString();
    print(res);
    var json = convert.jsonDecode(res) as Map<String,dynamic>;
    access_token = json['access_token'].toString();
    print(access_token);
  }
  else {
    print(response.reasonPhrase);
  }


}

var credentials = SpotifyApiCredentials("1820d0285c9247e5ae4dbc7912bd585b", "3145ca9038f4450f89ab55dd7a8ebc08");
var spotify = SpotifyApi(credentials);

Future<Playlist> getPlaylist({String id = "6W6G0AjXgZfiJ5R2W9NEru"}) async{
  print('Artists:');
  var playlist = await spotify.playlists.get(id);
  var name = playlist.owner?.id;
  //if(playlist.owner != null) name = ;
  print(playlist.name.toString() + " by "+ name.toString());
  return playlist;
}

Future<Map<String,dynamic>> getUsersPlaylists() async{
  var headers = {
    'Authorization': 'Bearer '+authenticationToken
  };
  var request = http.Request('GET', Uri.parse('https://api.spotify.com/v1/me/playlists'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print("AHHHHHHHHHHHHHHHHH");
  if (response.statusCode == 200) {
    var res = await response.stream.bytesToString();
    print(res);
    var json = convert.jsonDecode(res) as Map<String,dynamic>;
    print(json['items'][0]['name'] + json['items'][0]['images'][0]['url']);
    return json;
  }
  else {
    print(response.reasonPhrase);
    return {"a":'t'};
  }

}

Future<String> userPhoto() async{
  var headers = {
    'Authorization': 'Bearer '+authenticationToken
  };
  var request = http.Request('GET', Uri.parse('https://api.spotify.com/v1/me'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  print("USER PHOTOOO: " + response.statusCode.toString());
  if (response.statusCode == 200) {
    var res = await response.stream.bytesToString();
    //print("SASA->"+res);
    print("FOTO DE PERFIL: ");
    var json = convert.jsonDecode(res) as Map<String,dynamic>;
    var url = json['images'][0]['url'];
    //print(json['playlists']['items'][4]['name'] + json['playlists']['items'][0]['images'][0]['url']);
    return url;
  }
  else {
    print(response.reasonPhrase);
    return "";
  }
}

Future<Map<String,dynamic>> getRnBPlaylists() async{
  var headers = {
    'Authorization': 'Bearer '+access_token
  };
  var request = http.Request('GET', Uri.parse('https://api.spotify.com/v1/browse/categories/rnb/playlists?limit=5'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var res = await response.stream.bytesToString();
    //print("SASA->"+res);
    var json = convert.jsonDecode(res) as Map<String,dynamic>;
    //print(json['playlists']['items'][4]['name'] + json['playlists']['items'][0]['images'][0]['url']);
    return json;
  }
  else {
    print(response.reasonPhrase);
    return {"a":'t'};
  }
}

Future<Map<String,dynamic>> getSavedAlbums() async{
  var headers = {
    'Authorization': 'Bearer '+authenticationToken
  };
  var request = http.Request('GET', Uri.parse('https://api.spotify.com/v1/me/albums?limit=15'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var res = await response.stream.bytesToString();
    //print("SASA->"+res);
    var json = convert.jsonDecode(res) as Map<String,dynamic>;
    print("ALBUMS");
    print(json['items']);
    //print(json['playlists']['items'][4]['name'] + json['playlists']['items'][0]['images'][0]['url']);
    return json;
  }
  else {
    print(response.reasonPhrase);
    return {"a":'t'};
  }
}

