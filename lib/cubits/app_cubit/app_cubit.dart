import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:salla/shared/network/local/shared_preference_helper.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  bool get isDarkTheme =>
      SharedPrefService.getData(key: 'isDarkTheme') ?? false;

  setDarkTheme(bool value) async {
    await SharedPrefService.saveData(key: 'isDarkTheme', value: value)
        .then((value) {
      emit(AppChangeThemeState());
    }).catchError((e) => print('Error setting dark theme preference: $e'));
  }

  void changeTheme(context) {
    bool isDarkTheme = AppCubit.get(context).isDarkTheme;
    setDarkTheme(!isDarkTheme);
  }
}
