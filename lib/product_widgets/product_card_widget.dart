import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:zarea_user/screens/product_detail.dart';

import '../widgets/counter_widget/another_counter.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot? snapshot;
  const ProductCard({Key? key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textSize = MediaQuery.textScaleFactorOf(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    String offer = ((snapshot!['comapredPrice'] - snapshot!['price'])/snapshot!['comapredPrice']*100)
        .toStringAsFixed(0);
    return Container(
      height: 185,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              InkWell(
                onTap: (){
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: const RouteSettings(name: ProductDetail.id),
                    screen:  ProductDetail(document: snapshot,),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 140,
                    width: 130,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: '${snapshot!['productImage']}',
                          child: Image.network('${snapshot!['productImage']}',
                            fit: BoxFit.cover,),
                        )),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('$offer% OFF',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: textSize*12,
                        fontWeight: FontWeight.bold,
                      )
                  ),),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${snapshot!['brand']}',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: textSize*14,
                          fontWeight: FontWeight.bold,
                        )
                    ),),
                    const SizedBox(height: 5,),
                    Text('${snapshot!['productName']}', style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: textSize*14,
                          fontWeight: FontWeight.bold,
                        )
                    ),),
                    const SizedBox(height: 5,),
                    Container(
                      width: width-160,
                      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey.shade400,
                      ),
                      child: Text('${snapshot!['weight']}Kg', style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: textSize*14,
                            fontWeight: FontWeight.bold,
                          )
                      ),),
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        Text('Rs:${snapshot!['price'].toString()}', style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: textSize*14,
                              fontWeight: FontWeight.bold,
                            )
                        ),),
                        const SizedBox(width: 10,),
                        Text('Rs:${snapshot!['comapredPrice'].toString()}',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              decoration: TextDecoration.lineThrough,
                                fontSize: textSize*12,
                                color: Colors.grey
                            )
                        ),),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){

                          },
                          child: SizedBox(
                            width: width-160,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children:  [
                                AnotherCounter(snapshot: snapshot,)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
