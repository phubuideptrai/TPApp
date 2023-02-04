import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/home/details/details_screen.dart';

import 'package:bebeautyapp/ui/home/homes/widgets/best_sell/best_sell_screens.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/star_rating.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    Key? key,
    required this.product,
    required this.press,
    required this.rating,
  }) : super(key: key);

  final MProduct product;
  final GestureTapCallback press;
  bool rating;

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyformat = NumberFormat("#,###,##0");
    final productServices = ProductServices();
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 170,
        height: 300,
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(product.getImage(0)),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/sale.svg',
                        height: 48,
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 12, top: 10),
                          child: RichText(
                            text: TextSpan(
                              text:
                                  product.defaultDiscountRate.toString() + '%',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                              children: const <TextSpan>[
                                TextSpan(
                                  text: '\nSALE ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: product.getName(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: 'Helvetica',
                        height: 18 / 14,
                        fontSize: 14),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Text(
                      currencyformat.format(product.getPrice()) + 'đ',
                      style: const TextStyle(
                        color: kRedColor,
                        fontFamily: 'Helvetica',
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      currencyformat.format(product.getMarketPrice()) + 'đ',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: 'Helvetica',
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            rating
                ? Row(
                    children: [
                      StarRating(
                          rating: product.totalStarRating / product.totalRating,
                          size: 13),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Sold " + product.soldOut.toString(),
                        style: const TextStyle(
                            fontSize: 12, fontFamily: 'Helvetica'),
                      ),
                      const Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () async {
                          bool result = await productServices.updateFavorite(
                              product.getID(), userProvider.user.getID());
                          if (result == true) {
                            productProvider.updateUserFavorite(
                                userProvider.user.getID(), product.getID());
                            Fluttertoast.showToast(
                                msg:
                                    'Add it to your favorite list successfully',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            productProvider.updateUserFavorite(
                                userProvider.user.getID(), product.getID());
                            Fluttertoast.showToast(
                                msg:
                                    'Remove it in your favorite list successfully',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: productServices.checkFavorite(
                                    userProvider.user.id,
                                    product.getUserFavorite())
                                ? kPrimaryColor.withOpacity(0.15)
                                : kSecondaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/heart.svg",
                            color: productServices.checkFavorite(
                                    userProvider.user.getID(),
                                    product.getUserFavorite())
                                ? Color(0xFFFF4848)
                                : Color(0xFFDBDEE4),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
