import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zarea_user/services/cart_service.dart';
import '../cart_buttons/add_to_cart.dart';

class CounterWidget extends StatefulWidget {
  final DocumentSnapshot? snapshot;
  final int? quantity;
  final String? docId;
  const CounterWidget({Key? key,this.snapshot, this.quantity, this.docId}) : super(key: key);

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _quantity =1;
  bool updating = false;
  bool exist = true;

  CartService service = CartService();

  @override
  Widget build(BuildContext context) {
    @override
    void setState(VoidCallback fn) {
      _quantity = widget.quantity!;
      super.setState(fn);
    }
    return exist ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: FittedBox(
        child: Row(
          children: [
            InkWell(
              onTap: (){
                setState(() {
                  updating = true;
                });
                if(_quantity == 1){
                  service.deleteCart().then((value){
                    updating = false;
                    exist = false;
                  });
                  service.checkCart(widget.docId);
                }
                if(_quantity>1){
                  setState(() {
                    _quantity--;
                  });
                  var total = _quantity* widget.snapshot!['price'];
                  service.updateCart(widget.docId, _quantity, total).then((value){
                    updating = false;
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.red),
                ),
                child:  Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: _quantity ==1? const Icon(Icons.delete): const Icon(Icons.remove),
                ),
              ),
            ),
             Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
              child: updating ?
               SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),)
                  :Text('$_quantity'.toString()),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  updating = true;
                  _quantity++;
                });
                var total = _quantity* widget.snapshot!['price'];
                service.updateCart(widget.docId, _quantity,total ).then((value){
                  updating = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.red),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ),
    ) : AddToCartWidget(snapshot: widget.snapshot,);
  }
}
