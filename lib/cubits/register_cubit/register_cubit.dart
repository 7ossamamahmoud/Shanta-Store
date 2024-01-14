import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/models/user_model.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  UserAuthModel? model;

  registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(RegisterLoadingState());
    return await DioHelper.postData(
      url: REGISTER,
      data: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      },
      lang: 'ar',
    ).then((value) {
      print("DATA IS${value.data}");
      model = UserAuthModel.fromJson(value.data);
      print('MODEL IS: ${model!.data}');
      emit(
        RegisterSuccessfulState(
          userModel: model!,
        ),
      );
    }).catchError((onError) {
      print(onError.toString());
      emit(RegisterErrorState(errMessage: onError.toString()));
    });
  }

  IconData suffixIcon = Icons.visibility_outlined;
  bool isVisible = true;

  changeVisibility() {
    isVisible = !isVisible;
    suffixIcon =
        isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibilityState());
  }
}
