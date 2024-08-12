import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
class nowplaying extends StatefulWidget {
  const nowplaying({super.key, required this.songs, required this.initialIndex, required this.audioPlayer});
  final List<SongModel> songs;
  final int initialIndex;
  final AudioPlayer audioPlayer;
  @override
  State<nowplaying> createState() => _nowplayingState();
}

class _nowplayingState extends State<nowplaying> {


  late int _currentIndex;
  bool isplaying =false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = widget.initialIndex;
    playsong();
  }

  playsong(){
    final song = widget.songs[_currentIndex];
    widget.audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
    widget.audioPlayer.play();
    setState(() {
      isplaying = true;
    });
  }

  void _playNextSong() {

      _currentIndex = (_currentIndex + 1) % widget.songs.length;
      playsong();

  }

  void _playPreviousSong() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + widget.songs.length) % widget.songs.length;
      playsong();
    });
  }



  @override
  Widget build(BuildContext context) {
    final song = widget.songs[_currentIndex];
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new)),
              SizedBox(height: 10,),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isplaying ? CircleAvatar(radius: 100, child: Lottie.asset("assets/animations/12.json")) : CircleAvatar(radius: 100, child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image.asset("assets/images/13.png"),
                    )
                    ),
                    SizedBox(height: 30,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(song.displayNameWOExt, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.fade,)),
                    SizedBox(height: 30,),
                    Center(child: Text(song.artistId.toString(), style: TextStyle(fontSize: 15, color: Colors.grey),maxLines: 1,)),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("0.0"),
                        Expanded(child: Slider(value: 0.0, onChanged: (value){})),
                        Text("0.0")
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: IconButton(onPressed: (){
                          _playPreviousSong();
                        },icon: Icon(Icons.skip_previous,size: 40,))),
                        SizedBox(width: 10,),
                        Expanded(
                            child: IconButton(onPressed: (){setState(() {
                              if(isplaying){
                                widget.audioPlayer.pause();
                              }else{
                                widget.audioPlayer.play();
                              }
                              isplaying = !isplaying;

                            });},icon: Icon( isplaying ?  Icons.pause : Icons.play_arrow, size: 40,),)
                        ),
                        SizedBox(width: 10,),
                        Expanded(child: IconButton(onPressed: (){
                          _playNextSong();
                        },icon: Icon(Icons.skip_next,size: 40,)))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
