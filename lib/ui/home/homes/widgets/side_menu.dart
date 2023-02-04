import 'package:bebeautyapp/model/MCategory.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/category/category_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenu extends StatefulWidget {
  final List<MCategory> categories;

  const SideMenu({Key? key, required this.categories}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final productServices = ProductServices();

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Drawer(
      width: 300,
      child: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/images/app_text_title_green.png',
              width: 250,
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.categories.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    List<MProduct> allProductsFromCategory =
                        productServices.getAllProductsFromCategory(
                            productProvider.products,
                            widget.categories[index].getID());
                    productProvider
                        .updateProductsFromCategory(allProductsFromCategory);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryScreens(
                            category: widget.categories[index],
                            allProductsFromCategory:
                                productProvider.allProductsFromCategory,
                          ),
                        ));
                  },
                  child: ListTile(
                    title: Text(widget.categories[index].name),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
