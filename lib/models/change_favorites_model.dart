class ChangeFavoritesModel {
  final bool status;
  final String message;

  ChangeFavoritesModel({required this.status, required this.message});

  factory ChangeFavoritesModel.fromJson(json) {
    return ChangeFavoritesModel(
      status: json['status'],
      message: json['message'],
    );
  }
}
