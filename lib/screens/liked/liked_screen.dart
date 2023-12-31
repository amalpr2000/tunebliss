import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:tune_bliss/screens/home/miniplayer.dart';

import '../../functions/fetch_songs.dart';
import '../../model/song_model.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/like_icon.dart';

import '../playlist/add_to_playlist.dart';

class Liked extends StatefulWidget {
  Liked({
    super.key,
    required this.displayWidth,
  });

  final double displayWidth;

  @override
  State<Liked> createState() => _LikedState();
}

ValueNotifier<List<Songs>> likedSongsNotifier = ValueNotifier([]);

class _LikedState extends State<Liked> {
  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    double displayHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppBarRow(
              title: ' Liked Songs',
            ),
            Container(
              color: Colors.transparent,
              height: displayHeight * 0.011,
            ),
            ValueListenableBuilder(
              valueListenable: likedSongsNotifier,
              builder: (context, value, child) {
                if (currentlyplaying != null) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    showBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => const MiniPlayer(),
                    );
                  });
                }
                return (likedSongsNotifier.value.isEmpty)
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                            ),
                            Text(
                              'Add songs to liked',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Material(
                        color: Colors.black.withOpacity(0),
                        child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  int idx = 0;
                                  for (idx = 0; idx < allsongs.length; idx++) {
                                    if (likedSongsNotifier.value[index].id ==
                                        allsongs[idx].id) {
                                      break;
                                    }
                                  }
                                  playingAudio(allsongs, idx);
                                  setState(() {});
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
                                  id: likedSongsNotifier.value[index].id!,
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
                                  likedSongsNotifier.value[index].songname!,
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis),
                                ),
                                subtitle: Text(
                                  likedSongsNotifier.value[index].artist!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Color(0xFF9DA8CD)),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    LikedButton(
                                        isfav: true,
                                        currentSongs:
                                            likedSongsNotifier.value[index]),
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
                                            song: likedSongsNotifier
                                                .value[index]),
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
                            itemCount: likedSongsNotifier.value.length),
                      ));
              },
            )
          ],
        ));
  }
}

void snack(BuildContext context,
    {required String message, required Color color}) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
      content: Text(message),
      backgroundColor: color,
      elevation: 6,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(horizontal: 21),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
}
