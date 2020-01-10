import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product_provider.dart';

class ProductsProvider with ChangeNotifier {
  static const url =
      'https://flutter-shop-app-1e273.firebaseio.com/products.json';

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  List<Product> get showOnlyFavouritesItems {
    return _items.where((prodItem) => prodItem.isFavouriteChecked).toList();
  }

  Product findProductById({String id}) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> _loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        _loadedProducts.add(
          Product(
              id: prodId,
              title: prodData['title'],
              price: prodData['price'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              isFavourite: prodData['isFavourite']),
        );
      });
      _items = _loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavourite': product.isFavourite
          },
        ),
      );

      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final urlUpdate =
        'https://flutter-shop-app-1e273.firebaseio.com/products/$id.json';
    final _prodIndex = _items.indexWhere((product) => product.id == id);
    if (_prodIndex >= 0) {
      await http.patch(urlUpdate,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'isFavourite': newProduct.isFavourite,
          }));
      _items[_prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> deleteProduct(String id) async {
    final urlDelete =
        'https://flutter-shop-app-1e273.firebaseio.com/products/$id.json';
    final _existingProductIndex =
        _items.indexWhere((product) => product.id == id);
    var _existingProduct = _items[_existingProductIndex];
    _items.removeAt(_existingProductIndex);
    notifyListeners();

    final response = await http.delete(urlDelete);
    if (response.statusCode >= 400) {
      _items.insert(_existingProductIndex, _existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    _existingProduct = null;
  }
}
