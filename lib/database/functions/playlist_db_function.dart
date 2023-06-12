import 'package:hive_flutter/hive_flutter.dart';
import 'package:tune_bliss/screens/playlist/current_playlist.dart';
import '../../model/song_model.dart';
import '../../screens/playlist/playlist_screen.dart';
import '../model/playlist_model/playlist_model.dart';

Future playlistcreating(String name) async {
  playlist.add(EachPlaylist(playlistName: name));
  Box<PlaylistModal> playlistDB = await Hive.openBox('playlist');
  playlistDB.add(PlaylistModal(playlistName: name));
  print(playlistDB.values);
  playlistDB.close();
}

Future playlistAddDB(Songs addingSong, String playlistName) async {
  Box<PlaylistModal> playlistdb = await Hive.openBox('playlist');

  for (PlaylistModal element in playlistdb.values) {
    if (element.playlistName == playlistName) {
      var key = element.key;
      PlaylistModal updatePlaylist = PlaylistModal(playlistName: playlistName);
      updatePlaylist.playlistSongID.addAll(element.playlistSongID);
      updatePlaylist.playlistSongID.add(addingSong.id!);
      playlistdb.put(key, updatePlaylist);
      break;
    }
  }

  currentPlaylistBodyNotifier.notifyListeners();

  playlistdb.close();
}

Future playlistRemoveDB(Songs removingSong, String playlistName) async {
  Box<PlaylistModal> playlistdb = await Hive.openBox('playlist');
  for (PlaylistModal element in playlistdb.values) {
    if (element.playlistName == playlistName) {
      var key = element.key;
      PlaylistModal ubdatePlaylist = PlaylistModal(playlistName: playlistName);
      for (int item in element.playlistSongID) {
        if (item == removingSong.id) {
          continue;
        }
        ubdatePlaylist.playlistSongID.add(item);
      }
      playlistdb.put(key, ubdatePlaylist);
      break;
    }
  }
}

Future playlistRename(
    {required String oldName, required String newName}) async {
  for (int i = 0; i < playlist.length; i++) {
    if (playlist[i].playlistName == oldName) {
      playlist[i].playlistName = newName;
      break;
    }
  }
  Box<PlaylistModal> playlistDB = await Hive.openBox('playlist');
  var key;
  for (PlaylistModal element in playlistDB.values) {
    if (element.playlistName == oldName) {
      key = element.key;
      break;
    }
  }
  playlistDB.put(key, PlaylistModal(playlistName: newName));
  playlistDB.close();
}

Future playlistDelete(int index) async {
  String name = playlist[index].playlistName;
  playlist.removeAt(index);
  Box<PlaylistModal> playlistDB = await Hive.openBox('playlist');
  for (PlaylistModal element in playlistDB.values) {
    if (element.playlistName == name) {
      var key = element.key;
      playlistDB.delete(key);
      break;
    }
  }
}
