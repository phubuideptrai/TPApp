import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/providers/review_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/preference_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:bebeautyapp/repo/services/user_services.dart';
import 'package:bebeautyapp/ui/home/details/details_screen.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/product_card.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/same_brand/same_brand.dart';

import 'package:flutter/material.dart';
import 'package:bebeautyapp/constants.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../model/MReview.dart';
import '../../../review/components/review_card.dart';
import '../../../review/reviews.dart';
import 'description.dart';

class Body extends StatefulWidget {
  const Body(
      {Key? key,
      required this.product,
      required this.similarProductsFromSelectedProducts,
      required this.reviewsOfProduct})
      : super(key: key);
  final MProduct product;
  final List<MProduct> similarProductsFromSelectedProducts;
  final List<MReview> reviewsOfProduct;

  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final preferenceServices = new PreferenceServices();
  final productServices = new ProductServices();
  final reviewServices = new ReviewServices();
  final userServices = new UserServices();

  int currentIndex = 0;
  NumberFormat currencyformat = new NumberFormat("#,###,##0");
  bool isMore = false;
  PageController pageController = PageController(initialPage: 0);
  // It provide us total height and width
  late Size size;
  List<MUser> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsersReview();
  }

  Future<void> getUsersReview() async {
    List<MUser> results = [];
    for (int i = 0; i < widget.reviewsOfProduct.length; i++) {
      MUser user =
          await userServices.getUser(widget.reviewsOfProduct[i].userID);
      bool isAdd = true;
      for (int j = 0; j < results.length; j++) {
        if (results[j].getID() == user.getID()) isAdd = false;
      }

      if (isAdd == true) results.add(user);
    }
    setState(() {
      users = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);

    size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: kBgColor,
            height: 350,
            margin: const EdgeInsets.symmetric(vertical: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(children: [
              PageView.builder(
                controller: pageController,
                itemCount: widget.product.images.length,
                pageSnapping: true,
                itemBuilder: (context, index) {
                  currentIndex = index;
                  return Stack(children: [
                    Image.network(
                      widget.product.images[index],
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                    ),
                  ]);
                },
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: kTextColor.withOpacity(0.4),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    "${currentIndex + 1}/${widget.product.images.length}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Helvetica',
                        fontSize: 14),
                  ),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 300,
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Helvetica'),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: kRedColor),
                  ),
                  child: Text(
                    "-${widget.product.defaultDiscountRate}%",
                    style: const TextStyle(
                        fontSize: 14,
                        color: kRedColor,
                        fontFamily: 'Helvetica'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: kDefaultPadding),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              currencyformat.format(widget.product.getPrice()) + 'đ',
              style: const TextStyle(
                color: kRedColor,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              currencyformat.format(widget.product.getMarketPrice()) + 'đ',
              style: const TextStyle(
                color: kTextLightColor,
                fontSize: 16,
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ),
          const SizedBox(
            height: kDefaultPadding / 4,
          ),
          Container(
            height: 350,
            padding: const EdgeInsets.only(left: 16.0),
            child: DefaultTabController(
              length: 4,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  HomeTopTabs(widget.product),
                  HomeTopTabs(widget.product),
                  HomeTopTabs(widget.product),
                  HomeTopTabs(widget.product),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: (20), right: (20), bottom: (0)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reviews",
                    style: TextStyle(
                      fontSize: (18),
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.reviewsOfProduct.length == 0
                        ? " "
                        : widget.reviewsOfProduct.length.toString() +
                            " reviews",
                    style: TextStyle(
                      fontSize: 14,
                      color: kSecondaryColor,
                    ),
                  ),
                ]),
          ),
          widget.reviewsOfProduct.length != 0
              ? ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all((15)),
                  itemCount: widget.reviewsOfProduct.length,
                  itemBuilder: (context, index) {
                    return ReviewCard(
                      review: widget.reviewsOfProduct[index],
                      onTap: () => setState(() {
                        isMore = !isMore;
                      }),
                      isLess: isMore,
                      user: userServices.getUserForReview(
                          users, widget.reviewsOfProduct[index].userID),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 2.0,
                      color: kAccentColor,
                    );
                  },
                )
              : Padding(
                  padding: EdgeInsets.all((15)),
                  child: Align(
                    child: Text("No reviews yet.",
                        style: TextStyle(color: kSecondaryColor)),
                    alignment: Alignment.center,
                  ),
                ),
          widget.reviewsOfProduct.length != 0
              ? Padding(
                  padding: EdgeInsets.all((15)),
                  child: Align(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Reviews(
                                productID: widget.product.id,
                                reviews: widget.reviewsOfProduct)));
                      },
                      child: Text("See More",
                          style: TextStyle(
                              color: Color.fromARGB(255, 125, 133, 151))),
                    ),
                    alignment: Alignment.center,
                  ),
                )
              : SizedBox.shrink(),
          kSmallDivider,
          SameBrand(productServices.getProductsFromSameBrand(
              productProvider.products, widget.product)),
          const SizedBox(
            height: 16,
          ),
          Row(children: const <Widget>[
            Expanded(
                child: Divider(
              indent: 24,
              endIndent: 16,
              thickness: 1.5,
            )),
            Text(
              "You aslo may like",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Helvatica",
                  letterSpacing: -1,
                  color: kTextColor),
            ),
            Expanded(
                child: Divider(
              indent: 24,
              endIndent: 16,
              thickness: 1.5,
            )),
          ]),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 175,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: GridView.builder(
                itemCount: widget.similarProductsFromSelectedProducts.length > 6
                    ? 6
                    : widget.similarProductsFromSelectedProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kDefaultPadding,
                  crossAxisSpacing: kDefaultPadding,
                  childAspectRatio: 0.5,
                ),
                itemBuilder: (context, index) => ProductCard(
                  rating: true,
                  product: widget.similarProductsFromSelectedProducts[index],
                  press: () async {
                    productProvider
                        .isNeededUpdated_SimilarProductsBasedUserByCBR = true;
                    await preferenceServices.updatePreference(userProvider.user,
                        widget.similarProductsFromSelectedProducts[index]);

                    //productProvider.isNeededUpdated_SimilarProductsByCFR = true;
                    //await preferenceServices.updatePreference(userProvider.user, widget.similarProductsFromSelectedProducts[index]);
                    List<MProduct> similarProductsFromSelectedProducts =
                        await productServices
                            .getSimilarityProductsBySelectedProduct(
                                productProvider.products,
                                widget.similarProductsFromSelectedProducts[
                                    index]);

                    List<MReview> reviewsOfProduct1 =
                        reviewServices.getReviewOfProduct(
                            reviewProvider.reviews,
                            widget
                                .similarProductsFromSelectedProducts[index].id);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => DetailsScreen(
                          //   product: products[index],
                          // ),
                          builder: (context) => DetailsScreen(
                            product: widget
                                .similarProductsFromSelectedProducts[index],
                            similarProductsFromSelectedProducts:
                                similarProductsFromSelectedProducts,
                            reviewsOfProduct: reviewsOfProduct1,
                          ),
                        ));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  HomeTopTabs(product) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48.0), // here the desired height
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            backgroundColor: kBgColor,
            bottom: const TabBar(
              isScrollable: true,
              indicatorWeight: 2.0,
              indicatorColor: Colors.black,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Description',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Product Specifications',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Chemical Composition',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Tab(
                  child: Text(
                    'Guideline',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Description(product: product, type: "description"),
            Description(product: product, type: "product specifications"),
            Description(product: product, type: "chemical composition"),
            Description(product: product, type: "guideline"),
          ],
        ),
      ),
    );
  }
}
