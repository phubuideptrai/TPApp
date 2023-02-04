import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/MReview.dart';
import 'package:bebeautyapp/repo/providers/review_provider.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:bebeautyapp/ui/home/details/widgets/cart_counter.dart';

import 'package:bebeautyapp/ui/home/cart/cart_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/ui/home/details/widgets/body.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../repo/providers/cart_provider.dart';
import '../../../repo/providers/product_provider.dart';
import '../../../repo/providers/user_provider.dart';
import '../../../repo/services/product_services.dart';

class DetailsScreen extends StatelessWidget {
  final MProduct product;
  final List<MProduct> similarProductsFromSelectedProducts;
  final List<MReview> reviewsOfProduct;

  final productServices = new ProductServices();

  final ScrollController _scrollController = ScrollController();

  DetailsScreen(
      {Key? key,
      required this.product,
      required this.similarProductsFromSelectedProducts,
      required this.reviewsOfProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    bool isFavorite = productServices.checkFavorite(
        userProvider.user.getID(), product.getUserFavorite());

    void addToCartDrawer(BuildContext context, MProduct product) {
      ProductServices productServices = new ProductServices();
      int quantity = 1;

      showModalBottomSheet(
          isDismissible: true,
          context: context,
          builder: (context) {
            return Container(
                height: 240.0,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: AspectRatio(
                              aspectRatio: 0.88,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image.network(
                                  product.images[0],
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: 'Helvetica',
                                  ),
                                  maxLines: 2,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      product.price.toStringAsFixed(0).toVND(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Helvetica',
                                          color: kRedColor),
                                    ),
                                    Spacer(),
                                    Text('Inventory: ' +
                                        product.available.toString()),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        const Text("Number: "),
                        Spacer(),
                        CartCounter(
                          increaseBottonWidget: const Icon(Icons.add,
                              color: Colors.white, size: 20),
                          decreaseBottonWidget: const Icon(Icons.remove,
                              color: Colors.white, size: 20),
                          maximumValue: product.available,
                          minimumValue: 1,
                          value: 1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          isEnable: true,
                          onChanged: (val) {
                            quantity = val;
                          },
                        ),
                      ],
                    ),
                    MaterialButton(
                      onPressed: () async {
                        MProduct currentProduct = await productServices
                            .getProductForRealTime(product);
                        if (currentProduct.available < quantity) {
                          Fluttertoast.showToast(
                              backgroundColor: Colors.red,
                              msg:
                                  "Sorry, this product don't have enough quantity in invertory to supply you.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM);
                        } else {
                          int totalQuantity = cartProvider.cart
                              .getQuantityOfProductInCart(product);
                          if (totalQuantity + quantity <=
                              currentProduct.available) {
                            cartProvider.addProductInCart(product, quantity);
                            Fluttertoast.showToast(
                                backgroundColor: Colors.green,
                                msg: "Add this product successfully.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else
                            Fluttertoast.showToast(
                                backgroundColor: Colors.red,
                                msg:
                                    "Sorry but the total quantity of this product you have added to your cart exceeds the quantity in stock we can supply.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          Navigator.pop(context);
                        }
                      },
                      color: kGreenColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 120, vertical: 12),
                      elevation: 2,
                      child: const Text(
                        "Add to cart",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ));
          });
    }

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: buildAppBar(context, isFavorite, userProvider.user.id),
      drawer: Drawer(),
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(children: [
            Body(
              product: product,
              similarProductsFromSelectedProducts:
                  similarProductsFromSelectedProducts,
              reviewsOfProduct: reviewsOfProduct,
            ),
          ])),
      floatingActionButton: FloatingActionButton(
        elevation: 0.5,
        backgroundColor: kGreenColor,
        child: const Icon(
          Icons.arrow_circle_up,
          color: Colors.white,
        ),
        onPressed: () {
          _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        },
      ),
      bottomNavigationBar: Material(
        elevation: kLess,
        color: Colors.white,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8.0, left: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: kGreenColor, width: 2.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: kGreenColor),
                onPressed: () async {
                  MProduct recheck_product =
                      await productServices.getProductForRealTime(product);
                  addToCartDrawer(context, recheck_product);
                },
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(right: 8.0),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: kPrimaryColor, width: 2.0),
            //   ),
            //   child: IconButton(
            //       icon: const Icon(Icons.chat, color: kPrimaryColor),
            //       onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (context) => Chat(user_id: '', chatRoomId: '', user_name: '',)),
            //           );
            //       }),
            // ),
            Expanded(
              child: SizedBox(
                height: 52.0,
                child: MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: kLessPadding),
                    color: kGreenColor,
                    textColor: Colors.white,
                    child: const Text("Buy Now",
                        style:
                            TextStyle(fontSize: 18.0, fontFamily: 'Helvatica')),
                    onPressed: () {
                      cartProvider.addProductInCart(product, 1);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, bool isFavorite, String userID) {
    final productProvider = Provider.of<ProductProvider>(context);
    return AppBar(
      elevation: 1,
      backgroundColor: kBgColor,
      leading: IconButton(
        icon: Image.asset(
          "assets/icons/back.png",
          height: 24,
          width: 24,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        // IconButton(
        //   icon: SvgPicture.asset(
        //     "assets/icons/heart.svg",
        //     color: isFavorite ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
        //     // productServices.checkFavorite(
        //     //         userProvider.user.getID(),
        //     //         product.getUserFavorite())
        //     //     ? Color(0xFFFF4848)
        //     //     : Color(0xFFDBDEE4),
        //   ),
        //   onPressed: () async {
        //     bool result =
        //         await productServices.updateFavorite(product.getID(), userID);
        //     if (result == true) {
        //       productProvider.updateUserFavorite(userID, product.getID());
        //       Fluttertoast.showToast(
        //           backgroundColor: Colors.green,
        //           msg: 'Add it to your favorite list successfully',
        //           toastLength: Toast.LENGTH_SHORT,
        //           gravity: ToastGravity.BOTTOM);
        //     } else {
        //       productProvider.updateUserFavorite(userID, product.getID());

        //       Fluttertoast.showToast(
        //           backgroundColor: Colors.green,
        //           msg: 'Remove it in your favorite list successfully',
        //           toastLength: Toast.LENGTH_SHORT,
        //           gravity: ToastGravity.BOTTOM);
        //     }
        //   },
        // ),
        // IconButton(
        //   icon: SvgPicture.asset(
        //     "assets/icons/cart.svg",
        //     color: Colors.black45,
        //     height: 24,
        //     width: 24,
        //   ),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => CartScreen()),
        //     );
        //   },
        // ),
        // const SizedBox(width: kDefaultPadding / 2)
      ],
    );
  }
}
