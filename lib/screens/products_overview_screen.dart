import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/widgets/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  static const routeName = 'products_overview_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kAppName),
      ),
      body: ProductsGrid(),
    );
  }
}
