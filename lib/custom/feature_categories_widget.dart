import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/category_list_n_product/category_products.dart';
import 'package:flutter/material.dart';
import '../my_theme.dart';

class FeaturedCategoriesWidget extends StatelessWidget {
  final HomePresenter homeData;
  const FeaturedCategoriesWidget({Key? key, required this.homeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (homeData.isCategoryInitial && homeData.featuredCategoryList.isEmpty) {
      return ShimmerHelper().buildHorizontalGridShimmerWithAxisCount(
        crossAxisSpacing: 14.0,
        mainAxisSpacing: 14.0,
        item_count: 10,
        mainAxisExtent: 170.0,
        controller: homeData.featuredCategoryScrollController,
      );
    } else if (homeData.featuredCategoryList.isNotEmpty) {
      return GridView.builder(
        padding:
        const EdgeInsets.only(left: 18, right: 18, top: 13, bottom: 20),
        scrollDirection: Axis.horizontal,
        controller: homeData.featuredCategoryScrollController,
        itemCount: homeData.featuredCategoryList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          mainAxisExtent: 170.0,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CategoryProducts(
                  slug: homeData.featuredCategoryList[index].slug,
                );
              }));
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
              ),
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          image: homeData.featuredCategoryList[index].banner,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          homeData.featuredCategoryList[index].name,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 12,
                            color: MyTheme.font_grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (!homeData.isCategoryInitial &&
        homeData.featuredCategoryList.isEmpty) {
      return Container(
        height: 100,
        child: Center(
          child: Text(
            "No category found",
            style: TextStyle(color: MyTheme.font_grey),
          ),
        ),
      );
    } else {
      return Container(
        height: 100,
      );
    }
  }
}
