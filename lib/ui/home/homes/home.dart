import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/providers/brand_provider.dart';
import 'package:bebeautyapp/repo/providers/category_provider.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/services/brand_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/home/cart/cart_screens.dart';

import 'package:bebeautyapp/ui/home/homes/search/search_screens.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/best_sell/best_sell.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/brand/brand_card.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/new_product/new_product.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/recommend_product/recommend_product.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:provider/provider.dart';

import '../../../model/MBrand.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final productServices = ProductServices();

  final brandServices = BrandServices();

  List<MProduct> products = [];

  List<MProduct> suggestProducts = [];

  List<MBrand> brands = [];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final brandProvider = Provider.of<BrandProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    TextEditingController _searchQueryController = TextEditingController();
    List<MBrand> getBrandList() {
      return brandProvider.brands;
    }

    List<MProduct> getSuggestionProductList() {
      productProvider.loadSuggestionBooks();
      return productProvider.sugesstionProducts;
    }

    List<MProduct> getProductList() {
      return productProvider.products;
    }

    return Scaffold(
      backgroundColor: kBgColor,
      drawer: SideMenu(
        categories: categoryProvider.categories,
      ),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.category_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();

              // showSearch(
              //     context: context,
              //     delegate: DataSearch(getProductList(),
              //         getSuggestionProductList(), getBrandList()));
            },
          ),
        ),
        title: Container(
          height: 40,
          width: double.infinity,
          color: Colors.white,
          child: TextField(
            controller: _searchQueryController,
            decoration: const InputDecoration(
              hintText: "What are you looking for?",
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black45,
              ),
            ),
            style: const TextStyle(
              color: Colors.black45,
              fontFamily: 'Helvetica',
              fontSize: 14,
            ),
            onTap: () {
              showSearch(
                  context: context,
                  delegate: DataSearch(getProductList(),
                      getSuggestionProductList(), getBrandList()));
            },
          ),
        ),
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
          children: [
            SizedBox(
              height: 180,
              child: Carousel(
                images: [
                  Image.asset('assets/images/banner_01.png'),
                  Image.asset('assets/images/banner_01.png'),
                  Image.asset('assets/images/banner_01.png'),
                ],
                dotSize: 4.0,
                dotSpacing: 15.0,
                dotColor: kTextColor,
                dotIncreasedColor: kRedColor,
                dotBgColor: Colors.transparent,
                moveIndicatorFromBottom: 180,
                showIndicator: true,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 60,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
            BestSell(productServices
                .getTop10BestSellerProduct(productProvider.products)),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
            BrandCard(brandServices.getTop5Brand(brandProvider.brands)),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
            RecommendProduct(),
            NewProduct(
                productServices.getTop10NewProducts(productProvider.products)),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
