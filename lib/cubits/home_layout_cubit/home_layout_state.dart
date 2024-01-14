part of 'home_layout_cubit.dart';

@immutable
abstract class HomeLayoutStates {}

class HomeLayoutInitialState extends HomeLayoutStates {}

class HomeLayoutChangeBottomNavState extends HomeLayoutStates {}

class HomeDataSuccessfulState extends HomeLayoutStates {}

class HomeDataErrorState extends HomeLayoutStates {
  final String error;

  HomeDataErrorState({required this.error});
}

class HomeCategoriesSuccessfulState extends HomeLayoutStates {}

class HomeCategoriesErrorState extends HomeLayoutStates {
  final String error;

  HomeCategoriesErrorState({required this.error});
}

class HomeDataLoadingState extends HomeLayoutStates {}

class HomeGetFavoritesSuccessfulState extends HomeLayoutStates {}

class HomeGetFavoritesLoadingState extends HomeLayoutStates {}

class HomeGetFavoritesErrorState extends HomeLayoutStates {
  final String error;

  HomeGetFavoritesErrorState({required this.error});
}

class HomeGetCategoryProductsSuccessfulState extends HomeLayoutStates {}

class HomeGetCategoryProductsLoadingState extends HomeLayoutStates {}

class HomeGetCategoryProductsErrorState extends HomeLayoutStates {
  final String error;

  HomeGetCategoryProductsErrorState({required this.error});
}

class HomeGetUserDataSuccessfulState extends HomeLayoutStates {}

class HomeGetUserDataLoadingState extends HomeLayoutStates {}

class HomeGetUserDataErrorState extends HomeLayoutStates {
  final String error;

  HomeGetUserDataErrorState({required this.error});
}

class HomeUpdateUserDataSuccessfulState extends HomeLayoutStates {
  final UpdateUserInfoModel userInfoModel;

  HomeUpdateUserDataSuccessfulState({required this.userInfoModel});
}

class HomeUpdateUserDataLoadingState extends HomeLayoutStates {}

class HomeUpdateUserDataErrorState extends HomeLayoutStates {
  final String error;

  HomeUpdateUserDataErrorState({required this.error});
}

class HomeChangeFavoritesLoadingState extends HomeLayoutStates {}

class HomeUpdateUserPasswordSuccessfulState extends HomeLayoutStates {
  final ChangePasswordModel changePasswordModel;

  HomeUpdateUserPasswordSuccessfulState({required this.changePasswordModel});
}

class HomeUpdateUserPasswordLoadingState extends HomeLayoutStates {}

class HomeUpdateUserPasswordErrorState extends HomeLayoutStates {
  final String error;

  HomeUpdateUserPasswordErrorState({required this.error});
}

class HomeChangeFavoritesSuccessfulState extends HomeLayoutStates {
  final ChangeFavoritesModel changeFavoritesModel;

  HomeChangeFavoritesSuccessfulState({required this.changeFavoritesModel});
}

class HomeChangeImageSuccessfulState extends HomeLayoutStates {}

class HomeChangeImageErrorState extends HomeLayoutStates {
  final UserAuthModel userLogRegModel;

  HomeChangeImageErrorState({required this.userLogRegModel});
}

class HomeChangeFavoritesErrorState extends HomeLayoutStates {
  final String error;

  HomeChangeFavoritesErrorState({required this.error});
}
