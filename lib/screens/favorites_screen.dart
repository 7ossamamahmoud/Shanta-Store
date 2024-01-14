import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salla/cubits/home_layout_cubit/home_layout_cubit.dart';
import 'package:salla/models/get_favorites_model.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/styles/colors.dart';
import 'package:salla/shared/styles/themes.dart';

import '../cubits/app_cubit/app_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
        builder: (context, state) {
          return ConditionalBuilder(
              condition:
                  HomeLayoutCubit.get(context).getFavoritesModel != null &&
                      state is! HomeGetFavoritesLoadingState &&
                      HomeLayoutCubit.get(context).homeModel != null,
              builder: (context) {
                return Align(
                  alignment: Alignment.topCenter,
                  child: ListView.separated(
                      shrinkWrap: true,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return buildFavoriteItem(
                          HomeLayoutCubit.get(context)
                              .getFavoritesModel!
                              .data!
                              .data![index],
                          context,
                        );
                      },
                      separatorBuilder: (context, index) => myDivider(),
                      itemCount: HomeLayoutCubit.get(context)
                          .getFavoritesModel!
                          .data!
                          .data!
                          .length),
                );
              },
              fallback: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ));
        },
        listener: (context, state) {});
  }
}

Widget buildFavoriteItem(FavoritesData favoritesData, context) => Padding(
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
                  favoritesData.product!.image!,
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
                if (favoritesData.product!.oldPrice !=
                    favoritesData.product!.price)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.red,
                    child: Text(
                      '${favoritesData.product!.discount}% DISCOUNT',
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
                favoritesData.product!.name,
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
                    "L.E ${favoritesData.product!.price.round()} ",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  if (favoritesData.product!.oldPrice !=
                      favoritesData.product!.price)
                    Text(
                      "${favoritesData.product!.oldPrice}",
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
                        favoritesData.product!.id!,
                      );
                    },
                    icon: !HomeLayoutCubit.get(context)
                            .favorites[favoritesData.product!.id]!
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
