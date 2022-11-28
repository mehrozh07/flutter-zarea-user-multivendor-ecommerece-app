import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zarea_user/widgets/counter_widget/another_counter.dart';

class CartCard extends StatelessWidget {
  final DocumentSnapshot? snapshot;
  const CartCard({Key? key,this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int saving = snapshot!['comapredPrice']-snapshot!['price'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300))
        ),
        height: 120,
        child: Stack(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 1200,
                  width: 120,
                  child: Image.network('${snapshot?['productImage']}',
                    fit: BoxFit.fill,
                    height: 80, width: 80,)
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${snapshot!['productName']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                      const SizedBox(height: 5,),
                      Text('Weight:${snapshot!['weight']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                      const SizedBox(height: 5,),
                      Text('Rs.${snapshot!['price']}',
                        style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),),
                      const SizedBox(height: 5,),
                      Text('${snapshot!['comapredPrice']}',
                      style: const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough),),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
            bottom: 0,
                child:
            AnotherCounter(snapshot: snapshot,),
            ),
             if(saving>0)
             Positioned(
                child: FittedBox(
                  child: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    child: Text(
                      saving.toStringAsFixed(0),
                    style: const TextStyle(
                      color: Colors.white,
                    ),),
            ),
                ))
          ],
        ),
      ),
    );
  }
}
