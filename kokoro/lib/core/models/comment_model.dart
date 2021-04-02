class CommentModel {
  CommentModel({
    this.commentText,
    this.authorProfilePhotoUrl,
    this.username,
    this.authorUid,
    this.postAuthorUid,
    this.postUid,
  });
  final username;
  final authorUid;
  final postUid;
  final postAuthorUid;
  final authorProfilePhotoUrl;
  final commentText;
}
