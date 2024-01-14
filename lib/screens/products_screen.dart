import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salla/cubits/app_cubit/app_cubit.dart';
import 'package:salla/cubits/home_layout_cubit/home_layout_cubit.dart';
import 'package:salla/models/categories_model.dart';
import 'package:salla/models/home_data_model.dart';
import 'package:salla/screens/category_products_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/styles/colors.dart';
import 'package:salla/shared/styles/themes.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    return RefreshIndicator.adaptive(
      color: kPrimaryColor,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      key: refreshIndicatorKey,
      onRefresh: () async {
        await HomeLayoutCubit.get(context).fetchHomeData();
      },
      child: BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
        listener: (context, state) {
          if (state is HomeChangeFavoritesSuccessfulState) {
            if (!state.changeFavoritesModel.status) {
              showMsgToast(
                context,
                msg: state.changeFavoritesModel.message,
                state: ToastStates.ERROR,
              );
            } else {
              showMsgToast(
                context,
                msg: state.changeFavoritesModel.message,
                state: ToastStates.SUCCESS,
              );
            }
          }
        },
        builder: (context, state) {
          return ConditionalBuilder(
            condition: HomeLayoutCubit.get(context).homeModel != null &&
                HomeLayoutCubit.get(context).categoriesModel != null,
            builder: (context) => homeProductsBuilder(
                HomeLayoutCubit.get(context).homeModel!,
                HomeLayoutCubit.get(context).categoriesModel!,
                context),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget homeProductsBuilder(
      HomeModel homeModel, CategoriesModel categoriesModel, context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: CarouselSlider(
              items: homeModel.data.banners.map((e) {
                return Image.network(
                  e.image,
                  fit: BoxFit.cover,
                );
              }).toList(),
              options: CarouselOptions(
                height: 220,
                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayCurve: Curves.easeInOutCubicEmphasized,
                viewportFraction: 1,
                enableInfiniteScroll: true,
                initialPage: 0,
                reverse: false,
                scrollPhysics: const BouncingScrollPhysics(),
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(
                  seconds: 1,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Categories',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Caveat'),
                ),
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    itemCount: categoriesModel.data.data.length,
                    dragStartBehavior: DragStartBehavior.down,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => buildCategoryItem(
                      categoriesModel.data.data[index],
                      HomeLayoutCubit.get(context)
                          .categoriesModel!
                          .data
                          .data[index],
                      context,
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 12,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Trending Products',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Caveat'),
                ),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
          homeProductsGridViewBuilder(homeModel, context),
        ],
      ),
    );
  }

  Widget homeProductsGridViewBuilder(HomeModel homeModel, context) => Container(
        color: Colors.grey,
        child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.31,
              mainAxisSpacing: AppCubit.get(context).isDarkTheme ? 5 : 1,
              crossAxisSpacing: AppCubit.get(context).isDarkTheme ? 5 : 1,
            ),
            itemCount: homeModel.data.products.length,
            itemBuilder: (context, index) {
              return productItemsBuilder(
                  homeModel.data.products[index], context);
            }),
      );

  Widget productItemsBuilder(ProductModel productModel, context) {
    return Container(
      color: AppCubit.get(context).isDarkTheme
          ? darkTheme.primaryColor
          : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              productModel.image != null
                  ? Image.network(
                      productModel.image,
                      color: AppCubit.get(context).isDarkTheme
                          ? darkTheme.primaryColor
                          : null,
                      colorBlendMode: AppCubit.get(context).isDarkTheme
                          ? BlendMode.lighten
                          : null,
                      fit: AppCubit.get(context).isDarkTheme
                          ? BoxFit.fill
                          : BoxFit.contain,
                      height: 170,
                      width: double.infinity,
                    )
                  : const Placeholder(),
              if (productModel.oldPrice != productModel.price)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.red,
                  child: Text(
                    '${productModel.discount}% DISCOUNT',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Text(
              productModel.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                height: 1.2,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "L.E ${productModel.price.round()} ",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (productModel.oldPrice != productModel.price)
                      Text(
                        "${productModel.oldPrice}",
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
                    Expanded(
                      child: IconButton(
                          padding: const EdgeInsets.only(right: 4),
                          onPressed: () async {
                            await HomeLayoutCubit.get(context).changeFavorites(
                              productModel.id,
                            );
                          },
                          icon: !HomeLayoutCubit.get(context)
                                  .favorites[productModel.id]!
                              ? const Icon(
                                  FontAwesomeIcons.heart,
                                  size: 22,
                                )
                              : const Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: Colors.red,
                                  size: 22,
                                )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryItem(CategoryDataModel categoriesData,
          CategoryDataModel categoryDataModel, context) =>
      GestureDetector(
        onTap: () {
          HomeLayoutCubit.get(context)
              .fetchCategoryProducts(categoryDataModel.id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CategoryProductsScreen()));
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image.network(
              categoriesData.image,
              height: 140,
              width: 140,
              fit: BoxFit.cover,
            ),
            Container(
              width: 140,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                capitalize(
                  categoriesData.name,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      );
}
