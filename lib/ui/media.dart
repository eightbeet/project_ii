import 'package:flutter/material.dart';
import 'dart:math';

class MediaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Media> mediaData = fetchMediaData();

    List<Media> musicData = mediaData.where((item) => item.mediaType == "music").toList();
    List<Media> imageData = mediaData.where((item) => item.mediaType == "image").toList();

    return SingleChildScrollView(
          child: Column(children: [
            buildTitleContainer(context),

            buildSectionTitle('Music'),
            buildMediaSection(musicData, context),

            buildSectionTitle('Images'),
            buildMediaSection(imageData, context),

          ],),
      );
  }

  Widget buildTitleContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
      alignment: Alignment.centerLeft,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Text(
        'Media',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255, 
      random.nextInt(256), 
      random.nextInt(256), 
      random.nextInt(256), 
    );
  }
  
  Color getFadedColor(Color color, {double opacity = 0.3}) {
    return color.withOpacity(opacity);
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
  
          Color color1 = getRandomColor();
          Color color2 = getFadedColor(color1, opacity: 0.3); 
          Color color3 = getRandomColor();
  
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
                          colors: [color1, color2, color3],
                          stops: [0.0, 0.5, 1.0],
                        ),
                        // image: DecorationImage(
                        //   image: NetworkImage(media.imagUrl),
                        //   fit: BoxFit.cover,
                        // ),
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
        content: Text('$action: ${media.name}'),
        duration: Duration(seconds: 2),
      ),
    );
      // [TODO:] [Actions]: 
  }
}
 
class Media {
  final String name;
  final String author;
  final String authorAvatarUrl;
  final String description;
  final String imageUrl;
  final String mediaType;
  final bool isUnlocked;

  Media({
    required this.name,
    required this.author,
    required this.authorAvatarUrl,
    required this.description,
    required this.imageUrl,
    required this.mediaType,
    required this.isUnlocked,
  });
}

List<Media> fetchMediaData() {
  return [

    Media(
      name: "Song 1",
      author: "Artist 7",
      authorAvatarUrl: "URL",
      description: "A great song to listen to!",
      imageUrl: "",
      mediaType: "music",
      isUnlocked: true,
    ),

    Media(
      name: "Song 1",
      author: "Artist 7",
      authorAvatarUrl: "URL",
      description: "A great song to listen to!",
      imageUrl: "",
      mediaType: "music",
      isUnlocked: true,
    ),

    Media(
      name: "Image 1",
      author: "Photographer 1",
      authorAvatarUrl: "URL",
      description: "A beautiful image captured during the golden hour.",
      imageUrl: "",
      mediaType: "image",
      isUnlocked: true,
    ),

    Media(
      name: "Image 1",
      author: "Photographer 1",
      authorAvatarUrl: "URL",
      description: "A beautiful image captured during the golden hour.",
      imageUrl: "",
      mediaType: "image",
      isUnlocked: true,
    ),
  ];
}

