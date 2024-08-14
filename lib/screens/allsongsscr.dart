import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:musicapp/screens/nowplaying.dart'; // Ensure this import is correct
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class allsongs extends StatefulWidget {
  final VoidCallback onThemeChanged2;

  const allsongs({super.key, required this.onThemeChanged2});

  @override
  State<allsongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<allsongs> {
  bool isdark = false;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  List<SongModel>? songs;
  List<SongModel> filteredSongs = [];
  int? currentIndex;
  late AudioPlayer audioPlayer;
  String songName = "";

  @override
  void initState() {
    super.initState();
    requestPermission();
    audioPlayer = AudioPlayer(); // Initialize the AudioPlayer
    searchController.addListener(filterSongs);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterSongs() {
    final query = searchController.text.toLowerCase();
    print('Search Query: $query'); // Debug print
    setState(() {
      if (songs != null) {
        filteredSongs = songs!.where((song) {
          final name = song.displayNameWOExt.toLowerCase();
          final result = name.contains(query);
          print('Song: $name, Contains Query: $result'); // Debug print
          return result;
        }).toList();
      }
    });
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
        title: isSearching
            ? TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        )
            : RichText(
          text: TextSpan(
            text: "JamBox",
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: " Player",
                style: TextStyle(color: Colors.pink),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  filterSongs(); // Reset the filtered list when search is closed
                }
              });
            },
            icon: Icon(isSearching ? Icons.close : Icons.search),
          ),
          IconButton(onPressed: (){
            setState(() {
              widget.onThemeChanged2();
              isdark = !isdark;
            });
          }, icon: Icon(isdark ? Icons.light_mode : Icons.dark_mode))
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("No Songs Found"));
          }

          // Update songs and filteredSongs when data is available
          if (songs == null) {
            songs = snapshot.data;
            filteredSongs = songs!;
          }

          return ListView.builder(
            itemCount: filteredSongs.length,
            itemBuilder: (context, index) {
              final song = filteredSongs[index];
              return ListTile(
                title: Text(song.displayNameWOExt),
                subtitle: Text(song.artist ?? "Unknown Artist"),
                trailing: Icon(Icons.more_horiz),
                leading: Icon(Icons.music_note),
                onTap: () {
                  setState(() {
                    songName = filteredSongs[index].displayNameWOExt; // Update songName
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
                        text: songName.isNotEmpty ? songName : "No song selected",
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
