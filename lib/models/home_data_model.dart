class HomeModel {
  final bool status;
  late HomeDataModel data;

  HomeModel({required this.status, required this.data});

  factory HomeModel.fromJson(json) {
    return HomeModel(
      status: json['status'],
      data: HomeDataModel.fromJson(json['data']),
    );
  }
}

class HomeDataModel {
  late List<BannerModel> banners = [];
  late List<ProductModel> products = [];

  HomeDataModel({required this.banners, required this.products});

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      banners: (json['banners'] as List)
          .map((element) => BannerModel.fromJson(element))
          .cast<BannerModel>()
          .toList(),
      products: (json['products'] as List)
          .map((element) => ProductModel.fromJson(element))
          .cast<ProductModel>()
          .toList(),
    );
  }
}

class BannerModel {
  final int id;
  final String image;

  BannerModel({required this.id, required this.image});

  factory BannerModel.fromJson(json) {
    return BannerModel(
      id: json['id'],
      image: json['image'],
    );
  }
}

class ProductModel {
  final int id;
  final String image;
  final String name;
  final dynamic price;
  final dynamic oldPrice;
  final dynamic discount;
  bool inFavorites;
  bool inCart;

  ProductModel({
    required this.discount,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.inFavorites,
    required this.inCart,
    required this.id,
    required this.image,
  });

  factory ProductModel.fromJson(json) {
    return ProductModel(
      name: json['name'],
      id: json['id'],
      image: json['image'],
      price: json['price'],
      oldPrice: json['old_price'],
      inFavorites: json['in_favorites'],
      inCart: json['in_cart'],
      discount: json['discount'],
    );
  }
}
