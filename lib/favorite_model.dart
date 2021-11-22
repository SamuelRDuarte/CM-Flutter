import 'package:hive/hive.dart';
import 'package:spotify_auth_player/spotify_auth_player.dart';
part 'favorite_model.g.dart';

@HiveType(typeId: 0)
class Favorite {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String album;

  @HiveField(2)
  final DateTime date;

  Favorite({required this.name, required this.album,required this.date});
}