class Users {
  final int? userid;
  final String username;
  final String? userEmail;
  final String userPassword;

  Users({
       this.userid,
       required this.username,
       this.userEmail,
      required this.userPassword,
  });
  factory Users.fromMap(Map<String, dynamic> json) {
    return Users(
      userid: json['userid'],
      username: json['username'] ,
      userEmail: json['userEmail'] ,
      userPassword: json['userPassword'] ,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'userid': userid,
      'username': username,
      'userEmail': userEmail,
      'userPassword': userPassword,
    };
  }
}
