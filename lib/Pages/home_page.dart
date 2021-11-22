import 'dart:ui';

import 'package:deezer_music_clone/Pages/scan.dart';
import 'package:deezer_music_clone/Pages/index.dart';
import 'package:deezer_music_clone/Pages/map.dart';
import 'package:deezer_music_clone/Pages/favorites.dart';
import 'package:deezer_music_clone/global.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();


}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var hei = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;
    var _url = userPhoto();
    var placeholder = "https://storage.jewheart.com/content/users/avatars/3746/avatar_3746_500.jpg?1558628223";
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
        elevation: 0,
        title: Container(
            // color: Colors.red,
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                FutureBuilder<String>(
                    future: _url,
                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.data! == "" || !snapshot.hasData) {
                        return CircleAvatar(
                            backgroundImage: NetworkImage(placeholder)
                        );
                      } else {
                        return CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data!),
                        );
                      }
                    }),
                Row(children: selectedIndex == 0 ? const [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "MusicBuddies",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 33),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ]
                    : selectedIndex == 1
                        ? const [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Map",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 33),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ]
                        : selectedIndex == 3
                            ? const [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Favorites",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 33),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ]
                            : const [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Dates",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 33),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ]),
          ]
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false, // <-- HERE
          showUnselectedLabels: false, // <-- AND HERE
          elevation: 18,
          items: [
            BottomNavigationBarItem(
              icon: selectedIndex == 0
                  ? IconButton(
                      icon: const Icon(
                        Ionicons.musical_notes_outline,
                        color: Colors.red,
                        size: 27,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIndex = 0;
                          print("$selectedIndex");
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(
                        Ionicons.musical_notes,
                        color: Colors.black,
                        size: 27,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIndex = 0;
                          print("$selectedIndex");
                        });
                      },
                    ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                icon: selectedIndex == 1
                    ? const Icon(
                        Ionicons.map_outline,
                        color: Colors.red,
                        size: 27,
                      )
                    : const Icon(
                        Ionicons.map_outline,
                        color: Colors.black,
                        size: 27,
                      ),
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                    print("$selectedIndex");
                  });
                },
              ),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: selectedIndex == 2
                  ? IconButton(
                      icon: const Icon(
                        Ionicons.qr_code,
                        color: Colors.red,
                        size: 27,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIndex = 2;
                          print("$selectedIndex");
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(
                        Ionicons.qr_code,
                        color: Colors.black,
                        size: 27,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIndex = 2;
                          print("$selectedIndex");
                        });
                      },
                    ),
              label: "Movie",
            ),
            BottomNavigationBarItem(
              icon: selectedIndex == 3
                  ? IconButton(
                      icon: const Icon(
                        Icons.audiotrack,
                        color: Colors.red,
                        size: 27,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIndex = 3;
                          print("$selectedIndex");
                        });
                      },
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.audiotrack,
                        color: Colors.black,
                        size: 27,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIndex = 3;
                          print("$selectedIndex");
                        });
                      },
                    ),
              label: "Shop",
            ),
          ]),
      body: selectedIndex == 0
          ? const Index()
          : selectedIndex == 1
              ? const Map()
              : selectedIndex == 2
                  ? const Scan()
                  : const Search1(),

    );

  }
}
