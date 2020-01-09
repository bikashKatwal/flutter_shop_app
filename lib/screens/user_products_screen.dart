import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = 'user_products_screen';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage your product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productsData.length,
          itemBuilder: (context, i) => Column(
            children: <Widget>[
              UserProductItem(
                title: productsData[i].title,
                imageUrl: productsData[i].imageUrl,
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}