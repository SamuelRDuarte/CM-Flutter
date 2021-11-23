import 'package:musicBuddies/global.dart';
import 'package:flutter/material.dart';
import 'package:musicBuddies/Pages/home_page.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';

import '../favorite_model.dart';

class Search1 extends StatefulWidget {
  const Search1({Key? key}) : super(key: key);


  @override
  SearchState createState() => SearchState();
}



Future<List<Favorite>> getFavorite() async {
  var box = await Hive.openBox<Favorite>('favorites');
  return box.values.toList();
}

void deleteFavorite(int index) async {
  var box = await Hive.openBox<Favorite>('favorites');
  box.deleteAt(index);

}


class SearchState extends State<Search1> {
  var _favs ;//= getFavorite();
  final GlobalKey<SearchState> key = GlobalKey<SearchState>();

  @override
  Widget build(BuildContext context) {

    int count=0;
    print("FAVS: " + _favs.toString());
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FutureBuilder<List<Favorite>>(
        future: _favs = getFavorite(),
        builder: (BuildContext context, AsyncSnapshot<List<Favorite>> snapshot){
          var children;
          for(var f in snapshot.data!) print("FAVS: " + snapshot.data!.length.toString());
          if(snapshot.hasData){
            children = DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Name',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Album',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Date',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    '',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: <DataRow>[
                for(var f in snapshot.data!)
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text(f.name)),
                      DataCell(Text(f.album)),
                      DataCell(Text(f.date.day.toString() + "/" + f.date.month
                          .toString() + "/" + f.date.year.toString())),
                      DataCell(
                        IconButton(
                            icon: Icon(
                              Icons.delete,
                              size: 40,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              deleteFavorite(snapshot.data!.indexOf(f)); //deleteFavorite
                               setState(() {

                               });//refresh
                            }),
                      ),
                    ],
                  ),
              ],
            );
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

          return children;
        },
    ),
    );
  }
}
