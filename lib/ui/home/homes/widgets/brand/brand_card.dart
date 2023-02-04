import 'package:bebeautyapp/model/MBrand.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/brand/brand_screens.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/brand/details_brand.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandCard extends StatelessWidget {
  late List<MBrand> brands;
  final productServices = new ProductServices();
  BrandCard(List<MBrand> Brands) {
    this.brands = Brands;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            color: Colors.black45,
            title: "Popular Brands",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrandScreens(),
                  ));
            },
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              brands.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpecialOfferCard(
                    category: brands[index].getName(),
                    image: brands[index].getImage(),
                    numOfBrands: brands[index].productQuantity,
                    press: () {
                      List<MProduct> allProductsFromBrand =
                          productServices.getAllProductsFromBrand(
                              productProvider.products, brands[index].id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsBrand(
                              brand: brands[index],
                              allProductsFromBrand: allProductsFromBrand,
                            ),
                          ));
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black45, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              image,
              fit: BoxFit.cover,
              height: 100,
              width: 170,
            ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: "$category\n",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: "$numOfBrands Product")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
