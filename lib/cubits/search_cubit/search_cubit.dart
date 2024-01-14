import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/shared/components/constants.dart';
import 'package:salla/shared/network/end_points.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';

import '../../models/search_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);
  SearchModel? searchModel;

  searchProducts({
    required String text,
  }) async {
    emit(SearchLoadingState());
    await DioHelper.postData(
      url: SEARCH,
      token: kToken,
      data: {
        'text': text,
      },
      lang: 'en',
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      print(searchModel);
      emit(
        SearchSuccessfulState(),
      );
    }).catchError((e) {
      print(e.toString());
      emit(
        SearchErrorState(error: e.toString()),
      );
    });
  }
}
