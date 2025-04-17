import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../data/media.dart';

class MediaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Media> mediaData = [];

    List<Media> artData = []; //;mediaData.where((item) => item.mediaType == "music").toList();
    List<Media> audioData = []; //mediaData.where((item) => item.mediaType == "image").toList();

    // return SingleChildScrollView(
    return FutureBuilder<List<Media>>(
      future: AppMediaDBHelper().fetchMediaData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No data available'));
        }

        mediaData = snapshot.data!;
      
        artData = mediaData.where((item) => item.mediaType == "art").toList();
        audioData = mediaData.where((item) => item.mediaType == "audio").toList();

        return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: [
               buildTitleContainer(context),
               
               buildSectionTitle('Art'),
               buildMediaSection(artData, context),
               
               buildSectionTitle('Audio'),
               buildMediaSection(audioData, context),
          ],),
       );
      }
    );
  }

  Widget buildTitleContainer(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Media',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  void handleMediaOnClick(Media media, BuildContext context) {
     if(media.isUnlocked == true) {
      Widget _media = ImagePage(media: media);
      switch(media.mediaType){
         case 'art': _media = ImagePage(media: media);
         case 'audio': _media = AudioPage(media: media);
      }
      Navigator.of(context).push(
       MaterialPageRoute(
         builder: (BuildContext context) => _media, 
       )
    );
   }
  }

  List<Color> getGradientColors(String mediaType, BuildContext context) {
     final colorScheme = Theme.of(context).colorScheme;
     if(mediaType == "art") {
        return [
            colorScheme.primary,
            colorScheme.surface.withValues(alpha: 0.3),
            colorScheme.secondaryFixed,
        ];
     }
     if(mediaType == "audio") {
         return [
            colorScheme.secondary,
            colorScheme.surface.withValues(alpha: 0.3),
            colorScheme.primaryFixed,
        ];
     }
     return [
            colorScheme.error,
            colorScheme.surface.withValues(alpha: 0.3),
            colorScheme.surfaceDim,
        ];;
  }

  Widget buildMediaSection(List<Media> mediaList, BuildContext context) {
    return Column(  children: [Container(
      height: 250,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mediaList.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {

          Media media = mediaList[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 300,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: getGradientColors(media.mediaType, context),
                          stops: [0.0, 0.5, 1.0],
                        ),
                      ),
                     child: InkWell(
                        onTap: (){ handleMediaOnClick(media, context); },
                      ),
                    ),
                    //lock icon or overlay for when media is locked
                    if (!media.isUnlocked)
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Icon(
                          Icons.lock,
                          size: 20,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
  
              Container( 
                 padding: EdgeInsets.symmetric(horizontal: 10),
                 child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(media.authorAvatarUrl),
                      ),

                      SizedBox(width: 8),
  
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            media.author,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 40, maxWidth: 200),
                            child: Text(
                              media.description,
                              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                        
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
     ),
        Divider(height: 50, indent: 20, endIndent: 20),
     ],
    );
  }
   
  // [FUTURE]:
  void _handleMediaButtonPress(Media media, BuildContext context) {
    String action = media.mediaType == 'music' ? 'Downloading music' : 'Opening image';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action: ${media.title}'),
        duration: Duration(seconds: 2),
      ),
    );
      // [TODO:] [Actions]: 
  }
}



class ImagePage extends StatelessWidget {
  Media media;
  
  ImagePage({required this.media});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Viewer"),
        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Center(
              child: Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              alignment: Alignment.center,
              width: double.infinity,
              height: 300,
              child:  InteractiveViewer(
                  minScale: 0.1,
                  maxScale: 1.6, 
                  child: Container(
                    child: Image.network(media.mediaUrl),
                   ), 
                  ),
                 
                ), 
              ),
            ),
        ],
      ),
    );
  }
}

class AudioPage extends StatefulWidget {
   Media media; 
   AudioPage({super.key, required this.media});

   @override 
   _AudioPageState createState() => _AudioPageState(media: media);
}

class _AudioPageState extends State<AudioPage>{
  Media media;
  final player = AudioPlayer();
  bool isPlaying = false; 
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

   _AudioPageState({required this.media});
   
  @override 
  void initState() {
     super.initState();

     player.onPlayerStateChanged.listen((state) {
        setState((){
         isPlaying = state == PlayerState.playing;
         });
     });

     player.onDurationChanged.listen((newDuration) {
       setState((){
         duration = newDuration;
         });
     });

     player.onPositionChanged.listen((newPosition) {
       setState((){
         position = newPosition;
         });
     });
  }

  String formatAudioTime(Duration duration) {
     String twoDigitTime(int time) => time.toString().padLeft(2, '0');
     final hours = twoDigitTime(duration.inHours);
     final minutes = twoDigitTime(duration.inMinutes.remainder(60));
     final seconds = twoDigitTime(duration.inSeconds.remainder(60));
     return [if(duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  
  @override
  Widget build(BuildContext context) {
   final authorNameStyle = TextStyle(color: Theme.of(context).colorScheme.surfaceDim, fontWeight: FontWeight.w300);
   final authorTitleStyle = TextStyle(color: Theme.of(context).colorScheme.surfaceDim.withValues(alpha: 0.8), fontWeight: FontWeight.bold);
   final progressTextStyle = TextStyle(color: Theme.of(context).colorScheme.surfaceDim.withValues(alpha: 0.8));
   

    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Player"),
        backgroundColor: Theme.of(context).colorScheme.surfaceDim,
      ),
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ],
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Center(
              child: Container(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              alignment: Alignment.center,
              width: double.infinity,
              height: 350,
              child:  Column(
                  children: [
                    SizedBox(height: 10),
                     InteractiveViewer(
                     minScale: 0.1,
                     maxScale: 1.6, 
                     child: Container(
                       child: ClipRRect(
                       borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                         media.authorAvatarUrl,
                           height: 150,
                         fit: BoxFit.fill,
                        ),
                       ),
                      ), 
                    ), 
                    SizedBox(height: 10),
                    
                    Text("Music by", style: authorTitleStyle),
                    Text("${media.author}", style: authorNameStyle),
                    SizedBox(height: 10),

                    Slider(
                     min: 0,
                     max: duration.inSeconds.toDouble(),
                     value: position.inSeconds.toDouble(),
                     activeColor: Theme.of(context).colorScheme.primaryContainer,
                     thumbColor: Theme.of(context).colorScheme.primaryContainer,
                     onChanged: (value) async {
                        final position = Duration(seconds: value.toInt());
                        await player.seek(position);
                        await player.resume();
                     },
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                              Text(formatAudioTime(position), style: progressTextStyle ),
                              Text(formatAudioTime(duration - position), style: progressTextStyle),
                           ],
                        ),
                    ),

                    CircleAvatar(
                      radius: 20,
                      child: IconButton(
                         icon: Icon( isPlaying ? Icons.pause : Icons.play_arrow),
                         onPressed: () async {
                         if (isPlaying) {
                            await player.pause();
                         } else {
                            await player.play(UrlSource(media.mediaUrl));
                         }
                       },
                    ),
                  ),
                ]  
                ), 
                ), 
              ),
            ),
        ],
      ),
    );
  }
}
