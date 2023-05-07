import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;
  final List searchHistory;
  final List recommendations;
  // final CollectionReference browse;
  // final CollectionReference ratings;

  const User({
    required this.username,
    required this.uid,
    required this.photoUrl,
    required this.email,
    required this.bio,
    required this.followers,
    required this.following,
    required this.searchHistory,
    // required this.browse,
    // required this.ratings,
    required this.recommendations,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    final browse = snap.reference.collection('browse');
    final ratings = snap.reference.collection('ratings');
    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
      searchHistory: snapshot['searchHistory'],
      // browse: browse,
      // ratings: ratings,
      recommendations: snapshot['recommendations'],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
        "searchHistory": searchHistory,
        "recommendation": recommendations,
      };
}
