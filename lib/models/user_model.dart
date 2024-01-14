class UserAuthModel {
  final bool status;
  final String? message;
  late final UserData? data;

  factory UserAuthModel.fromJson(json) {
    return UserAuthModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? UserData.fromJson(
              json['data'],
            )
          : null,
    );
  }

  UserAuthModel({
    required this.status,
    required this.message,
    this.data,
  });
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? points;
  int? credit;
  String? token;

  factory UserData.fromJson(json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      points: json['points'],
      credit: json['credit'],
      token: json['token'],
    );
  }

  UserData(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.image,
      required this.points,
      required this.credit,
      required this.token});
}
