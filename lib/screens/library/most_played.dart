import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tune_bliss/model/song_model.dart';
import 'package:tune_bliss/screens/liked/liked_screen.dart';
import 'package:tune_bliss/screens/playlist/add_to_playlist.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/like_icon.dart';
import '../bottom_nav.dart';
import '../home/miniplayer.dart';

ValueNotifier<List<Songs>> mostPlayedList = ValueNotifier([]);

class MostPlayed extends StatelessWidget {
  const MostPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: displayHeight,
        width: displayWidth,
        decoration: BoxDecoration(gradient: bodyGradient),
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.only(
              right: displayWidth * .05,
              left: displayWidth * .05,
              top: displayWidth * .06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarRow(title: 'Most Played'),
              Container(
                color: Colors.transparent,
                height: displayHeight * 0.0155,
              ),
              (mostPlayedList.value.isEmpty)
                  ? Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 250,
                          ),
                          Text(
                            'No Songs Found',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    )
                  : ValueListenableBuilder(
                      valueListenable: mostPlayedList,
                      builder: (context, value, child) => Expanded(
                          child: Material(
                        color: Colors.black.withOpacity(0),
                        child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  playerMini.stop();
                                  playingAudio(mostPlayedList.value, index);
                                  showBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) => Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: const MiniPlayer(),
                                    ),
                                  );
                                },
                                textColor: Colors.white,
                                iconColor: Colors.white,
                                tileColor: Color(0xFF20225D),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                leading: QueryArtworkWidget(
                                  artworkHeight: 60,
                                  artworkWidth: 60,
                                  size: 3000,
                                  quality: 100,
                                  artworkQuality: FilterQuality.high,
                                  artworkBorder: BorderRadius.circular(12),
                                  artworkFit: BoxFit.cover,
                                  id: mostPlayedList.value[index].id!,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/images/albumCover.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  mostPlayedList.value[index].songname!,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis),
                                ),
                                subtitle: Text(
                                  mostPlayedList.value[index].artist!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF9DA8CD),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LikedButton(
                                        isfav: likedSongsNotifier.value
                                            .contains(
                                                mostPlayedList.value[index]),
                                        currentSongs:
                                            mostPlayedList.value[index]),
                                    PopupMenuButton(
                                      icon: Icon(
                                        Icons.more_vert_rounded,
                                        color: Color(0xFF9DA8CD),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      color: Color(0xFF07014F),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Icon(Icons.playlist_add),
                                                Text(
                                                  'Add to Playlist',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ))
                                      ],
                                      onSelected: (value) =>
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                        builder: (context) => AddToPlaylist(
                                            song: mostPlayedList.value[index]),
                                      )),
                                    )
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, likedSongIndex) =>
                                SizedBox(
                                  height: displayHeight * 0.013,
                                ),
                            itemCount: mostPlayedList.value.length),
                      )),
                    )
            ],
          ),
        )),
      ),
    );
  }
}
