import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salla/cubits/app_cubit/app_cubit.dart';
import 'package:salla/cubits/home_layout_cubit/home_layout_cubit.dart';
import 'package:salla/screens/login_screen.dart';
import 'package:salla/screens/search_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/network/local/shared_preference_helper.dart';
import 'package:salla/shared/styles/colors.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static String homeScreenID = "HomeScreenID";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 6.0),
              child: CircleAvatar(
                radius: 30,
                backgroundImage:
                    Image.asset("assets/images/shanta.png", fit: BoxFit.contain)
                        .image,
              ),
            ),
            scrolledUnderElevation: 0,
            titleSpacing: 4,
            title: Text(
              'Shanta',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    fontSize: 36,
                    fontFamily: 'Caveat',
                  ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  AppCubit.get(context).changeTheme(context);

                  setState(() {});
                },
                icon: AppCubit.get(context).isDarkTheme
                    ? const Icon(
                        FontAwesomeIcons.solidSun,
                      )
                    : const Icon(
                        FontAwesomeIcons.moon,
                      ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchScreen()));
                },
                icon: const Icon(
                  FontAwesomeIcons.search,
                ),
              ),
              IconButton(
                onPressed: () {
                  SharedPrefService.removeData(key: 'token').then((value) {
                    if (value) {
                      navigateAndFinish(
                        context,
                        LoginScreen.loginScreenID,
                      );
                    }
                  });
                },
                icon: const Icon(
                  FontAwesomeIcons.signOut,
                ),
              ),
            ],
          ),
          body: HomeLayoutCubit.get(context)
              .bottomNavScreens[HomeLayoutCubit.get(context).currentIndex],
          bottomNavigationBar: SalomonBottomBar(
            duration: const Duration(milliseconds: 500),
            selectedItemColor: kPrimaryColor,
            backgroundColor: Colors.transparent,
            itemPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            unselectedItemColor: Colors.grey.shade600.withOpacity(0.9),
            onTap: (index) {
              HomeLayoutCubit.get(context).changeBottomNav(index);
            },
            currentIndex: HomeLayoutCubit.get(context).currentIndex,
            items: [
              _buildBottomBarItem(
                icon: FontAwesomeIcons.home,
                title: 'Home',
              ),
              _buildBottomBarItem(
                icon: Icons.apps_rounded,
                title: 'Categories',
              ),
              _buildBottomBarItem(
                icon: FontAwesomeIcons.solidHeart,
                title: 'Favorites',
              ),
              _buildBottomBarItem(
                icon: Icons.settings,
                title: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}

SalomonBottomBarItem _buildBottomBarItem(
    {required IconData icon, required String title}) {
  return SalomonBottomBarItem(
    icon: Icon(
      icon,
      size: 18,
    ),
    title: Text(
      title,
      softWrap: true,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: 'Caveat',
        height: 1,
      ),
    ),
  );
}
