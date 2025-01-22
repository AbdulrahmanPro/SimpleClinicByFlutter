class UserModel {
  final int id;
  final int personId;
  final String name;
  final String userName;
  final String password;

  const UserModel( 
      {required this.id,
      required this.personId,
      required this.name,
      required this.userName,
      required this.password,});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        personId: json['personId'],
        name: json['name'],
        userName: json['userName'],
        password: json['password'],
      );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'personId': personId,
      'name': name,
      'userName': userName,
      'password': password,
    };
  }
}
