import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/MReview.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/providers/review_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/preference_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:bebeautyapp/ui/home/cart/cart_screens.dart';
import 'package:bebeautyapp/ui/home/details/details_screen.dart';

import 'package:bebeautyapp/ui/home/homes/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../model/MBrand.dart';

class BestSellScreen extends StatelessWidget {
  final preferenceServices = new PreferenceServices();

  final productServices = new ProductServices();

  final reviewServices = new ReviewServices();

  late List<MProduct> products;
  late List<MProduct> suggestProducts;
  late List<MBrand> brands;

  BestSellScreen(List<MProduct> Products) {
    this.products = Products;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final reviewProvider = Provider.of<ReviewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Image.asset("assets/icons/back.png", height: 24, width: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Best sell",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontFamily: 'Helvetica',
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          // IconButton(
          //   icon: SvgPicture.asset(
          //     "assets/icons/search.svg",
          //     // By default our  icon color is white
          //     color: kTextColor,
          //   ),
          //   onPressed: () {
          //     showSearch(context: context, delegate: DataSearch(products, suggestProducts, brands));
          //   },
          // ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/cart.svg",
              color: Colors.black45,
              height: 24,
              width: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
          const SizedBox(width: kDefaultPadding / 2)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: GridView.builder(
                        itemCount: products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: kDefaultPadding,
                          crossAxisSpacing: kDefaultPadding,
                          childAspectRatio: 0.5,
                        ),
                        itemBuilder: (context, index) => ProductCard(
                          product: products[index],
                          rating: true,
                          press: () async {
                            productProvider
                                    .isNeededUpdated_SimilarProductsBasedUserByCBR =
                                true;
                            await preferenceServices.updatePreference(
                                userProvider.user, products[index]);

                            productProvider
                                .isNeededUpdated_SimilarProductsByCFR = true;
                            await preferenceServices.updatePreference(
                                userProvider.user, products[index]);

                            List<MProduct> similarProductsFromSelectedProducts =
                                await productServices
                                    .getSimilarityProductsBySelectedProduct(
                                        productProvider.products,
                                        products[index]);

                            List<MReview> reviewsOfProduct =
                                reviewServices.getReviewOfProduct(
                                    reviewProvider.reviews, products[index].id);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // builder: (context) => DetailsScreen(
                                  //   product: products[index],
                                  // ),
                                  builder: (context) => DetailsScreen(
                                    product: products[index],
                                    similarProductsFromSelectedProducts:
                                        similarProductsFromSelectedProducts,
                                    reviewsOfProduct: reviewsOfProduct,
                                  ),
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
