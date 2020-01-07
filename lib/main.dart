import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ProductsProvider();
          },
        )
      ],
      child: MaterialApp(
        initialRoute: ProductsOverviewScreen.routeName,
        routes: {
          ProductsOverviewScreen.routeName: (context) =>
              ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (context) => ProductDetailScreen()
        },
        title: kAppName,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kAppName),
      ),
      body: Center(
        child: ProductsOverviewScreen(),
      ),
    );
  }
}
