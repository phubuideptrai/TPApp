import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/providers/brand_provider.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/home/cart/cart_screens.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/brand/brand_card.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/brand/details_brand.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../model/MBrand.dart';

class BrandScreens extends StatefulWidget {
  const BrandScreens({Key? key}) : super(key: key);

  @override
  State<BrandScreens> createState() => _BrandScreensState();
}

class _BrandScreensState extends State<BrandScreens> {
  final productServices = ProductServices();

  late List<MProduct> products;

  late List<MProduct> suggestProducts;

  late List<MBrand> brands;

  @override
  Widget build(BuildContext context) {
    final brandProvider = Provider.of<BrandProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 1,
        leading: IconButton(
          icon: Image.asset(
            "assets/icons/back.png",
            height: 24,
            width: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Brands",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontFamily: 'Helvetica',
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    height: MediaQuery.of(context).size.height,
                    child: GridView.builder(
                      itemCount: brandProvider.brands.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: kDefaultPadding,
                      ),
                      itemBuilder: (context, index) => SpecialOfferCard(
                        category: brandProvider.brands[index].getName(),
                        image: brandProvider.brands[index].getImage(),
                        numOfBrands:
                            brandProvider.brands[index].productQuantity,
                        press: () {
                          List<MProduct> allProductsFromBrand =
                              productServices.getAllProductsFromBrand(
                                  productProvider.products,
                                  brandProvider.brands[index].id);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsBrand(
                                  brand: brandProvider.brands[index],
                                  allProductsFromBrand: allProductsFromBrand,
                                ),
                              ));
                        },
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
