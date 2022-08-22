class FireUser {
  final String username;
  final String avatarPath;

  const FireUser({
    required this.username,
    required this.avatarPath,
  });

  FireUser.fromJson(Map<String, Object?> json)
      : this(
          username: json['username']! as String,
          avatarPath: json['avatarPath']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'username': username,
      'avatarPath': avatarPath,
    };
  }
}
