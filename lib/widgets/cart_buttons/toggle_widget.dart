import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:zarea_user/auth_providers/cart_provider.dart';

class ToggleWidget extends StatelessWidget {
  const ToggleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ToggleSwitch(
          minWidth: 200.0,
          activeBgColors: [[Theme.of(context).primaryColor],[Theme.of(context).primaryColor]],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey.shade600,
          inactiveFgColor: Colors.white,
          cornerRadius: 20.0,
          initialLabelIndex: 0,
          totalSwitches: 2,
          labels: const ['Pay Online', 'Cash On Delivery',],
          onToggle: (index) {
            cartProvider.getPaymentMethod(index);
          },
        ),
      ),
    );
  }
}
