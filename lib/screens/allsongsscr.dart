import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/main.dart';
import 'package:musicapp/screens/nowplaying.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
class allsongs extends StatefulWidget {
  const allsongs({super.key});

  @override
  State<allsongs> createState() => _allsongsState();
}

class _allsongsState extends State<allsongs> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestpermission();
  }


  void requestpermission(){
    Permission.storage.request();
    Permission.camera.request();
  }

  final _audioquery = new OnAudioQuery();
  final _audioPlayer = new AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(text: TextSpan(text: "JamBox",style: TextStyle(color: Colors.blueAccent,fontSize: 25, fontWeight: FontWeight.bold),children: [TextSpan(text: " Player",style: TextStyle(color: Colors.pink))]),),
        actions: [
          IconButton(onPressed: (){

          }, icon: Icon(Icons.search))
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioquery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true
        ),
        builder: (context,snapshot){
          if(snapshot.data == null){
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.data!.isEmpty){
            return Center(child: Text("No Songs Found"),);
          }
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context , index){
                return ListTile(
                  title: Text(snapshot.data![index].displayNameWOExt),
                  subtitle: Text("${snapshot.data![index].artist}"),
                  trailing: Icon(Icons.more_horiz),
                  leading: Icon(Icons.music_note,),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> nowplaying(songs: snapshot.data!,initialIndex: index,audioPlayer: _audioPlayer,)));
                  },
                );
              }
          );
        },
      )
    );
  }
}
