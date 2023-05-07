import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final likes;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  // Following we have, the priceTag, Title
  final double priceTag;
  final String title;
  final bool sold;
  final String category;

  // final Bool purchaseOrNot;
  // final photoUrlGroup;

  const Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.likes,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    //Following
    required this.priceTag,
    required this.title,
    required this.sold,
    required this.category,

    // required this.purchaseOrNot,
    // required this.photoUrlGroup,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        likes: snapshot["likes"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        username: snapshot["username"],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        //Following
        priceTag: snapshot['priceTag'],
        title: snapshot['title'],
        sold: snapshot['sold'],
        category: snapshot['category']
        // purchaseOrNot: snapshot['purchaseOrNot'],
        // photoUrlGroup: snapshot['photoUrlGroup'],
        );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "likes": likes,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        'postUrl': postUrl,
        'profImage': profImage,
        //Following
        'priceTag': priceTag,
        'title': title,
        'sold': sold,
        'category': category,
        // 'purchaseOrNot': purchaseOrNot,
        // 'photoUrlGroup': photoUrlGroup,
      };
}
