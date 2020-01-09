import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart_provider.dart' show CartItem;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  int get ordersCount {
    return _orders.length;
  }

  void addOrder(List<CartItem> cartProducts, double totalAmount) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: totalAmount,
        dateTime: DateTime.now(),
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
