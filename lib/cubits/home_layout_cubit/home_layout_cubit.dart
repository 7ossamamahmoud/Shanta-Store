import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salla/models/categories_model.dart';
import 'package:salla/models/change_favorites_model.dart';
import 'package:salla/models/get_favorites_model.dart';
import 'package:salla/models/home_data_model.dart';
import 'package:salla/models/user_model.dart';
import 'package:salla/screens/categories_screen.dart';
import 'package:salla/screens/favorites_screen.dart';
import 'package:salla/screens/products_screen.dart';
import 'package:salla/screens/settings_screen.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

import '../../models/category_products_model.dart';
import '../../models/change_password_model.dart';
import '../../models/update_user_model.dart';

part 'home_layout_state.dart';

class HomeLayoutCubit extends Cubit<HomeLayoutStates> {
  HomeLayoutCubit() : super(HomeLayoutInitialState());

  static HomeLayoutCubit get(context) => BlocProvider.of(context);
  List<Widget> bottomNavScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SettingsScreen()
  ];
  int currentIndex = 0;

  changeBottomNav(int index) {
    currentIndex = index;
    emit(HomeLayoutChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  fetchHomeData() {
    emit(HomeDataLoadingState());
    DioHelper.getData(
      url: HOME,
      token: kToken,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });
      fetchFavorites();
      fetchUserData();
      emit(HomeDataSuccessfulState());
    }).catchError((e) {
      print(e.toString());
      emit(HomeDataErrorState(error: e.toString()));
    });
  }

  CategoryProductsModel? categoryProductsModel;

  fetchCategoryProducts(int productId) {
    emit(HomeGetCategoryProductsLoadingState());
    DioHelper.getData(
      url: "$CATEGORY_PRODUCTS$productId",
      token: kToken,
    ).then((value) {
      categoryProductsModel = CategoryProductsModel.fromJson(value.data);
      homeModel!.data.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });
      fetchFavorites();
      emit(HomeGetCategoryProductsSuccessfulState());
    }).catchError((e) {
      print("Category Products Error is : $e");
      emit(HomeGetCategoryProductsErrorState(error: e.toString()));
    });
  }

  CategoriesModel? categoriesModel;

  fetchCategories() {
    DioHelper.getData(url: GET_CATEGORIES).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(HomeCategoriesSuccessfulState());
    }).catchError((e) {
      print(e.toString());
      emit(HomeCategoriesErrorState(error: e.toString()));
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  changeFavorites(int productID) {
    favorites[productID] = !favorites[productID]!;
    emit(HomeChangeFavoritesLoadingState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productID,
      },
      token: kToken,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(
        value.data,
      );
      if (!changeFavoritesModel!.status) {
        favorites[productID] = !favorites[productID]!;
      } else {
        fetchFavorites();
      }
      print('Change Favorites Data: ${value.data}');
      emit(
        HomeChangeFavoritesSuccessfulState(
          changeFavoritesModel: changeFavoritesModel!,
        ),
      );
    }).catchError((error) {
      print(error.toString());
      favorites[productID] = !favorites[productID]!;
      emit(HomeChangeFavoritesErrorState(error: error.toString()));
    });
  }

  GetFavoritesModel? getFavoritesModel;

  fetchFavorites() {
    DioHelper.getData(
      url: FAVORITES,
      token: kToken,
    ).then((value) {
      getFavoritesModel = GetFavoritesModel.fromJson(value.data);
      emit(
        HomeGetFavoritesSuccessfulState(),
      );
    }).catchError((error) {
      print(error.toString());
      emit(
        HomeGetFavoritesErrorState(
          error: error.toString(),
        ),
      );
    });
  }

  UserAuthModel? userData;
  UpdateUserInfoModel? userInfoModel;

  fetchUserData() {
    emit(HomeGetUserDataLoadingState());
    DioHelper.getData(
      url: PROFILE,
      token: kToken,
    ).then((value) {
      userData = UserAuthModel.fromJson(value.data);
      print(userData!.data!.image);
      emit(
        HomeGetUserDataSuccessfulState(),
      );
    }).catchError((error) {
      print("Get user data error: $error");
      emit(
        HomeGetUserDataErrorState(
          error: error.toString(),
        ),
      );
    });
  }

  updateUserData({
    String? name,
    String? image,
    String? phone,
    String? email,
  }) {
    emit(HomeUpdateUserDataLoadingState());
    DioHelper.putData(url: UPDATE_PROFILE, token: kToken, data: {
      'name': name,
      'image': image,
      'phone': phone,
      'email': email,
    }).then((value) {
      userInfoModel = UpdateUserInfoModel.fromJson(value.data);
      if (userInfoModel!.status!) {
        print("Updated Name is : ${userInfoModel!.data!.name}");
        userData!.data!.image = userInfoModel!.data!.image;
        fetchUserData(); // This might be redundant, but keeping it for consistency
        emit(
          HomeUpdateUserDataSuccessfulState(userInfoModel: userInfoModel!),
        );
      } else {
        emit(
          HomeUpdateUserDataErrorState(
            error: "Failed to update user data",
          ),
        );
      }
    }).catchError((error) {
      print(error.toString());
      emit(
        HomeUpdateUserDataErrorState(
          error: error.toString(),
        ),
      );
    });
  }

  ChangePasswordModel? changePasswordModel;

  changeUserPassword({
    required String? current_password,
    required String? new_password,
  }) async {
    try {
      emit(HomeUpdateUserPasswordLoadingState());

      var response = await DioHelper.postData(
        url: CHANGE_PASSWORD,
        token: kToken,
        data: {
          'current_password': current_password,
          'new_password': new_password,
        },
      );
      changePasswordModel = ChangePasswordModel.fromJson(response.data);
      if (changePasswordModel!.status!) {
        print("Updated Password is : $new_password");
        emit(
          HomeUpdateUserPasswordSuccessfulState(
            changePasswordModel: changePasswordModel!,
          ),
        );
      } else {
        emit(
          HomeUpdateUserPasswordSuccessfulState(
            changePasswordModel: changePasswordModel!,
          ),
        );
      }
    } catch (error) {
      print(error.toString());
      emit(
        HomeUpdateUserPasswordErrorState(
          error: error.toString(),
        ),
      );
    }
  }

  File? profileImage;
  ImagePicker? picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker!.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 500.0,
      maxWidth: 500.0,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print("Picked Path: ${pickedFile.path}");
      // profileImage = userData!.data!.image! as File?;
      // profileImage = userInfoModel!.data!.image! as File?;
      emit(HomeChangeImageSuccessfulState());
    } else {
      print('No image selected.');
      emit(HomeChangeImageErrorState(userLogRegModel: userData!));
    }
  }
}
