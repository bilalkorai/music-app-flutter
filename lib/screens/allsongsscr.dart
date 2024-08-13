import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:musicapp/screens/nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class allsongs extends StatefulWidget {
  const allsongs({super.key});

  @override
  State<allsongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<allsongs> {
  String songName = "";
  List<SongModel>? songs;
  int? currentIndex;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    requestPermission();
    audioPlayer = AudioPlayer(); // Initialize the AudioPlayer
  }

  void requestPermission() {
    Permission.storage.request();
    Permission.camera.request();
  }

  final _audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: "JamBox",
            style: TextStyle(color: Colors.blueAccent, fontSize: 25, fontWeight: FontWeight.bold),
            children: [TextSpan(text: " Player", style: TextStyle(color: Colors.pink))],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return Center(child: Text("No Songs Found"));
          }
          songs = snapshot.data; // Save songs list
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].displayNameWOExt),
                subtitle: Text("${snapshot.data![index].artist}"),
                trailing: Icon(Icons.more_horiz),
                leading: Icon(Icons.music_note),
                onTap: () {
                  setState(() {
                    songName = snapshot.data![index].displayNameWOExt;
                    currentIndex = index;
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => nowplaying(
                        songs: songs!,
                        initialIndex: currentIndex!,
                        audioPlayer: audioPlayer, // Pass the existing AudioPlayer
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
          child: BottomAppBar(
            color: Colors.pinkAccent,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Marquee(
                        text : songName.isNotEmpty ? songName : "No song selected",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                        scrollAxis: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        blankSpace: 10.0,
                        velocity: 30.0,
                        startPadding: 10.0,
                        accelerationDuration: Duration(seconds: 1),
                        decelerationDuration: Duration(seconds: 1),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  IconButton(
                    onPressed: () {
                      if (songs != null && currentIndex != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => nowplaying(
                              songs: songs!,
                              initialIndex: currentIndex!,
                              audioPlayer: audioPlayer, // Pass the existing AudioPlayer
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.arrow_forward_ios_sharp, color: Colors.blue.shade900, size: 30),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
