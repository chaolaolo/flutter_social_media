import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_social_media/features/post/domain/entities/comment.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timestamp;
  final List<String> likes; //store uids
  final List<Comment> comments;

  // final int likeCount = 0;
  // final int commentCount = 0;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timestamp,
    required this.likes,
    required this.comments,
  });

  Post copyWith({String? imageUrl}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      timestamp: timestamp,
      likes: likes,
      comments: comments,
    );
  }

  //convert post to json
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "userName": userName,
      "text": text,
      "imageUrl": imageUrl,
      "timestamp": Timestamp.fromDate(timestamp),
      "likes": likes,
      "comments": comments.map((comment) => comment.toJson()).toList(),
    };
  }

  //convert json to post
  factory Post.fromJson(Map<String, dynamic> json) {
    // prepare comment
    final List<Comment> comments = (json["comments"] as List<dynamic>?)?.map((commentJson) => Comment.fromJson(commentJson)).toList() ?? [];

    return Post(
      id: json["id"],
      userId: json["userId"],
      userName: json["userName"],
      text: json["text"],
      imageUrl: json["imageUrl"],
      timestamp: (json["timestamp"] as Timestamp).toDate(),
      likes: List<String>.from(json["likes"] ?? []),
      comments: comments,
    );
  }
}
