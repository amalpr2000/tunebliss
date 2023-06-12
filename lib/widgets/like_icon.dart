import 'package:flutter/material.dart';
import 'package:tune_bliss/screens/home/home_screen.dart';
import 'package:tune_bliss/screens/library/most_played.dart';
import 'package:tune_bliss/screens/library/recent_played.dart';
import 'package:tune_bliss/screens/playlist/current_playlist.dart';

import '../database/functions/liked_db_function.dart';
import '../model/song_model.dart';
import '../screens/liked/liked_screen.dart';

class LikedButton extends StatefulWidget {
  LikedButton({super.key, required this.isfav, required this.currentSongs,this.fromplayscreen=false});
  bool fromplayscreen;
  Songs currentSongs;
  bool isfav;

  @override
  State<LikedButton> createState() => _LikedButtonState();
}

class _LikedButtonState extends State<LikedButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          setState(() {
            if (widget.isfav) {
              widget.isfav = false;

              removeFromLiked(widget.currentSongs);
              snack(context, message: 'Removed from Liked', color: Colors.red);
            } else {
              widget.isfav = true;
              addToLiked(widget.currentSongs);
              snack(context,
                  message: 'Added to Liked', color: Color(0xFF4CAF50));
            }
            likedSongsNotifier.notifyListeners();
          });
          if(widget.fromplayscreen){
            likedSongsNotifier.notifyListeners();
            recentSongs.notifyListeners();
            home.notifyListeners();
            currentPlaylistBodyNotifier.notifyListeners();
            mostPlayedList.notifyListeners();
          }
        },
        icon: widget.isfav
            ? Icon(
                Icons.favorite_rounded,
                color: Colors.white,
              )
            : Icon(
                Icons.favorite_outline_rounded,
                color: Color(0xFF9DA8CD),
              ));
  }
}
