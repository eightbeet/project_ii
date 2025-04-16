 import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'db.dart';


class Media {
  final String title;
  final String author;
  final String authorAvatarUrl;
  final String description;
  final String mediaUrl;
  final String mediaType;
  final bool isUnlocked;
  final int minXp;

  Media({
    required this.title,
    required this.author,
    required this.authorAvatarUrl,
    required this.description,
    required this.mediaUrl,
    required this.mediaType,
    required this.isUnlocked,
    required this.minXp,
  });
}


class AppMediaDBHelper {

   Future<List<Media>> fetchMediaData() async {
      List<Media> mediaData = [];
      final data = await _fetchAllMediaData();

      for(var item in data) {
         final {
            'media_type':mediaType,'title': title,
            'avatar_url': avatarUrl, 'author': author,
            'description': description, 'media_url': mediaUrl, 
            'is_unlocked': isUnlocked, 'min_xp': minXp } = item;

          final media = Media(
            title: title ,
            author: author,
            authorAvatarUrl: avatarUrl,
            description: description,
            mediaUrl: mediaUrl,
            mediaType: mediaType,
            isUnlocked: isUnlocked == 1 ? true : false,  
            minXp: minXp
          ); 
          mediaData.add(media);
      }
      return mediaData;
   }

   Future<List<Map<String, dynamic>>> _fetchAllMediaData() async {
      Database db = await AppDB().database;
      final data = await db.rawQuery('SELECT * FROM media_data');
      print(data);
      return data;
   }

   Future<void> insertMedia(Media media) async {
      Database db = await AppDB().database;
      final err = await db.insert('media_data',
            {'media_type': media.mediaType,'title': media.title,
            'avatar_url': media.authorAvatarUrl, 'author': media.author,
            'description': media.description, 'media_url': media.mediaUrl, 
            'is_unlocked': media.isUnlocked, 'min_xp': media.minXp });
      // handle errors
   }

   void init() async {
      final List<Media> mediaData = [

      Media(
      title: "Fractal",
      author: "Artist 7",
      authorAvatarUrl: "https://drive.google.com/file/d/1F4ZndgmKtjWCN3KkwpioVs_TUL4hQjg2/view?usp=drive_link",
      description: "Super cool piece of Art",
      mediaUrl: "https://drive.google.com/file/d/1G_6r4nMAf_CnPGKzAIbIvDWQR-wg6Dah/view?usp=drive_link",
      mediaType: "art",
      isUnlocked: false,
      minXp: 10
      ),

    // Media(
    //   name: "Song 1",
    //   author: "Artist 7",
    //   authorAvatarUrl: "URL",
    //   description: "A great song to listen to!",
    //   imageUrl: "",
    //   mediaType: "music",
    //   isUnlocked: true,
    // ),

    // Media(
    //   name: "Image 1",
    //   author: "Photographer 1",
    //   authorAvatarUrl: "URL",
    //   description: "A beautiful image captured during the golden hour.",
    //   imageUrl: "",
    //   mediaType: "image",
    //   isUnlocked: true,
    // ),

    // Media(
    //   name: "Image 1",
    //   author: "Photographer 1",
    //   authorAvatarUrl: "URL",
    //   description: "A beautiful image captured during the golden hour.",
    //   imageUrl: "",
    //   mediaType: "image",
    //   isUnlocked: false,
    // ),

    // Media(
    //   name: "Image 1",
    //   author: "Photographer 1",
    //   authorAvatarUrl: "URL",
    //   description: "A beautiful image captured during the golden hour.",
    //   imageUrl: "",
    //   mediaType: "image",
    //   isUnlocked: true,
    // )
  ];

  for(var item in mediaData) {
      insertMedia(item);
  }

  // final data =  _fetchAllMediaData();
  // print(data);
 }
}

