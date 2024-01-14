import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salla/cubits/home_layout_cubit/home_layout_cubit.dart';
import 'package:salla/models/categories_model.dart';
import 'package:salla/models/category_products_model.dart';
import 'package:salla/screens/search_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/styles/colors.dart';
import 'package:salla/shared/styles/themes.dart';

import '../cubits/app_cubit/app_cubit.dart';
import '../shared/network/local/shared_preference_helper.dart';
import 'login_screen.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({super.key});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: kPrimaryColor,
              child: CircleAvatar(
                radius: 25,
                backgroundImage:
                    Image.asset("assets/images/shanta.png", fit: BoxFit.cover)
                        .image,
              ),
            ),
          ),
          scrolledUnderElevation: 0,
          titleSpacing: 8,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
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
        body: BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
            builder: (context, state) {
              return ConditionalBuilder(
                  condition: state is! HomeGetCategoryProductsLoadingState &&
                      HomeLayoutCubit.get(context).categoryProductsModel !=
                          null,
                  builder: (context) {
                    return Align(
                        alignment: Alignment.topCenter,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return buildCategoryProductItem(
                              HomeLayoutCubit.get(context)
                                  .categoryProductsModel!
                                  .data!
                                  .data![index],
                              HomeLayoutCubit.get(context)
                                  .categoriesModel!
                                  .data
                                  .data[index],
                              context,
                            );
                          },
                          separatorBuilder: (context, index) => myDivider(),
                          itemCount: HomeLayoutCubit.get(context)
                              .categoryProductsModel!
                              .data!
                              .data!
                              .length,
                        ));
                  },
                  fallback: (context) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ));
                  });
            },
            listener: (context, state) {}));
  }
}

Widget buildCategoryProductItem(CatProdData categoryProductsModel,
        CategoryDataModel categoryDataModel, context) =>
    Padding(
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
                  categoryProductsModel.image!,
                  color: AppCubit.get(context).isDarkTheme
                      ? darkTheme.primaryColor
                      : null,
                  colorBlendMode: AppCubit.get(context).isDarkTheme
                      ? BlendMode.lighten
                      : null,
                  fit: BoxFit.contain,
                  height: 150,
                  width: double.infinity,
                ),
                if (categoryProductsModel.oldPrice !=
                    categoryProductsModel.price)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.red,
                    child: Text(
                      '${categoryProductsModel.discount}% DISCOUNT',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Text(
                categoryProductsModel.name!,
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
                    "L.E ${categoryProductsModel.price.round()} ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  if (categoryProductsModel.oldPrice !=
                      categoryProductsModel.price)
                    Text(
                      "${categoryProductsModel.oldPrice}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        decoration: TextDecoration.lineThrough,
                        height: 1.2,
                        fontSize: 16,
                      ),
                    ),
                  const Spacer(),
                  IconButton(
                    padding: const EdgeInsets.only(right: 4),
                    onPressed: () async {
                      await HomeLayoutCubit.get(context).changeFavorites(
                        categoryProductsModel.id!,
                      );
                    },
                    icon: !HomeLayoutCubit.get(context)
                            .favorites[categoryProductsModel.id]!
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
