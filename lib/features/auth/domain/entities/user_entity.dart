class UserEntity {
  final String id;
  final String email;
  final String username;
  final String? token;
  // final String? avatar;
  // final String? displayname;
  
  UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.token = ''
    // this.displayname,
    // this.avatar,
  });
}
