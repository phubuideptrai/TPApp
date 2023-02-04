import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProductInCart.dart';
import 'package:bebeautyapp/model/MVoucher.dart';
import 'package:bebeautyapp/repo/providers/cart_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/cart_services.dart';
import 'package:bebeautyapp/ui/home/cart/grid_item.dart';

import 'package:bebeautyapp/ui/home/payment/payment_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

import '../../../repo/services/voucher_services.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreen createState() => new _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  List<MProductInCart> selectedList = [];
  final cartServices = new CartServices();
  final voucherServices = new VoucherServices();
  String voucherCode = "";
  TextEditingController _voucherController = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            "assets/icons/back.png",
            height: 24,
            width: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          selectedList.length < 1
              ? "Cart"
              : "${selectedList.length} item selected",
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontFamily: 'Helvetica',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (selectedList.length > 0) {
                cartProvider.removeProductsInCart(
                    cartProvider.cart, selectedList);
                setState(() {
                  selectedList = [];
                });
              } else {
                showDialogForRemove(context);
              }
            },
            icon: const Icon(
              Icons.delete_outlined,
              color: Colors.black54,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cartProvider.cart.products.isNotEmpty
                ? GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: cartProvider.cart.products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 4,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return GridItem(
                          productInCart: cartProvider.cart.products[index],
                          isSelected: (bool value) {
                            setState(() {
                              if (value) {
                                selectedList
                                    .add(cartProvider.cart.products[index]);
                              } else {
                                selectedList
                                    .remove(cartProvider.cart.products[index]);
                              }
                            });
                          },
                          key: Key(cartProvider.cart.products[index]
                              .getID()
                              .toString()));
                    })
                : Center(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          child: SvgPicture.asset('assets/icons/not_order.svg'),
                        ),
                        Text('No Product In Cart!'),
                      ],
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 30,
            ),
            // height: 174,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -15),
                  blurRadius: 20,
                  color: Color(0xFFDADADA).withOpacity(0.15),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset("assets/icons/receipt.svg"),
                      ),
                      Spacer(),
                      Container(
                        width: 136,
                        height: 48,
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _voucherController,
                          style:
                              TextStyle(color: kTextLightColor, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Add voucher here',
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: kGreenColor, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              voucherCode = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          children: [
                            TextSpan(
                              text: "\n" +
                                  cartServices
                                      .totalValueOfSelectedProductsInCart(
                                          selectedList)
                                      .toStringAsFixed(0)
                                      .toVND(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: kRedColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: MaterialButton(
                            color: Colors.white,
                            shape: Border.all(
                              color: kGreenColor,
                              width: 2,
                            ),
                            elevation: 1,
                            onPressed: () async {
                              if (selectedList.length > 0) {
                                MVoucher defaultVoucher = MVoucher();
                                if (voucherCode != "") {
                                  double totalValue = cartServices
                                      .totalValueOfSelectedProductsInCart(
                                          selectedList);
                                  MVoucher voucher =
                                      await voucherServices.isValidVoucher(
                                          voucherCode,
                                          totalValue,
                                          userProvider.user.point);
                                  if (voucher.getID() != "") {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PaymentDetails(
                                          productsInCart: selectedList,
                                          voucher: voucher,
                                        ),
                                      ),
                                    );
                                  }
                                } else
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PaymentDetails(
                                        productsInCart: selectedList,
                                        voucher: defaultVoucher,
                                      ),
                                    ),
                                  );
                              } else
                                showDialogForCheckOut(context);
                            },
                            child: Text(
                              'Check Out',
                              style: TextStyle(
                                color: kGreenColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDialogForRemove(BuildContext) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Column(
              children: const [
                Icon(
                  Icons.announcement_outlined,
                  size: 40,
                  color: kRedColor,
                ),
                Text(
                  'You have not select any item to delete!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        });
  }

  void showDialogForCheckOut(BuildContext) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Column(
              children: const [
                Icon(
                  Icons.announcement_outlined,
                  size: 40,
                  color: kRedColor,
                ),
                Text(
                  'You have not select any item to check out!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        });
  }
}
