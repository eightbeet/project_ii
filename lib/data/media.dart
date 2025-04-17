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

      final media1 = Media(
      title: "Fractal",
      author: "Eightbeet",
      authorAvatarUrl: "https://drive.google.com/uc?export=view&id=1F4ZndgmKtjWCN3KkwpioVs_TUL4hQjg2",
      description: "Super cool piece of fractal Art",
      mediaUrl: "https://drive.google.com/uc?export=view&id=1G_6r4nMAf_CnPGKzAIbIvDWQR-wg6Dah", 
      mediaType: "art",
      isUnlocked: true,
      minXp: 10
      );

      final media2 = Media(
      title: "Cool Song",
      author: "reidenshi",
      authorAvatarUrl: "https://drive.google.com/uc?export=view&id=1zr2-AlRxQD8kZnRDcQrePOO-KZxIRGtc",
      description: "Soothing ambient music",
      mediaUrl: "https://drive.google.com/uc?export=view&id=1bcsU-OjpcKgeyNf4BUIXPGG-X2geyt78", 
      mediaType: "audio",
      isUnlocked: true,
      minXp: 10
      );     

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

      // updateMedia(media2);
      // insertMedia(media2);
      // deleteMedia(2);
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

   void deleteMedia(int? id) async {
    Database db = await AppDB().database;
    final err = await db.delete('media_data', where:'id = ?', whereArgs: [id]);
    // handle errors
   }

   Future<void> updateMedia(Media media) async {
      Database db = await AppDB().database;
      final isUnlocked =  media.isUnlocked == true ? 1 : 0;
      final err = await db.update('media_data',
            {'media_type': media.mediaType,'title': media.title,
            'avatar_url': media.authorAvatarUrl, 'author': media.author,
            'description': media.description, 'media_url': media.mediaUrl, 
            'is_unlocked': isUnlocked, 'min_xp': media.minXp }
            , where: 'title = ?', whereArgs: [media.title]);
      // handle errors
   }

   void init() async {
     final List<Media> mediaData = [
            
         Media(
            title: "Fractal",
            author: "Eightbeet",
            authorAvatarUrl: "https://drive.google.com/uc?export=view&id=1F4ZndgmKtjWCN3KkwpioVs_TUL4hQjg2",
            description: "Super cool piece of fractal Art",
            mediaUrl: "https://drive.google.com/uc?export=view&id=1G_6r4nMAf_CnPGKzAIbIvDWQR-wg6Dah", 
            mediaType: "art",
            isUnlocked: true,
            minXp: 10
         ),
         Media(
            title: "Cool Song",
            author: "reidenshi",
            authorAvatarUrl: "https://drive.google.com/uc?export=view&id=1F4ZndgmKtjWCN3KkwpioVs_TUL4hQjg2",
            description: "Soothing ambient music",
            mediaUrl: "https://drive.google.com/uc?export=view&id=1bcsU-OjpcKgeyNf4BUIXPGG-X2geyt78", 
            mediaType: "audio",
            isUnlocked: true,
            minXp: 10
         ),
    ];

    for(var item in mediaData) {
      insertMedia(item);
    }

  // final data =  _fetchAllMediaData();
  // print(data);
 }
}

