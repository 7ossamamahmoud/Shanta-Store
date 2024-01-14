class CategoryProductsModel {
  bool? status;
  Null message;
  DataModel? data;

  CategoryProductsModel({this.status, this.message, this.data});

  CategoryProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataModel.fromJson(json['data']) : null;
  }
}

class DataModel {
  List<CatProdData>? data;

  DataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <CatProdData>[];
      json['data'].forEach((v) {
        data!.add(CatProdData.fromJson(v));
      });
    }
  }
}

class CatProdData {
  dynamic id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  String? description;
  List<String>? images;
  bool? inFavorites;
  bool? inCart;

  CatProdData(
      {this.id,
      this.price,
      this.oldPrice,
      this.discount,
      this.image,
      this.name,
      this.description,
      this.images,
      this.inFavorites,
      this.inCart});

  CatProdData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'].cast<String>();
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}
