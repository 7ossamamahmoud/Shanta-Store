import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/cubits/home_layout_cubit/home_layout_cubit.dart';
import 'package:salla/models/user_model.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  UserAuthModel? model;

  loginUser({required String email, required String password, context}) async {
    emit(LoginLoadingState());
    try {
      var response = await DioHelper.postData(
        url: LOGIN,
        data: {
          'email': email,
          'password': password,
        },
        lang: 'ar',
      );
      print("DATA IS${response.data}");
      model = UserAuthModel.fromJson(response.data);
      HomeLayoutCubit.get(context).userData = model;

      emit(
        LoginSuccessfulState(loginModel: model!),
      );
    } catch (e) {
      print(e.toString());
      emit(
        LoginErrorState(error: e.toString()),
      );
    }
  }

  IconData suffixIcon = Icons.visibility_outlined;
  bool isVisible = true;

  changeVisibility() {
    isVisible = !isVisible;
    suffixIcon =
        isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(
      ChangePasswordVisibilityState(),
    );
  }
}
