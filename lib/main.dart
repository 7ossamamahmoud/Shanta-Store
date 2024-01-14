import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/cubits/app_cubit/app_cubit.dart';
import 'package:salla/cubits/home_layout_cubit/home_layout_cubit.dart';
import 'package:salla/layout/home_screen.dart';
import 'package:salla/screens/login_screen.dart';
import 'package:salla/screens/on_boarding_screen.dart';
import 'package:salla/screens/register_screen.dart';
import 'package:salla/shared/bloc_observer.dart';
import 'package:salla/shared/network/local/shared_preference_helper.dart';
import 'package:salla/shared/network/remote/dio_helper.dart';
import 'package:salla/shared/styles/themes.dart';

import 'shared/components/constants.dart';

void main() async {
  String currentDirectory = Directory.current.path;

  print('Directory: $currentDirectory');
  WidgetsFlutterBinding.ensureInitialized();
  await DioHelper.init();
  await SharedPrefService.init();
  Bloc.observer = MyBlocObserver();
  late Widget startingWidget;
  bool onBoarding = SharedPrefService.getData(key: 'onBoarding') ?? false;
  kToken = await SharedPrefService.getData(key: 'token') ?? '';
  print(kToken);
  if (onBoarding) {
    if (kToken.isNotEmpty) {
      startingWidget = const HomeScreen();
    } else {
      startingWidget = const LoginScreen();
    }
  } else {
    startingWidget = const OnBoardingScreen();
  }
  runApp(SallaApp(
    startingWidget: startingWidget,
  ));
}

class SallaApp extends StatelessWidget {
  const SallaApp({
    super.key,
    required this.startingWidget,
  });

  final Widget startingWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit(),
        ),
        BlocProvider(
            create: (context) => HomeLayoutCubit()
              ..fetchHomeData()
              ..fetchCategories()
              ..fetchFavorites()
              ..fetchUserData()),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return MaterialApp(
            theme: AppCubit.get(context).isDarkTheme ? darkTheme : lightTheme,
            debugShowCheckedModeBanner: false,
            routes: {
              OnBoardingScreen.onBoardingScreenID: (context) =>
                  const OnBoardingScreen(),
              LoginScreen.loginScreenID: (context) => const LoginScreen(),
              RegisterScreen.registerScreenID: (context) =>
                  const RegisterScreen(),
              HomeScreen.homeScreenID: (context) => const HomeScreen(),
            },
            home: startingWidget,
          );
        },
      ),
    );
  }
}
