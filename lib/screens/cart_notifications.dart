import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:zarea_user/auth_providers/cart_provider.dart';
import 'package:zarea_user/services/cart_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_screen.dart';

class CartNotifications extends StatefulWidget {
  final DocumentSnapshot? snapshot;
  const CartNotifications({Key? key, this.snapshot}) : super(key: key);

  @override
  State<CartNotifications> createState() => _CartNotificationsState();
}

class _CartNotificationsState extends State<CartNotifications> {
  CartService service = CartService();
  DocumentSnapshot? snapshot;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartTotal();
    cartProvider.getShopName();
    return  cartProvider.quantity>0 ?
    InkWell(
      onTap: (){
        PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          settings: const RouteSettings(name: CartScreen.id),
          screen:   CartScreen(snapshot: cartProvider.documentSnapshot,),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(topRight: Radius.circular(16), topLeft: Radius.circular(16))
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Wrap(
                    children: [
                      Text(cartProvider.quantity==1? "item" : 'items',
                        style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      const Text(' | ',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      Text(
                      'Rs.${cartProvider.subTotal.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ],
                  ),
                   Text(
                   'From ${cartProvider.documentSnapshot?['shopName']}',
                     style: const TextStyle(color: Colors.white),),
                ],
              ),
              Row(
                children: const [
                  Text('View Cart', style: TextStyle(color: Colors.white),),
                 Icon(Icons.shopping_bag,color: Colors.white,),
                ],
              ),
            ],
          ),
        ),
      ),
    ) : Container();
  }
}
