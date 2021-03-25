class PostModel {
  PostModel({
    this.authorUid,
    this.authorProfilePhotoUrl,
    this.authorUsername,
    this.dateCreated,
    this.postText,
    this.contentType,
    this.contentUrl,
    this.reactionAverage,
    this.reactionColor,
    this.reactionCount,
    this.userReactionAmount,
    this.userSelectedColor,
    this.commentCount,
  });

  final authorUid;
  final authorUsername;
  final authorProfilePhotoUrl;
  final dateCreated;
  final postText;
  final contentType;
  final contentUrl;
  String reactionColor;
  int reactionCount;
  String userSelectedColor;
  double reactionAverage;
  double userReactionAmount;
  int commentCount;
}
