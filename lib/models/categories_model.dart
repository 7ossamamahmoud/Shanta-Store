class CategoriesModel {
  final bool status;
  final CategoriesHomeDataModel data;

  CategoriesModel({required this.status, required this.data});

  factory CategoriesModel.fromJson(json) {
    return CategoriesModel(
      status: json['status'],
      data: CategoriesHomeDataModel.fromJson(
        json['data'],
      ),
    );
  }
}

class CategoriesHomeDataModel {
  final int currentPage;
  final List<CategoryDataModel> data;

  CategoriesHomeDataModel({
    required this.currentPage,
    required this.data,
  });

  factory CategoriesHomeDataModel.fromJson(json) {
    return CategoriesHomeDataModel(
        currentPage: json['current_page'],
        data: (json['data'] as List)
            .map((e) => CategoryDataModel.fromJson(e))
            .cast<CategoryDataModel>()
            .toList());
  }
}

class CategoryDataModel {
  final int id;
  final String name;
  final String image;

  CategoryDataModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CategoryDataModel.fromJson(json) {
    return CategoryDataModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
