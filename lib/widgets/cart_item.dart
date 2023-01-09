import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;
  const CartItem({
    super.key,
    required this.id,
    required this.productId,
    required this.title,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content:
                const Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop(false);
              }, child: const Text('NO')),
              TextButton(onPressed: () {
                Navigator.of(context).pop(true);
              }, child: const Text('YES'),
            )],
          ),
        );
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        padding: const EdgeInsets.all(8),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.delete,
            size: 40,
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(child: FittedBox(child: Text('\$$price'))),
            title: Text(title),
            subtitle: Text('Total: ${quantity * price}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }
}
