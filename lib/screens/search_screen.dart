import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salla/cubits/home_layout_cubit/home_layout_cubit.dart';
import 'package:salla/cubits/search_cubit/search_cubit.dart';
import 'package:salla/models/search_model.dart';
import 'package:salla/screens/login_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/network/local/shared_preference_helper.dart';
import 'package:salla/shared/styles/colors.dart';
import 'package:salla/shared/styles/themes.dart';

import '../cubits/app_cubit/app_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: Image.asset("assets/images/shanta.png",
                          fit: BoxFit.contain)
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
                    setState(() {
                      AppCubit.get(context).changeTheme(context);
                    });
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
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    customTextFormField(
                      controller: searchController,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Field Can NOT be Empty!';
                        }
                        return null;
                      },
                      hint: "Search Products",
                      label: "Search Products",
                      prefix: FontAwesomeIcons.search,
                      onChange: (value) {
                        SearchCubit.get(context).searchProducts(
                          text: value,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: state is SearchLoadingState,
                      child: const LinearProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    ),
                    if (state is SearchSuccessfulState)
                      const Expanded(child: BuildSearchProductsList()),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

class BuildSearchProductsList extends StatelessWidget {
  const BuildSearchProductsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return buildProductsItem(
            SearchCubit.get(context).searchModel!.data!.data![index],
            context,
          );
        },
        separatorBuilder: (context, index) => myDivider(),
        itemCount: SearchCubit.get(context).searchModel!.data!.data!.length,
      ),
    );
  }
}

Widget buildProductsItem(DataDetails model, context) => Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppCubit.get(context).isDarkTheme
              ? darkTheme.primaryColor
              : Colors.white,
        ),
        height: 270,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image.network(
                  model.image!,
                  color: AppCubit.get(context).isDarkTheme
                      ? darkTheme.primaryColor
                      : null,
                  colorBlendMode: AppCubit.get(context).isDarkTheme
                      ? BlendMode.lighten
                      : null,
                  fit: AppCubit.get(context).isDarkTheme
                      ? BoxFit.fill
                      : BoxFit.contain,
                  height: 150,
                  width: double.infinity,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Text(
                model.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                    "L.E ${model.price.round()} ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: const EdgeInsets.only(right: 4),
                    onPressed: () async {
                      await HomeLayoutCubit.get(context).changeFavorites(
                        model.id!,
                      );
                    },
                    icon: !HomeLayoutCubit.get(context).favorites[model.id]!
                        ? const Icon(
                            FontAwesomeIcons.heart,
                            size: 24,
                          )
                        : const Icon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.red,
                            size: 24,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
