import 'package:flutter/material.dart';
import 'package:grad_login/screens/sub_categories_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/drugProvider.dart';
import '../providers/categoriesProvider.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({super.key});

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!.localeName;
    final categoriesProvider = Provider.of<Categories>(context);
    final categories = categoriesProvider.catItems;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 7 / 10,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          String? errorMSG =
              Provider.of<Drugs>(context, listen: false).errorMSG;
          categoriesProvider
              .getSubCategories(id: categories[index]['id'])
              .then((_) {
            errorMSG == null
                ? Navigator.of(context).pushNamed(
                    SubCategoriesScreen.routeName,
                    arguments: [
                      appLocalization == 'en'
                          ? categories[index]['name']
                          : categories[index]['name_ar'],
                    ],
                  )
                : ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(errorMSG)));
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              height: 100,
              width: 100,
              imageUrl: categories[index]['image']['image'],
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Center(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.white,
              // width: 85,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  appLocalization == 'en'
                      ? categories[index]['name']
                      : categories[index]['name_ar'],
                  maxLines: 2,
                  // overflow: TextOverflow.ellipsis,
                  // softWrap: true,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
