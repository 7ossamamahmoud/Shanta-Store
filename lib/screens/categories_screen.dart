import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salla/cubits/home_layout_cubit/home_layout_cubit.dart';
import 'package:salla/models/categories_model.dart';
import 'package:salla/screens/category_products_screen.dart';
import 'package:salla/shared/components/components.dart';
import 'package:salla/shared/styles/colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
        builder: (context, state) {
          return ConditionalBuilder(
              condition: HomeLayoutCubit.get(context).categoriesModel != null,
              builder: (context) {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  reverse: true,
                  itemBuilder: (context, index) {
                    return customCategoryItem(
                        HomeLayoutCubit.get(context)
                            .categoriesModel!
                            .data
                            .data[index],
                        context);
                  },
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount: HomeLayoutCubit.get(context)
                      .categoriesModel!
                      .data
                      .data
                      .length,
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

Widget customCategoryItem(CategoryDataModel categoryDataModel, context) =>
    Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () {
          HomeLayoutCubit.get(context)
              .fetchCategoryProducts(categoryDataModel.id);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CategoryProductsScreen()));
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 58,
              backgroundColor: kPrimaryColor,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: NetworkImage(
                  categoryDataModel.image,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                capitalize(
                  categoryDataModel.name,
                ),
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  HomeLayoutCubit.get(context)
                      .fetchCategoryProducts(categoryDataModel.id);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const CategoryProductsScreen()));
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 32,
                ))
          ],
        ),
      ),
    );
